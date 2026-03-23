"""Tower case assembly — inverted IO, PSU on top, vertical GPU.

Layout (looking from front):
  LEFT:   Heatsink extends outward ← Motherboard (vertical, component side right)
  CENTER: Inside mobo chamber frame columns
  RIGHT:  GPU standing tall vertically, IO facing down
  TOP:    SFX PSU + exhaust fan
  BOTTOM: IO panel (mobo IO + GPU IO both face down)

Coordinate convention: Origin = center of mobo chamber XY.
All components placed relative to mobo chamber center.
GPU chamber is in +X direction.
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
    return TowerAssembly(dim=TowerDimensions(), explode=50.0)


@ad.shape
@datatree
class TowerAssembly(ad.CompositeShape):
    """Full tower case assembly."""
    dim: TowerDimensions = field(default_factory=TowerDimensions)
    explode: float = 0.0

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        vrod = self.dim.vrod_profile
        hw = self.dim.mobo_chamber_width / 2
        hd = self.dim.mobo_chamber_depth / 2

        # Panel center is offset from mobo chamber center due to GPU chamber
        gpu_extra = self.dim.gpu_chamber_width + vrod
        panel_x_offset = gpu_extra / 2

        # ── 1. Bottom panel ──
        bottom_panel = TowerBottomPanel(dim=self.dim)
        assembly = bottom_panel.solid("bottom_panel").colour([0.7, 0.8, 0.9]).at("centre")

        # The panel's geometric center is at panel_x_offset from mobo chamber center.
        # All subsequent components are placed relative to the panel center,
        # offset by -panel_x_offset to align with mobo chamber center (X=0).

        # ── 2. Frame (origin = mobo chamber center) ──
        frame = TowerFrame(dim=self.dim)
        frame_z = wall / 2 + self.explode
        assembly.add_at(
            frame.solid("frame").colour([0.6, 0.6, 0.6]).at("origin", "centre"),
            "bottom_panel", "centre",
            post=ad.translate([-panel_x_offset, 0, frame_z])
        )

        # Helper: mobo-chamber-centered position relative to panel
        def mobo_pos(x, y, z):
            return ad.translate([-panel_x_offset + x, y, z])

        # ── 3. Motherboard (VERTICAL on left wall, component side faces +X) ──
        mobo = MiniItxMotherboard()
        # Mobo stands upright against the left columns
        # Z center = bottom of usable space + half mobo height
        mobo_z_base = wall / 2 + self.dim.io_clearance_zone
        mobo_z = mobo_z_base + self.dim.mobo.width / 2  # mobo.width becomes height when rotated
        mobo_x = -hw / 2  # Left side of mobo chamber

        assembly.add_at(
            mobo.solid("motherboard").colour([0.1, 0.6, 0.1]).at("centre"),
            "bottom_panel", "centre",
            post=mobo_pos(mobo_x, 0, mobo_z + 2 * self.explode)
                 * ad.rotY(90)  # Stand upright
        )

        # ── 4. Cooler (extends LEFT from motherboard) ──
        cooler = NoctuaL12S()
        cooler_x = mobo_x - self.dim.cooling.nh_l12s_total_height / 2 - 5
        assembly.add_at(
            cooler.solid("cooler").colour([0.7, 0.5, 0.3]).at("centre"),
            "bottom_panel", "centre",
            post=mobo_pos(cooler_x - 2 * self.explode, 0, mobo_z + 3 * self.explode)
                 * ad.rotY(90)
        )

        # ── 5. GPU (standing VERTICAL in right chamber, IO down) ──
        gpu_box = ad.Box([
            self.dim.gpu.thickness,
            self.dim.gpu.length,
            self.dim.gpu.height
        ])
        # GPU X = right chamber center (between mobo-right columns and GPU columns)
        gpu_x = hw + vrod / 2 + self.dim.gpu_chamber_width / 2
        gpu_z = mobo_z_base + self.dim.gpu.height / 2

        assembly.add_at(
            gpu_box.solid("gpu").colour([0.7, 0.15, 0.15]).at("centre"),
            "bottom_panel", "centre",
            post=mobo_pos(gpu_x, 0, gpu_z + 4 * self.explode)
        )

        # ── 6. SFX PSU (on top shelf, inside mobo chamber) ──
        psu = SfxPsu()
        psu_shelf_z = (wall / 2 + self.dim.io_clearance_zone
                       + self.dim.standoff_height + self.dim.mobo.pcb_thickness
                       + self.dim.mobo_to_psu_gap)
        psu_z = psu_shelf_z + self.dim.psu.height / 2

        assembly.add_at(
            psu.solid("psu").colour([0.2, 0.2, 0.7]).at("centre"),
            "bottom_panel", "centre",
            post=mobo_pos(0, 0, psu_z + 5 * self.explode)
        )

        # ── 7. Exhaust fan (top-back of mobo chamber) ──
        fan = Fan(dim=FAN_120_25)
        fan_z = self.dim.total_height - wall - self.dim.fan_depth / 2

        assembly.add_at(
            fan.solid("exhaust_fan").colour([0.25, 0.25, 0.25]).at("centre"),
            "bottom_panel", "centre",
            post=mobo_pos(0, hd / 2, fan_z + 6 * self.explode)
        )

        return assembly
