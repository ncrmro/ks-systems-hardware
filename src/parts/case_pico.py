import anchorscad as ad
from anchorscad import datatree
from typing import Optional, Literal
from dataclasses import field

from config import PicoDimensions
from registry import register_part

@register_part("parts_case_pico_base_panel")
def create_pico_base_panel() -> ad.Shape:
    return PicoBasePanel(dim=PicoDimensions())

@register_part("parts_case_pico_back_panel")
def create_pico_back_panel() -> ad.Shape:
    return PicoBackPanel(dim=PicoDimensions())

@register_part("parts_case_pico_side_panel_left")
def create_pico_side_panel_left() -> ad.Shape:
    return PicoSidePanel(dim=PicoDimensions(), side="left")

@register_part("parts_case_pico_side_panel_right")
def create_pico_side_panel_right() -> ad.Shape:
    return PicoSidePanel(dim=PicoDimensions(), side="right")


@ad.shape
@datatree
class PicoBasePanel(ad.CompositeShape):
    """
    Base panel for Pico configuration.
    Corresponds to modules/case/panels/standard/bottom_pico.scad
    """
    dim: PicoDimensions
    
    # Options
    ventilation: bool = False
    center_cutout: bool = True
    with_dovetails: bool = True
    
    def build(self) -> ad.Maker:
        # Dimensions matching bottom_panel_pico.scad
        panel_width = self.dim.pico_case_width
        # exterior_panel_depth = pico_case_depth - wall_thickness
        panel_depth = self.dim.pico_case_depth - self.dim.wall_thickness
        panel_thickness = self.dim.wall_thickness
        standoff_x_offset = self.dim.wall_thickness

        # Main Panel
        # Create at [0,0,0] to match SCAD coordinates logic
        panel = ad.Box([panel_width, panel_depth, panel_thickness])
        shape = panel.solid("panel").colour("gray").at("centre", post=ad.translate([panel_width/2, panel_depth/2, panel_thickness/2]))
        
        # Center Cutout
        if self.center_cutout:
            cutout_size = 125.0
            # cutout_x = (mobo_width - cutout_size) / 2 + standoff_x_offset
            cutout_x = (self.dim.mobo.width - cutout_size) / 2 + standoff_x_offset
            cutout_y = (self.dim.mobo.depth - cutout_size) / 2
            
            # Use hole() for subtraction
            cutout = ad.Box([cutout_size, cutout_size, panel_thickness + 0.2])
            cutout_shape = cutout.hole("cutout").at("centre", post=ad.translate([cutout_size/2, cutout_size/2, (panel_thickness + 0.2)/2]))
            
            # Position hole relative to shape origin
            # shape origin is at 0,0,0 (min corner of panel)
            shape.add_at(
                cutout_shape,
                post=ad.translate([cutout_x, cutout_y, -0.1])
            )

        # Standoff Bosses and Holes
        for i, loc in enumerate(self.dim.standoff_locations):
            x, y = loc
            x += standoff_x_offset
            
            # Boss
            boss_h = self.dim.standoff_boss_height
            boss_d = self.dim.standoff_boss_diameter
            
            # Boss Cylinder (fn=6 for hex boss as per SCAD)
            boss = ad.Cylinder(r=boss_d/2, h=boss_h, fn=6)
            boss_shape = boss.solid(f"boss_{i}").colour("dimgray").at("base")
            
            # Position boss on top of panel (Z=panel_thickness)
            shape.add_at(
                boss_shape,
                post=ad.translate([x, y, panel_thickness])
            )
            
            # Hex Pocket for Standoff Base
            pocket_depth = self.dim.standoff_pocket_depth
            hex_flat = self.dim.standoff_hex_size_flat_to_flat
            # r = flat / sqrt(3)
            pocket_r = hex_flat / 1.73205
            
            pocket = ad.Cylinder(r=pocket_r, h=pocket_depth + 0.1, fn=6)
            pocket_shape = pocket.hole(f"pocket_{i}").at("base")
            
            # Position pocket at top of boss
            shape.add_at(
                pocket_shape,
                post=ad.translate([x, y, panel_thickness + boss_h - pocket_depth])
            )
            
            # Screw Clearance Hole
            hole_d = self.dim.standoff_screw_clearance_hole
            # Through panel and boss
            total_h = panel_thickness + boss_h + 0.2
            
            hole = ad.Cylinder(r=hole_d/2, h=total_h, fn=20)
            hole_shape = hole.hole(f"hole_{i}").at("base")
            
            # Cut hole
            shape.add_at(
                hole_shape,
                post=ad.translate([x, y, -0.1])
            )

        # TODO: Ventilation (honeycomb)
        # if self.ventilation:
        #     pass

        # TODO: Dovetails
        # The SCAD file uses female_dovetail from modules/util/dovetail
        # Porting dovetail logic requires implementing the trapezoidal geometry.
        # Leaving as TODO for now as requested by user (implied "initial" panel).
        if self.with_dovetails:
             # Back edge dovetails (clip)
             # Front edge dovetails (latchless)
             pass

        return shape


