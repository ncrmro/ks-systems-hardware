import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

from config import PicoDimensions
from registry import register_part
from vitamins.storage import SSD25Dimensions
from components.dovetail import DovetailDimensions, FemaleDovetail, MaleDovetail
from components.latch import LatchDimensions, LatchArm, LatchLedge


@register_part("pico_base_panel", part_type="component")
def create_pico_base_panel() -> ad.Shape:
    return PicoBasePanel(dim=PicoDimensions())

@register_part("pico_base_panel_hdd", part_type="component")
def create_pico_base_panel_hdd() -> ad.Shape:
    return PicoBasePanel(dim=PicoDimensions(), with_hdd=True)

@register_part("pico_back_panel", part_type="component")
def create_pico_back_panel() -> ad.Shape:
    return PicoBackPanel(dim=PicoDimensions())

@register_part("pico_back_panel_hdd", part_type="component")
def create_pico_back_panel_hdd() -> ad.Shape:
    return PicoBackPanel(dim=PicoDimensions(), with_hdd=True)

@register_part("pico_top_shell", part_type="component")
def create_pico_top_shell() -> ad.Shape:
    return PicoTopShell(dim=PicoDimensions())

@register_part("pico_top_shell_hdd", part_type="component")
def create_pico_top_shell_hdd() -> ad.Shape:
    return PicoTopShell(dim=PicoDimensions(), with_hdd=True)


# Dovetail positions: 25% and 75% of inner width
def _dovetail_x_positions(inner_width):
    return [-inner_width / 4, inner_width / 4]

# Latch positions: 25% and 75% of inner width
def _latch_x_positions(inner_width):
    return [-inner_width / 4, inner_width / 4]


@ad.shape
@datatree
class PicoBasePanel(ad.CompositeShape):
    """
    Base panel for Pico configuration.
    Flat plate with standoff bosses. No back wall (separate PicoBackPanel).
    Female dovetails on back edge for back panel connection.
    Latch ledges on front inner edge for top shell retention.
    """
    dim: PicoDimensions
    with_hdd: bool = False

    # Options
    ventilation: bool = False
    center_cutout: bool = False

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        panel_width = self.dim.pico_case_width
        panel_depth = self.dim.pico_case_depth
        panel_thickness = wall
        standoff_x_offset = wall
        inner_width = panel_width - 2 * wall

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

        # ── Female Dovetails on Back Edge ──
        dd = DovetailDimensions()
        boss_depth = (dd.dovetail_length + 2 * dd.dovetail_clearance
                      + 2 * dd.dovetail_boss_margin)
        for i, x_pos in enumerate(_dovetail_x_positions(inner_width)):
            female = FemaleDovetail(dim=dd)
            # Position: on top surface, inset from back edge by wall (back panel)
            # + boss_depth/2 so the boss back face is flush with the back panel
            # interior face.
            shape.add_at(
                female.solid(f"dovetail_female_{i}").at("centre"),
                post=ad.translate([
                    x_pos,
                    panel_depth / 2 - wall - boss_depth / 2,
                    panel_thickness / 2 + dd.dovetail_height / 2
                ])
            )

        # ── Latch Ledges on Front Inner Edge ──
        ld = LatchDimensions(
            arm_width=self.dim.latch_arm_width,
            hook_depth=self.dim.latch_hook_depth,
            hook_height=self.dim.latch_hook_height,
        )
        for i, x_pos in enumerate(_latch_x_positions(inner_width)):
            ledge = LatchLedge(dim=ld)
            # Position: on top surface at front inner edge, protruding inward (+Y)
            shape.add_at(
                ledge.solid(f"latch_ledge_{i}").colour("dimgray").at("centre"),
                post=ad.translate([
                    x_pos,
                    -panel_depth / 2 + wall + ld.hook_depth / 2,
                    panel_thickness / 2 + ld.hook_height / 2
                ])
            )

        return shape


