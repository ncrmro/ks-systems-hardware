import anchorscad as ad
from anchorscad import datatree
from typing import Optional
from dataclasses import field

from config import PicoDimensions
from registry import register_part
from parts.motherboard_assembly import MotherboardAssemblyPico
from parts.pico_shell import PicoBottomShell, PicoTopShell

@register_part("pico_assembly")
def create_pico_assembly() -> ad.Shape:
    return PicoAssembly(dim=PicoDimensions())

@ad.shape
@datatree
class PicoAssembly(ad.CompositeShape):
    """
    Full Assembly for Pico Case.
    """
    dim: PicoDimensions
    
    def build(self) -> ad.Maker:
        # 1. Bottom Shell
        # Positioned so bottom face is at Z=0.
        # Shell build() is centered. Z=wall/2 is floor center.
        # So Z=0 is floor bottom.
        
        bottom_shell = PicoBottomShell(dim=self.dim)
        wall = self.dim.wall_thickness
        
        # BottomShell center Z is 0 (in its local coords). 
        # But we defined it as floor centered at 0. So it straddles 0.
        # Let's verify.
        # floor = Box([w, d, wall]).at("centre").
        # Center of box is 0,0,0. Z ranges -wall/2 to wall/2.
        # Perfect.
        
        assembly = bottom_shell.solid("bottom_shell").at("centre")
        
        # 2. Motherboard Assembly
        # Sits on standoffs.
        # Standoff height from floor top (wall/2).
        # Mobo assembly origin is PCB center.
        # Z pos = wall/2 (floor top) + standoff_height + pcb_thickness/2.
        
        mobo_assy = MotherboardAssemblyPico(dim=self.dim)
        mobo_z = wall/2 + self.dim.standoff_height + self.dim.mobo.pcb_thickness/2
        
        assembly.add_at(
            mobo_assy.solid("mobo_assembly").at("centre"),
            post=ad.translate([0, 0, mobo_z])
        )
        
        # 3. Top Shell
        # Top plate center Z is h - wall/2?
        # In PicoTopShell, top plate is at 0,0,0 (local).
        # We need to lift it.
        # Case Height = pico_exterior_height.
        # Top plate center Z should be (Height - wall/2) relative to Bottom(0).
        # But our Assembly origin is Bottom center (0,0,0) (which is floor center).
        # Wait, if Bottom Shell floor is at 0,0,0, then bottom surface is -wall/2.
        # Case Height starts from -wall/2.
        # Top surface is -wall/2 + Height.
        # Top plate center is -wall/2 + Height - wall/2 = Height - wall.
        
        top_shell = PicoTopShell(dim=self.dim)
        top_z = self.dim.pico_exterior_height - wall
        
        assembly.add_at(
            top_shell.solid("top_shell").at("centre"),
            post=ad.translate([0, 0, top_z])
        )
        
        return assembly
