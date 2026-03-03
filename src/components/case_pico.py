import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

from config import PicoDimensions
from registry import register_part
from vitamins.storage import SSD25Dimensions

@register_part("pico_base_panel", part_type="component")
def create_pico_base_panel() -> ad.Shape:
    return PicoBasePanel(dim=PicoDimensions())

@register_part("pico_base_panel_hdd", part_type="component")
def create_pico_base_panel_hdd() -> ad.Shape:
    return PicoBasePanel(dim=PicoDimensions(), with_hdd=True)

@register_part("pico_top_shell", part_type="component")
def create_pico_top_shell() -> ad.Shape:
    return PicoTopShell(dim=PicoDimensions())

@register_part("pico_top_shell_hdd", part_type="component")
def create_pico_top_shell_hdd() -> ad.Shape:
    return PicoTopShell(dim=PicoDimensions(), with_hdd=True)


@ad.shape
@datatree
class PicoBasePanel(ad.CompositeShape):
    """
    Base panel for Pico configuration.
    L-shaped piece: flat plate with standoff bosses + back wall with IO shield
    cutout and barrel jack hole.
    """
    dim: PicoDimensions
    with_hdd: bool = False

    # Options
    ventilation: bool = False
    center_cutout: bool = False

    # Barrel jack dimensions
    barrel_jack_diameter: float = 7.0
    barrel_jack_x_inset: float = 10.0  # from right edge of interior

    # IO shield clearance (per side)
    io_shield_clearance: float = 1.0

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        panel_width = self.dim.pico_case_width
        panel_depth = self.dim.pico_case_depth
        panel_thickness = wall
        standoff_x_offset = wall

        if self.with_hdd:
            exterior_height = self.dim.pico_exterior_height_hdd
        else:
            exterior_height = self.dim.pico_exterior_height

        # Main Panel (flat base plate)
        panel = ad.Box([panel_width, panel_depth, panel_thickness])
        shape = panel.solid("panel").colour("gray").at("centre")

        x_offset_center = -panel_width / 2
        y_offset_center = -panel_depth / 2

        # Center Cutout
        if self.center_cutout:
            cutout_size = 125.0
            cx_scad = (self.dim.mobo.width - cutout_size) / 2 + standoff_x_offset + cutout_size/2
            cy_scad = (self.dim.mobo.depth - cutout_size) / 2 + cutout_size/2

            cx_rel = cx_scad + x_offset_center
            cy_rel = cy_scad + y_offset_center

            cutout = ad.Box([cutout_size, cutout_size, panel_thickness + 0.2])
            cutout_shape = cutout.hole("cutout").at("centre")

            shape.add_at(
                cutout_shape,
                post=ad.translate([cx_rel, cy_rel, 0])
            )

        # Standoff Bosses and Holes
        for i, loc in enumerate(self.dim.standoff_locations):
            x_scad, y_scad = loc
            x_scad += standoff_x_offset
            y_scad += standoff_x_offset

            x_rel = x_scad + x_offset_center
            y_rel = y_scad + y_offset_center

            # Boss
            boss_h = self.dim.standoff_boss_height
            boss_d = self.dim.standoff_boss_diameter

            boss = ad.Cylinder(r=boss_d/2, h=boss_h, fn=6)
            boss_shape = boss.solid(f"boss_{i}").colour("dimgray").at("centre")

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

            shape.add_at(
                hole_shape,
                post=ad.translate([x_rel, y_rel, boss_h/2])
            )

        # ── Back Wall ──
        # Inner width (fits between top shell side walls)
        back_wall_width = panel_width - 2 * wall
        back_wall_height = exterior_height - wall  # same as shell_height

        back_wall = ad.Box([back_wall_width, wall, back_wall_height])
        back_wall_shape = back_wall.solid("back_wall").colour("gray").at("centre")

        # Position: back edge of plate, rising from plate top surface
        # Y center: panel_depth/2 - wall/2 (flush with outer back edge)
        # Z center: panel_thickness/2 + back_wall_height/2 (bottom at plate top)
        shape.add_at(
            back_wall_shape,
            post=ad.translate([
                0,
                panel_depth / 2 - wall / 2,
                panel_thickness / 2 + back_wall_height / 2
            ])
        )

        # ── IO Shield Cutout ──
        # The IO shield is on the back of the motherboard, centered on mobo width.
        # back_wall_width == mobo width (170mm), so IO shield is centered on the wall.
        io_w = self.dim.mobo.io_shield_width + 2 * self.io_shield_clearance
        io_h = self.dim.mobo.io_shield_height + 2 * self.io_shield_clearance

        # Z position relative to back wall bottom (= plate top):
        # PCB bottom is at standoff_height above plate top
        # IO shield bottom = standoff_height + io_shield_z_offset
        io_z_from_wall_bottom = (
            self.dim.standoff_height
            + self.dim.mobo.io_shield_z_offset
            + self.dim.mobo.io_shield_height / 2
        )

        # Convert to base panel coords (Z=0 is plate center)
        io_z = panel_thickness / 2 + io_z_from_wall_bottom

        io_cutout = ad.Box([io_w, wall + 0.2, io_h])
        io_cutout_shape = io_cutout.hole("io_shield_cutout").at("centre")

        shape.add_at(
            io_cutout_shape,
            post=ad.translate([
                0,  # centered (mobo centered in case)
                panel_depth / 2 - wall / 2,
                io_z
            ])
        )

        # ── Barrel Jack Hole ──
        # X: inset from right edge of interior
        barrel_x = back_wall_width / 2 - self.barrel_jack_x_inset

        # Z: midpoint between IO shield top and interior top
        io_shield_top_from_wall_bottom = (
            self.dim.standoff_height
            + self.dim.mobo.io_shield_z_offset
            + self.dim.mobo.io_shield_height
        )
        interior_top_from_wall_bottom = exterior_height - 2 * wall
        barrel_z_from_wall_bottom = (
            io_shield_top_from_wall_bottom + interior_top_from_wall_bottom
        ) / 2.0

        barrel_z = panel_thickness / 2 + barrel_z_from_wall_bottom

        barrel_hole = ad.Cylinder(
            r=self.barrel_jack_diameter / 2, h=wall + 0.2, fn=20
        )
        barrel_hole_shape = barrel_hole.hole("barrel_jack").at("centre")

        # Hole goes through back wall (along Y axis)
        shape.add_at(
            barrel_hole_shape,
            post=ad.translate([
                barrel_x,
                panel_depth / 2 - wall / 2,
                barrel_z
            ]) * ad.rotX(90)
        )

        return shape