@ad.shape
@datatree
class PicoBackPanel(ad.CompositeShape):
    """
    Back panel for Pico configuration.
    Corresponds to modules/case/panels/standard/back_pico.scad
    
    Includes hole for barrel jack.
    """
    dim: PicoDimensions
    
    def build(self) -> ad.Maker:
        # Dimensions matching back_pico.scad logic
        # Width: Interior Width (fits between sides)
        # Height: Side Panel Height (fits between top/bottom)
        
        # From dimensions_pico.scad:
        # interior_panel_width = pico_case_width - 2 * wall_thickness
        # side_panel_height = pico_exterior_height - 2 * wall_thickness
        
        width = self.dim.pico_case_width - 2 * self.dim.wall_thickness
        height = self.dim.pico_exterior_height - 2 * self.dim.wall_thickness
        thickness = self.dim.wall_thickness
        
        # Barrel Jack Position
        # pico_barrel_jack_x = interior_panel_width - 10
        # pico_barrel_jack_z = (io_shield_top + back_panel_height) / 2
        # where io_shield_top = io_shield_z_offset + io_shield_height
        
        barrel_x = width - 10.0
        
        io_shield_top = self.dim.mobo.io_shield_z_offset + self.dim.mobo.io_shield_height
        barrel_z = (io_shield_top + height) / 2.0
        barrel_d = 7.0 # 7mm threaded hole
        
        # Main Panel
        panel = ad.Box([width, thickness, height])
        shape = panel.solid("panel").colour("gray").at("centre", post=ad.translate([width/2, thickness/2, height/2]))
        
        # Barrel Jack Hole
        hole = ad.Cylinder(r=barrel_d/2, h=thickness + 0.2, fn=20)
        # Rotate to align with Y axis (thickness)
        hole_shape = hole.hole("barrel_jack").at("centre")
        
        # Position hole
        # X: barrel_x
        # Y: thickness/2 (center of panel thickness)
        # Z: barrel_z
        
        shape.add_at(
            hole_shape,
            post=ad.translate([barrel_x, thickness/2, barrel_z]) * ad.rotX(90)
        )
        
        # TODO: Dovetails (Male to bottom, male clips to sides)
        
        return shape

@ad.shape
@datatree
class PicoSidePanel(ad.CompositeShape):
    """
    Side panel for Pico configuration.
    Corresponds to modules/case/panels/standard/side_pico.scad
    """
    dim: PicoDimensions
    side: Literal["left", "right"] = "left"
    
    def build(self) -> ad.Maker:
        # Dimensions
        # side_panel_height = pico_exterior_height - 2 * wall_thickness
        # side_panel_depth = exterior_panel_depth + wall_thickness = pico_case_depth
        
        height = self.dim.pico_exterior_height - 2 * self.dim.wall_thickness
        depth = self.dim.pico_case_depth
        thickness = self.dim.wall_thickness
        
        # Main Panel
        # Oriented in YZ plane?
        # SCAD usually renders panels flat for printing (XY).
        # But here we are building the part.
        # Let's stick to flat XY for printing/rendering standard?
        # Or oriented in assembly position?
        # The previous base panel was XY.
        # side_pico.scad seems to render it flat (based on "Standalone file for 3D printing").
        # If I want to render it flat:
        # Width (Depth of case) x Height (Height of case) x Thickness
        
        panel_w = depth
        panel_h = height
        panel_t = thickness
        
        panel = ad.Box([panel_w, panel_h, panel_t])
        shape = panel.solid("panel").colour("gray").at("centre", post=ad.translate([panel_w/2, panel_h/2, panel_t/2]))
        
        # TODO: Honeycomb ventilation
        # TODO: Dovetails
        
        return shape

@register_part("parts_case_pico_bottom_shell")
def create_pico_shell_bottom() -> ad.Shape:
    return PicoBottomShell(dim=PicoDimensions())

@register_part("parts_case_pico_top_shell")
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