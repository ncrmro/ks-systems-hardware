import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

from config import PicoDimensions
from registry import register_part
from vitamins.motherboard_assembly import MotherboardAssemblyPico
from components.case_pico import PicoBasePanel, PicoTopShell

@register_part("pico_base_assembly", part_type="assembly")
def create_pico_base_assembly() -> ad.Shape:
    return PicoBaseAssembly(dim=PicoDimensions())

@register_part("pico_assembly", part_type="assembly")
def create_pico_assembly() -> ad.Shape:
    return PicoAssembly(dim=PicoDimensions())

@register_part("pico_assembly_exploded", part_type="assembly")
def create_pico_assembly_exploded() -> ad.Shape:
    return PicoAssembly(dim=PicoDimensions(), explode=30.0)

@register_part("pico_assembly_hdd", part_type="assembly")
def create_pico_assembly_hdd() -> ad.Shape:
    return PicoAssembly(dim=PicoDimensions(), with_hdd=True)

@register_part("pico_assembly_hdd_exploded", part_type="assembly")
def create_pico_assembly_hdd_exploded() -> ad.Shape:
    return PicoAssembly(dim=PicoDimensions(), with_hdd=True, explode=30.0)

@ad.shape
@datatree
class PicoBaseAssembly(ad.CompositeShape):
    """
    Base panel with motherboard assembly. No top shell.
    Useful for verifying motherboard fit and IO alignment on the base panel.
    """
    dim: PicoDimensions

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness

        base_panel = PicoBasePanel(dim=self.dim)
        assembly = base_panel.solid("base_panel").at("centre")

        mobo_assy = MotherboardAssemblyPico(dim=self.dim)
        mobo_z = wall / 2 + self.dim.standoff_height + self.dim.mobo.pcb_thickness / 2

        assembly.add_at(
            mobo_assy.solid("mobo_assembly").at("centre"),
            post=ad.translate([0, 0, mobo_z])
        )

        return assembly


@ad.shape
@datatree
class PicoAssembly(ad.CompositeShape):
    """
    Full Assembly for Pico Case.
    Two-piece design: base panel + top shell.
    When explode > 0, components are separated vertically for visibility.
    """
    dim: PicoDimensions
    with_hdd: bool = False
    explode: float = 0.0

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness

        if self.with_hdd:
            exterior_height = self.dim.pico_exterior_height_hdd
        else:
            exterior_height = self.dim.pico_exterior_height

        # 1. Base Panel
        # Panel is centered at origin. Z spans -wall/2 to +wall/2.
        base_panel = PicoBasePanel(dim=self.dim, with_hdd=self.with_hdd)
        assembly = base_panel.solid("base_panel").at("centre")

        # 2. Motherboard Assembly
        # Sits on standoffs above the base panel.
        # Z pos = wall/2 (panel top) + standoff_height + pcb_thickness/2
        mobo_assy = MotherboardAssemblyPico(dim=self.dim)
        mobo_z = wall / 2 + self.dim.standoff_height + self.dim.mobo.pcb_thickness / 2
        mobo_z += self.explode  # exploded gap above base panel

        assembly.add_at(
            mobo_assy.solid("mobo_assembly").at("centre"),
            post=ad.translate([0, 0, mobo_z])
        )

        # 3. Top Shell
        # Shell height = exterior_height - wall (base panel thickness).
        # Shell is centered in its local coords.
        # Shell bottom (open) should sit on top of the base panel.
        # Base panel top is at Z = +wall/2.
        # Shell center Z should be at: wall/2 + shell_height/2
        shell_height = exterior_height - wall
        top_shell = PicoTopShell(dim=self.dim, with_hdd=self.with_hdd)
        top_z = wall / 2 + shell_height / 2
        top_z += 2 * self.explode  # exploded gap above motherboard

        assembly.add_at(
            top_shell.solid("top_shell").at("centre"),
            post=ad.translate([0, 0, top_z])
        )

        return assembly