@ad.shape
@datatree
class PicoBackPanel(ad.CompositeShape):
    """
    Separate back panel for Pico configuration.
    Printed flat on its back — IO cutout is a through-hole, no bridging.
    Male dovetails on bottom edge connect to base panel.
    Latch ledges on front face near top edge for top shell back retention.
    """
    dim: PicoDimensions
    with_hdd: bool = False

    # Barrel jack dimensions
    barrel_jack_diameter: float = 7.0
    barrel_jack_x_inset: float = 10.0

    # IO shield clearance (per side)
    io_shield_clearance: float = 1.0

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        panel_width = self.dim.pico_case_width
        inner_width = panel_width - 2 * wall  # 170mm

        if self.with_hdd:
            exterior_height = self.dim.pico_exterior_height_hdd
        else:
            exterior_height = self.dim.pico_exterior_height

        back_wall_height = exterior_height - wall  # same as shell_height

        # Main back wall panel: inner_width x wall x back_wall_height
        # Origin at center. The wall is thin along Y (3mm).
        panel = ad.Box([inner_width, wall, back_wall_height])
        shape = panel.solid("back_wall").colour("gray").at("centre")

        # ── IO Shield Cutout (through-hole) ──
        io_w = self.dim.mobo.io_shield_width + 2 * self.io_shield_clearance
        io_h = self.dim.mobo.io_shield_height + 2 * self.io_shield_clearance

        # Z position: standoff_height + io_shield_z_offset + io_shield_height/2
        # measured from the bottom of the wall (which is -back_wall_height/2)
        io_z_from_bottom = (
            self.dim.standoff_height
            + self.dim.mobo.io_shield_z_offset
            + self.dim.mobo.io_shield_height / 2
        )
        io_z = -back_wall_height / 2 + io_z_from_bottom

        io_cutout = ad.Box([io_w, wall + 0.2, io_h])
        shape.add_at(
            io_cutout.hole("io_shield_cutout").at("centre"),
            post=ad.translate([0, 0, io_z])
        )

        # ── Barrel Jack Hole ──
        barrel_x = inner_width / 2 - self.barrel_jack_x_inset

        io_shield_top_from_bottom = (
            self.dim.standoff_height
            + self.dim.mobo.io_shield_z_offset
            + self.dim.mobo.io_shield_height
        )
        interior_top_from_bottom = exterior_height - 2 * wall
        barrel_z_from_bottom = (
            io_shield_top_from_bottom + interior_top_from_bottom
        ) / 2.0
        barrel_z = -back_wall_height / 2 + barrel_z_from_bottom

        barrel_hole = ad.Cylinder(
            r=self.barrel_jack_diameter / 2, h=wall + 0.2, fn=20
        )
        shape.add_at(
            barrel_hole.hole("barrel_jack").at("centre"),
            post=ad.translate([barrel_x, 0, barrel_z]) * ad.rotX(90)
        )

        # ── Male Dovetails on Bottom Edge ──
        dd = DovetailDimensions()
        # Rails flush with wall interior face (-Y). Rail +Y face touches wall -Y face.
        male_y = -wall / 2 - dd.dovetail_length / 2

        for i, x_pos in enumerate(_dovetail_x_positions(inner_width)):
            male = MaleDovetail(dim=dd)
            shape.add_at(
                male.solid(f"dovetail_male_{i}").at("centre"),
                post=ad.translate([
                    x_pos,
                    male_y,
                    -back_wall_height / 2 + dd.dovetail_height / 2
                ])
            )

        # ── Latch Ledges on Front Face Near Top Edge ──
        # These protrude forward (toward -Y) so the top shell's back latch
        # arms can catch under them when the shell slides down.
        ld = LatchDimensions(
            arm_width=self.dim.latch_arm_width,
            hook_depth=self.dim.latch_hook_depth,
            hook_height=self.dim.latch_hook_height,
        )
        for i, x_pos in enumerate(_latch_x_positions(inner_width)):
            ledge = LatchLedge(dim=ld)
            shape.add_at(
                ledge.solid(f"latch_ledge_back_{i}").colour("dimgray").at("centre"),
                post=ad.translate([
                    x_pos,
                    -wall / 2 - ld.hook_depth / 2,
                    back_wall_height / 2 - ld.hook_height / 2 - wall
                ])
            )

        return shape