@ad.shape
@datatree
class PicoTopShell(ad.CompositeShape):
    """
    Top shell for Pico configuration.
    Open-back U-shape: top plate + front wall + left wall + right wall.
    Open bottom and open back (back wall is on the base panel).
    Optional HDD variant adds extra interior height and SSD mounting holes.
    """
    dim: PicoDimensions
    with_hdd: bool = False

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        w = self.dim.pico_case_width
        d = self.dim.pico_case_depth

        if self.with_hdd:
            h = self.dim.pico_exterior_height_hdd
        else:
            h = self.dim.pico_exterior_height

        shell_height = h - wall  # total height minus base panel thickness

        # Outer box
        outer = ad.Box([w, d, shell_height])
        shape = outer.solid("outer").colour("gray").at("centre")

        # Inner cavity — extends to the back face (no back wall)
        # Width: w - 2*wall (left and right walls remain)
        # Depth: d - wall (only front wall, back is open)
        # The cavity is shifted Y=+wall/2 so it extends to the back face
        # and shifted Z=-wall so the top plate remains solid
        inner_w = w - 2 * wall
        inner_d = d - wall
        inner_h = shell_height

        inner = ad.Box([inner_w, inner_d, inner_h])
        inner_shape = inner.hole("inner").at("centre")

        shape.add_at(
            inner_shape,
            post=ad.translate([0, wall / 2, -wall])
        )

        # SSD mounting holes in top plate (HDD variant only)
        if self.with_hdd:
            ssd_dim = SSD25Dimensions()

            hole_x_sep = 61.72  # mm between holes across width
            hole_y_positions = [ssd_dim.hole_front_y, ssd_dim.hole_rear_y]

            top_z = shell_height / 2
            ssd_screw_d = 3.0  # M3 clearance

            hole_idx = 0
            for y_pos in hole_y_positions:
                for x_sign in [-1, 1]:
                    x_pos = x_sign * hole_x_sep / 2
                    y_rel = y_pos - ssd_dim.length / 2  # center SSD on plate

                    ssd_hole = ad.Cylinder(r=ssd_screw_d / 2, h=wall + 0.2, fn=20)
                    ssd_hole_shape = ssd_hole.hole(f"ssd_hole_{hole_idx}").at("centre")

                    shape.add_at(
                        ssd_hole_shape,
                        post=ad.translate([x_pos, y_rel, top_z])
                    )
                    hole_idx += 1

        return shape
