import anchorscad as ad
from anchorscad import datatree
from typing import Optional
from dataclasses import field

from config import PicoDimensions
from registry import register_part

@register_part("pico_shell_bottom")
def create_pico_shell_bottom() -> ad.Shape:
    return PicoBottomShell(dim=PicoDimensions())

@register_part("pico_shell_top")
def create_pico_shell_top() -> ad.Shape:
    return PicoTopShell(dim=PicoDimensions())

@ad.shape
@datatree
class PicoBottomShell(ad.CompositeShape):
    """
    Placeholder for Pico Bottom Shell (Bottom + Back + Sides).
    """
    dim: PicoDimensions
    
    def build(self) -> ad.Maker:
        # Placeholder: A simplified tray
        # Width: Exterior Width
        # Depth: Exterior Depth
        # Height: ~20mm tray?
        
        w = self.dim.pico_case_width
        d = self.dim.pico_case_depth
        h = 20.0
        wall = self.dim.wall_thickness
        
        # Floor
        floor = ad.Box([w, d, wall])
        shape = floor.solid("floor").colour("dimgray").at("centre")
        
        # Back Wall
        back = ad.Box([w, wall, h])
        # Position: Back edge (Y = d/2), centered on X, Sitting on floor?
        # Floor is centered at Z=0. Top face Z=wall/2.
        shape.add_at(
            back.solid("back_wall").colour("dimgray").at("centre"),
            post=ad.translate([0, d/2 - wall/2, wall/2 + h/2])
        )
        
        return shape

@ad.shape
@datatree
class PicoTopShell(ad.CompositeShape):
    """
    Placeholder for Pico Top Shell (Top + Front + Sides).
    """
    dim: PicoDimensions
    
    def build(self) -> ad.Maker:
        # Placeholder: A cover
        w = self.dim.pico_case_width
        d = self.dim.pico_case_depth
        h = self.dim.pico_exterior_height
        wall = self.dim.wall_thickness
        
        # Top Plate
        top = ad.Box([w, d, wall])
        
        # Lifted to top height
        # Bottom shell was at Z=0 (center).
        # We want top plate at Z = h - wall/2?
        # Let's align assembly so Z=0 is bottom of case.
        # So BottomShell floor center is Z=wall/2.
        # TopShell top plate center is Z = h - wall/2.
        
        shape = top.solid("top_plate").colour("gray").at("centre")
        
        # Front Wall
        front = ad.Box([w, wall, h])
        shape.add_at(
            front.solid("front_wall").colour("gray").at("centre"),
            post=ad.translate([0, -(d/2 - wall/2), -h/2 + wall/2])
        )
        
        return shape