@ad.shape
@datatree
class PicoTopShell(ad.CompositeShape):
    """
    Top shell for Pico configuration.
    Open-back U-shape: top plate + front wall + left wall + right wall.
    Latch arms on front wall inner face and underside of top plate near
    back edge provide 4-point snap-fit retention to base + back panel.
    """
    dim: PicoDimensions
    with_hdd: bool = False

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        w = self.dim.pico_case_width
        d = self.dim.pico_case_depth
        inner_width = w - 2 * wall

        if self.with_hdd:
            h = self.dim.pico_exterior_height_hdd
        else:
            h = self.dim.pico_exterior_height

        shell_height = h - wall  # total height minus base panel thickness

        # Outer box
        outer = ad.Box([w, d, shell_height])
        shape = outer.solid("outer").colour("gray").at("centre")

        # Inner cavity — extends to the back face (no back wall)
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

            hole_x_sep = 61.72
            hole_y_positions = [ssd_dim.hole_front_y, ssd_dim.hole_rear_y]

            top_z = shell_height / 2
            ssd_screw_d = 3.0

            hole_idx = 0
            for y_pos in hole_y_positions:
                for x_sign in [-1, 1]:
                    x_pos = x_sign * hole_x_sep / 2
                    y_rel = y_pos - ssd_dim.length / 2

                    ssd_hole = ad.Cylinder(r=ssd_screw_d / 2, h=wall + 0.2, fn=20)
                    ssd_hole_shape = ssd_hole.hole(f"ssd_hole_{hole_idx}").at("centre")

                    shape.add_at(
                        ssd_hole_shape,
                        post=ad.translate([x_pos, y_rel, top_z])
                    )
                    hole_idx += 1

        # ── Back Latch Arms on Top Plate Underside Near Back Edge ──
        # These hang downward from the top plate underside and catch the
        # latch ledges on the back panel's front face near its top.
        back_ld = LatchDimensions(
            arm_length=self.dim.latch_arm_length,
            arm_thickness=self.dim.latch_arm_thickness,
            arm_width=self.dim.latch_arm_width,
            hook_depth=self.dim.latch_hook_depth,
            hook_height=self.dim.latch_hook_height,
        )
        for i, x_pos in enumerate(_latch_x_positions(inner_width)):
            back_latch = LatchArm(dim=back_ld)
            # Arm hangs from underside of top plate, near back edge
            # Top plate underside is at Z = shell_height/2 - wall
            # Back inner face is at Y = d/2 - wall
            shape.add_at(
                back_latch.solid(f"latch_arm_back_{i}").at("centre"),
                post=ad.translate([
                    x_pos,
                    d / 2 - wall - back_ld.arm_thickness / 2,
                    shell_height / 2 - wall - back_ld.arm_length / 2
                ]) * ad.rotX(180)
            )

        # ── Latch Arms on Front Wall Inner Face ──
        ld = LatchDimensions(
            arm_length=self.dim.latch_arm_length,
            arm_thickness=self.dim.latch_arm_thickness,
            arm_width=self.dim.latch_arm_width,
            hook_depth=self.dim.latch_hook_depth,
            hook_height=self.dim.latch_hook_height,
        )
        for i, x_pos in enumerate(_latch_x_positions(inner_width)):
            latch_arm = LatchArm(dim=ld)
            # Arm hangs from inner face of front wall, near the bottom
            # Front wall inner face is at Y = -d/2 + wall
            # Arm center Z: bottom of shell + arm_length/2
            shape.add_at(
                latch_arm.solid(f"latch_arm_{i}").at("centre"),
                post=ad.translate([
                    x_pos,
                    -d / 2 + wall + ld.arm_thickness / 2,
                    -shell_height / 2 + ld.arm_length / 2
                ])
            )

        return shape
