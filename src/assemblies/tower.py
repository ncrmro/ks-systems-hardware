"""Tower case assembly — inverted IO, PSU on top, vertical GPU chamber.

Composes TowerFrame + TowerBottomPanel + existing vitamins (motherboard, PSU,
cooler, fan) into a complete tower assembly with exploded view variant.
"""
import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

from config import TowerDimensions
from registry import register_part
from components.case_tower import TowerFrame, TowerBottomPanel
from vitamins.motherboard import MiniItxMotherboard
from vitamins.psu import SfxPsu
from vitamins.heatsink import NoctuaL12S
from vitamins.cooling import Fan, FAN_120_25


@register_part("tower_assembly", part_type="assembly")
def create_tower_assembly() -> ad.Shape:
    return TowerAssembly(dim=TowerDimensions())


@register_part("tower_assembly_exploded", part_type="assembly")
def create_tower_assembly_exploded() -> ad.Shape:
    return TowerAssembly(dim=TowerDimensions(), explode=40.0)


@ad.shape
@datatree
class TowerAssembly(ad.CompositeShape):
    """Full tower case assembly with inverted motherboard.

    Vertical stack (bottom to top):
    - Bottom panel (IO cutout, C14 inlet)
    - IO clearance zone (cables plug in from below)
    - Motherboard (inverted — IO faces down)
    - CPU cooler (NH-L12S, 70mm)
    - SFX PSU
    - 120mm exhaust fan

    V-rod frame runs full height at corners.
    When explode > 0, components separate vertically for visualization.
    """
    dim: TowerDimensions = field(default_factory=TowerDimensions)
    explode: float = 0.0

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness

        # 1. Bottom panel is the reference (Z=0 at panel center)
        bottom_panel = TowerBottomPanel(dim=self.dim)
        assembly = bottom_panel.solid("bottom_panel").at("centre")

        # 2. V-rod frame — sits on top of bottom panel
        frame = TowerFrame(dim=self.dim)
        frame_height = self.dim.total_height - 2 * wall
        frame_z = wall / 2 + frame_height / 2
        frame_z += self.explode

        assembly.add_at(
            frame.solid("frame").colour([0.6, 0.6, 0.6]).at("centre"),
            post=ad.translate([0, 0, frame_z])
        )

        # 3. Motherboard (inverted — component side up, IO hangs below)
        mobo = MiniItxMotherboard()
        # Mobo sits above IO clearance zone + standoffs
        mobo_z = (wall / 2
                  + self.dim.io_clearance_zone
                  + self.dim.standoff_height
                  + self.dim.mobo.pcb_thickness / 2)
        mobo_z += 2 * self.explode

        assembly.add_at(
            mobo.solid("motherboard").colour([0.1, 0.5, 0.1]).at("centre"),
            post=ad.translate([0, 0, mobo_z])
        )

        # 4. CPU cooler — on top of motherboard
        cooler = NoctuaL12S()
        cooler_z = (mobo_z
                    + self.dim.mobo.pcb_thickness / 2
                    + self.dim.cooling.nh_l12s_total_height / 2)
        cooler_z += 3 * self.explode

        assembly.add_at(
            cooler.solid("cooler").colour([0.7, 0.5, 0.3]).at("centre"),
            post=ad.translate([0, 0, cooler_z])
        )

        # 5. SFX PSU — above cooler gap
        psu = SfxPsu()
        psu_z = (wall / 2
                 + self.dim.io_clearance_zone
                 + self.dim.standoff_height
                 + self.dim.mobo.pcb_thickness
                 + self.dim.mobo_to_psu_gap
                 + self.dim.psu.height / 2)
        psu_z += 4 * self.explode

        assembly.add_at(
            psu.solid("psu").at("centre"),
            post=ad.translate([0, 0, psu_z])
        )

        # 6. Exhaust fan — at top back
        fan = Fan(dim=FAN_120_25)
        fan_z = (self.dim.total_height
                 - wall
                 - self.dim.fan_depth / 2)
        fan_z += 5 * self.explode

        assembly.add_at(
            fan.solid("exhaust_fan").colour([0.3, 0.3, 0.3]).at("centre"),
            post=ad.translate([
                0,
                self.dim.mobo_chamber_depth / 2 - self.dim.fan_depth / 2,
                fan_z
            ])
        )

        return assembly
