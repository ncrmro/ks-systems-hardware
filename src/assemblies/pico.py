import anchorscad as ad
from anchorscad import datatree
from typing import Optional
from dataclasses import field

from config import PicoDimensions
from registry import register_part
from lib.motherboard_assembly import MotherboardAssemblyPico
from parts.case_pico import PicoBottomTray, PicoTopHat, PicoSideFlap

@register_part("pico_assembly")
def create_pico_assembly(**kwargs) -> ad.Shape:
    return PicoAssembly(dim=PicoDimensions(), **kwargs)

@ad.shape
@datatree
class PicoAssembly(ad.CompositeShape):
    """
    Full Assembly for Pico Case with hinged top hat.
    """
    dim: PicoDimensions
    exploded: bool = False
    show_panels: bool = True
    open_angle: float = 0
    
    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        w = self.dim.pico_case_width
        d = self.dim.pico_case_depth
        h_interior = self.dim.pico_interior_chamber_height
        
        # 1. Bottom Tray
        bottom_tray = PicoBottomTray(dim=self.dim)
        assembly = bottom_tray.solid("bottom_tray").at("centre")
        
        # 2. Motherboard Assembly
        mobo_assy = MotherboardAssemblyPico(dim=self.dim)
        mobo_z = wall/2 + self.dim.standoff_height + self.dim.mobo.pcb_thickness/2
        
        assembly.add_at(
            mobo_assy.solid("mobo_assembly").at("centre"),
            post=ad.translate([0, 0, mobo_z])
        )
        
        # 3. Top Hat
        if self.show_panels:
            top_hat = PicoTopHat(dim=self.dim)
            # Sits at h_interior + wall.
            # But it's hinged at the front.
            # Front hinge is at Y = -d/2, Z = wall/2.
            
            top_z = wall/2 + h_interior + wall/2
            
            if self.exploded:
                # Folded forward 90 degrees
                assembly.add_at(
                    top_hat.solid("top_hat").at("centre"),
                    post=ad.translate([0, -d/2, wall/2]) * ad.rotX(-90) * ad.translate([0, d/2, wall/2])
                )
            elif self.open_angle != 0:
                 # Rotate by open_angle
                 assembly.add_at(
                    top_hat.solid("top_hat").at("centre"),
                    post=ad.translate([0, -d/2, wall/2 + h_interior + wall]) * ad.rotX(-self.open_angle) * ad.translate([0, d/2, -wall/2])
                )
            else:
                assembly.add_at(
                    top_hat.solid("top_hat").at("centre"),
                    post=ad.translate([0, 0, top_z])
                )
                
            # 4. Side Flaps
            side_flap_left = PicoSideFlap(dim=self.dim, side="left")
            # Sits at X = -w/2 - wall/2
            # Hinged at top hat edge.
            
            if not self.exploded:
                # Left Flap
                assembly.add_at(
                    side_flap_left.solid("side_flap_left").at("centre"),
                    post=ad.translate([-w/2 - wall/2, 0, top_z - wall/2 - (h_interior + self.dim.side_wall_height)/2]) * ad.rotY(90)
                )
                
                # Right Flap
                side_flap_right = PicoSideFlap(dim=self.dim, side="right")
                assembly.add_at(
                    side_flap_right.solid("side_flap_right").at("centre"),
                    post=ad.translate([w/2 + wall/2, 0, top_z - wall/2 - (h_interior + self.dim.side_wall_height)/2]) * ad.rotY(90)
                )
        
        return assembly
