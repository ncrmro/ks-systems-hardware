import anchorscad as ad
from anchorscad import datatree
from typing import Optional, Literal
from dataclasses import field

from config import PicoDimensions
from registry import register_part
from parts.dovetail import FemaleDovetail

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
    center_cutout: bool = False
    with_dovetails: bool = True
    
    def build(self) -> ad.Maker:
        # Dimensions matching bottom_panel_pico.scad
        panel_width = self.dim.pico_case_width
        # exterior_panel_depth = pico_case_depth - wall_thickness
        panel_depth = self.dim.pico_case_depth
        panel_thickness = self.dim.wall_thickness
        standoff_x_offset = self.dim.wall_thickness

        # Main Panel
        # Create at [0,0,0] to match SCAD coordinates logic
        panel = ad.Box([panel_width, panel_depth, panel_thickness])
        shape = panel.solid("panel").colour("gray").at("centre")
        
        # Adjust offset for centered panel
        # Panel origin is now center.
        # Top-left corner (0,0 in SCAD) is now (-panel_width/2, -panel_depth/2).
        # So we need to subtract half dimensions from absolute coordinates.
        x_offset_center = -panel_width / 2
        y_offset_center = -panel_depth / 2
        
        # Center Cutout
        if self.center_cutout:
            cutout_size = 125.0
            cutout_x = (self.dim.mobo.width - cutout_size) / 2 + standoff_x_offset + x_offset_center
            cutout_y = (self.dim.mobo.depth - cutout_size) / 2 + y_offset_center
            
            # Use hole() for subtraction
            cutout = ad.Box([cutout_size, cutout_size, panel_thickness + 0.2])
            cutout_shape = cutout.hole("cutout").at("centre")
            
            # Position hole relative to shape origin
            # cutout_shape is centered. translate it to cutout_x, cutout_y.
            # But cutout_x/y is top-left of cutout? No, calculated above.
            # Let's re-calculate center-to-center offset.
            
            # Center of cutout in SCAD coords:
            # cx = (mobo_width - size)/2 + off + size/2
            # cy = (mobo_depth - size)/2 + size/2
            
            cx_scad = (self.dim.mobo.width - cutout_size) / 2 + standoff_x_offset + cutout_size/2
            cy_scad = (self.dim.mobo.depth - cutout_size) / 2 + cutout_size/2
            
            cx_rel = cx_scad + x_offset_center
            cy_rel = cy_scad + y_offset_center
            
            shape.add_at(
                cutout_shape,
                post=ad.translate([cx_rel, cy_rel, 0])
            )

        # Standoff Bosses and Holes
        for i, loc in enumerate(self.dim.standoff_locations):
            # loc is (x, y) from top-left of mobo? No, standoff_locations in config are absolute SCAD coords (0..170).
            x_scad, y_scad = loc
            x_scad += standoff_x_offset
            y_scad += standoff_x_offset # Applied offset for case walls
            
            x_rel = x_scad + x_offset_center
            y_rel = y_scad + y_offset_center
            
            # Boss
            boss_h = self.dim.standoff_boss_height
            boss_d = self.dim.standoff_boss_diameter
            
            # Boss Cylinder (fn=6 for hex boss as per SCAD)
            boss = ad.Cylinder(r=boss_d/2, h=boss_h, fn=6)
            boss_shape = boss.solid(f"boss_{i}").colour("dimgray").at("centre")
            
            # Position boss on top of panel
            # Panel top is at Z = panel_thickness/2.
            # Boss center (for ad.Cylinder default 0..h) is at h/2.
            # We want boss bottom (0) at panel top (t/2).
            # So Z_global_center = t/2 + h/2.
            
            shape.add_at(
                boss_shape,
                post=ad.translate([x_rel, y_rel, panel_thickness/2 + boss_h/2])
            )
            
            # Hex Pocket for Standoff Base
            pocket_depth = self.dim.standoff_pocket_depth
            hex_flat = self.dim.standoff_hex_size_flat_to_flat
            pocket_r = hex_flat / 1.73205
            
            pocket = ad.Cylinder(r=pocket_r, h=pocket_depth + 0.1, fn=6)
            pocket_shape = pocket.hole(f"pocket_{i}").at("centre")
            
            # Position pocket at top of boss
            # Top of boss is at Z = t/2 + boss_h.
            # Pocket should start at Z = t/2 + boss_h - pocket_depth.
            # Pocket height is h_p = depth + 0.1.
            # We want Pocket Bottom to be at `t/2 + boss_h - pocket_depth`.
            # Z_global_center = (t/2 + boss_h - pocket_depth) + h_p/2.
            
            pocket_h = pocket_depth + 0.1
            pocket_z = (panel_thickness/2 + boss_h - pocket_depth) + pocket_h/2
            
            shape.add_at(
                pocket_shape,
                post=ad.translate([x_rel, y_rel, pocket_z])
            )
            
            # Screw Clearance Hole
            hole_d = self.dim.standoff_screw_clearance_hole
            total_h = panel_thickness + boss_h + 0.2
            
            hole = ad.Cylinder(r=hole_d/2, h=total_h, fn=20)
            hole_shape = hole.hole(f"hole_{i}").at("centre")
            
            # Cut hole through everything.
            # Bottom at -t/2 - 0.1. Top at t/2 + boss_h + 0.1.
            # Midpoint = (Top + Bottom) / 2 = (boss_h + 0)/2 = boss_h/2.
            # So Z_center = boss_h/2.
            
            shape.add_at(
                hole_shape,
                post=ad.translate([x_rel, y_rel, boss_h/2])
            )

        # TODO: Ventilation (honeycomb)
        # if self.ventilation:
        #     pass

        # TODO: Dovetails
        if self.with_dovetails:
            from parts.dovetail import DovetailDimensions

            dd = DovetailDimensions()
            
            # Dovetail Part Origin is its Center.
            # Z range: -h/2 to +h/2.
            # To place it sitting on top of panel (Z=0 relative to panel center Z=0? No, panel center is Z=0).
            # Panel top is at Z = panel_thickness/2.
            # Dovetail base (Z=-h/2) should be at panel top (Z=t/2).
            # So Dovetail Center Z should be at Z = t/2 + h/2.
            
            dovetail_z = panel_thickness/2 + dd.scaled_dovetail_height/2

            # Back edge dovetails (clip)
            # Positions relative to center of panel.
            # Panel width W, depth D.
            # Back edge is at Y = D/2.
            # Dovetails should be flush with back edge?
            # SCAD: back_dovetail_y = depth - (dovetail_length / 2 + clearance) - wall_thickness
            # This was absolute from Y=0.
            # In relative: y_rel = y_abs - depth/2.
            # y_rel = (D - len/2 - cl - t) - D/2 = D/2 - len/2 - cl - t.
            # This puts it inside the panel.
            
            back_dovetail_y_rel = (panel_depth/2) - (dd.scaled_dovetail_length/2 + dd.scaled_clearance) - panel_thickness
            back_dovetail_positions_x_rel = [(panel_width * 0.25) - panel_width/2, (panel_width * 0.75) - panel_width/2]

            for i, x_rel in enumerate(back_dovetail_positions_x_rel):
                dovetail = FemaleDovetail(dim=dd, with_catch_windows=True)
                shape.add_at(
                    dovetail.solid(f"dovetail_back_{i}").at("centre"),
                    post=ad.translate([x_rel, back_dovetail_y_rel, dovetail_z])
                )

            # Front edge dovetails (latchless)
            front_dovetail_y_rel = (dd.scaled_dovetail_length/2 + dd.scaled_clearance) - panel_depth/2
            front_dovetail_positions_x_rel = back_dovetail_positions_x_rel

            for i, x_rel in enumerate(front_dovetail_positions_x_rel):
                dovetail = FemaleDovetail(dim=dd, with_catch_windows=False)
                shape.add_at(
                    dovetail.solid(f"dovetail_front_{i}").at("centre"),
                    post=ad.translate([x_rel, front_dovetail_y_rel, dovetail_z])
                )
            
            # Side edge dovetails
            # Side panels sit on top of the base panel, flush with outer edge.
            # Base width includes walls.
            # Side panels are `panel_thickness` thick.
            # Male dovetails from side panels are centered on side panel thickness.
            # So they are at X = +/- (panel_width/2 - panel_thickness/2).
            # They protrude -Z (down).
            # Base panel is horizontal.
            # Female dovetails should be on Top Face (Z = panel_thickness/2).
            # Channel should run along Y (Depth).
            # Channel should open? Actually, it's a hole in the floor.
            # If `FemaleDovetail` is a box with a hole.
            # Default orientation: Boss Width X, Length Y, Height Z.
            # This matches: Channel along Y. Boss Height along Z.
            # So no rotation needed for orientation.
            # Position Z: Embedded in thickness. Z=0.
            # Position X: +/- (panel_width/2 - panel_thickness/2).
            
            side_dovetail_positions_y_rel = [(panel_depth * 0.25) - panel_depth/2, (panel_depth * 0.75) - panel_depth/2]

            # Left side (X = -W/2 relative to center)
            # Center of Left Side Panel is at X = -panel_width/2 + panel_thickness/2.
            for i, y_rel in enumerate(side_dovetail_positions_y_rel):
                dovetail = FemaleDovetail(dim=dd, with_catch_windows=False, channel_direction="+Y") # Default
                shape.add_at(
                    dovetail.solid(f"dovetail_left_{i}").at("centre"),
                    post=ad.translate([-panel_width/2 + panel_thickness/2, y_rel, 0])
                )
            
            # Right side (X = W/2 relative to center)
            # Center of Right Side Panel is at X = panel_width/2 - panel_thickness/2.
            for i, y_rel in enumerate(side_dovetail_positions_y_rel):
                dovetail = FemaleDovetail(dim=dd, with_catch_windows=False, channel_direction="+Y") # Default
                shape.add_at(
                    dovetail.solid(f"dovetail_right_{i}").at("centre"),
                    post=ad.translate([panel_width/2 - panel_thickness/2, y_rel, 0])
                )


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
        width = self.dim.pico_case_width - 2 * self.dim.wall_thickness
        height = self.dim.pico_exterior_height - 2 * self.dim.wall_thickness
        thickness = self.dim.wall_thickness
        
        # Main Panel - Centered
        panel = ad.Box([width, thickness, height])
        shape = panel.solid("panel").colour("gray").at("centre")
        
        # Barrel Jack Position (Relative to center)
        # barrel_x = width - 10.0 (from left 0). Center is width/2.
        # x_rel = (width - 10) - width/2 = width/2 - 10.
        barrel_x_rel = (width / 2) - 10.0
        
        io_shield_top = self.dim.mobo.io_shield_z_offset + self.dim.mobo.io_shield_height
        # barrel_z = (io_shield_top + height) / 2.0 (absolute height?).
        # Assuming Z=0 is bottom edge in SCAD logic.
        # Height is centered. Z_rel = Z_abs - height/2.
        barrel_z_abs = (io_shield_top + height) / 2.0
        barrel_z_rel = barrel_z_abs - (height / 2)
        
        barrel_d = 7.0
        
        # Barrel Jack Hole
        hole = ad.Cylinder(r=barrel_d/2, h=thickness + 0.2, fn=20)
        hole_shape = hole.hole("barrel_jack").at("centre")
        
        shape.add_at(
            hole_shape,
            post=ad.translate([barrel_x_rel, 0, barrel_z_rel]) * ad.rotX(90)
        )
        
        # Dovetails
        from parts.dovetail import DovetailDimensions, MaleDovetail
        dd = DovetailDimensions()

        # Male dovetails to bottom (connects to PicoBasePanel's +Y channel)
        # Positions: 25% and 75% of back panel width.
        bottom_dovetail_positions_x_rel = [(width * 0.25) - width/2, (width * 0.75) - width/2]
        
        for i, x_rel in enumerate(bottom_dovetail_positions_x_rel):
            dovetail = MaleDovetail(dim=dd, with_latch=False)
            shape.add_at(
                dovetail.solid(f"dovetail_bottom_{i}").at("centre"),
                post=ad.translate([x_rel, -thickness/2, -height/2 + dd.scaled_dovetail_length/2]) * ad.rotZ(90) * ad.rotX(90)
            )
        
        # Side dovetails (male clips to PicoSidePanel)
        side_dovetail_positions_z_rel = [(height * 0.25) - height/2, (height * 0.75) - height/2]
        
        # Left side (protrudes -X)
        for i, z_rel in enumerate(side_dovetail_positions_z_rel):
            dovetail = MaleDovetail(dim=dd, with_latch=True)
            shape.add_at(
                dovetail.solid(f"dovetail_side_left_{i}").at("centre"),
                post=ad.translate([-width/2, 0, z_rel]) * ad.rotY(-90) * ad.rotX(90)
            )
        
        # Right side (protrudes +X)
        for i, z_rel in enumerate(side_dovetail_positions_z_rel):
            dovetail = MaleDovetail(dim=dd, with_latch=True)
            shape.add_at(
                dovetail.solid(f"dovetail_side_right_{i}").at("centre"),
                post=ad.translate([width/2, 0, z_rel]) * ad.rotY(90) * ad.rotX(90)
            )
        
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
        height = self.dim.pico_exterior_height - 2 * self.dim.wall_thickness
        depth = self.dim.pico_case_depth
        thickness = self.dim.wall_thickness
        
        # Main Panel - Centered
        panel = ad.Box([depth, height, thickness])
        shape = panel.solid("panel").colour("gray").at("centre")
        
        # Dovetails
        from parts.dovetail import DovetailDimensions, FemaleDovetail, MaleDovetail
        dd = DovetailDimensions()
        
        # Back edge dovetails (Female, receives BackPanel males)
        side_dovetail_positions_y_rel = [(height * 0.25) - height/2, (height * 0.75) - height/2]

        for i, y_rel in enumerate(side_dovetail_positions_y_rel):
            dovetail = FemaleDovetail(dim=dd, with_catch_windows=True)
            # Reverted to "Correct" state: Face-embedded (Hole in Z).
            # Placed at edge (depth/2).
            # Note: "Before" state used `post=ad.translate([depth/2, y_rel, 0])`.
            # This cuts a hole centered on the edge.
            shape.add_at(
                dovetail.solid(f"dovetail_back_{i}").at("centre"),
                post=ad.translate([depth/2, y_rel, 0])
            )

        # Bottom edge dovetails (Male, connects to Base)
        bottom_dovetail_positions_x_rel = [(depth * 0.25) - depth/2, (depth * 0.75) - depth/2]
        
        for i, x_rel in enumerate(bottom_dovetail_positions_x_rel):
            dovetail = MaleDovetail(dim=dd, with_latch=False)
            # Fix: Edge Facing (-Y).
            # rotZ(-90) -> Length X.
            # rotX(90) -> Extrusion -Y.
            shape.add_at(
                dovetail.solid(f"dovetail_bottom_{i}").at("centre"),
                post=ad.translate([x_rel, -height/2, 0]) * ad.rotZ(-90) * ad.rotX(90)
            )

        # Top edge dovetails (Female, for Top)
        for i, x_rel in enumerate(bottom_dovetail_positions_x_rel):
            dovetail = FemaleDovetail(dim=dd, with_catch_windows=False)
            # Fix: Edge Facing (+Y).
            # rotZ(-90) -> Channel X.
            # rotX(-90) -> Opening +Y.
            shape.add_at(
                dovetail.solid(f"dovetail_top_{i}").at("centre"),
                post=ad.translate([x_rel, height/2, 0]) * ad.rotZ(-90) * ad.rotX(-90)
            )
            
        # Front edge (Female, for Front)
        for i, y_rel in enumerate(side_dovetail_positions_y_rel):
            dovetail = FemaleDovetail(dim=dd, with_catch_windows=False)
            # Reverted to "Correct" state: Face-embedded (Hole in Z).
            # Placed at edge (-depth/2).
            shape.add_at(
                dovetail.solid(f"dovetail_front_{i}").at("centre"),
                post=ad.translate([-depth/2, y_rel, 0])
            )

        
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