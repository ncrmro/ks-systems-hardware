"""Tower case frame — V-rod structural columns with crossmembers.

Manufacturing: FDM 3D print, PETG
Layout: Inverted motherboard (IO down), SFX PSU on top, vertical GPU side chamber.
The frame uses 20×20mm square columns at corners with horizontal crossmembers
at motherboard mounting height and PSU shelf height.
"""
import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

from config import TowerDimensions
from registry import register_part


@register_part("tower_frame", part_type="component")
def create_tower_frame() -> ad.Shape:
    return TowerFrame(dim=TowerDimensions())


@register_part("tower_bottom_panel", part_type="component")
def create_tower_bottom_panel() -> ad.Shape:
    return TowerBottomPanel(dim=TowerDimensions())


@ad.shape
@datatree
class TowerFrame(ad.CompositeShape):
    """V-rod structural frame for tower case.

    Four vertical corner columns connected by horizontal crossmembers.
    Columns are square profile (default 20×20mm), printed in PETG.
    """
    dim: TowerDimensions = field(default_factory=TowerDimensions)

    def build(self) -> ad.Maker:
        vrod = self.dim.vrod_profile
        frame_height = self.dim.total_height - 2 * self.dim.wall_thickness

        # Create a single V-rod column
        column = ad.Box([vrod, vrod, frame_height])

        # Positions for 4 corner columns (mobo chamber corners)
        # Origin at center of mobo chamber floor
        half_w = self.dim.mobo_chamber_width / 2
        half_d = self.dim.mobo_chamber_depth / 2

        column_positions = [
            (-half_w - vrod / 2, -half_d - vrod / 2),  # front-left
            (half_w + vrod / 2, -half_d - vrod / 2),    # front-right
            (-half_w - vrod / 2, half_d + vrod / 2),    # back-left
            (half_w + vrod / 2, half_d + vrod / 2),     # back-right
        ]

        # First column is the base reference
        maker = column.solid("col_fl").at("centre")

        # Remaining columns
        for i, (name, (cx, cy)) in enumerate([
            ("col_fr", column_positions[1]),
            ("col_bl", column_positions[2]),
            ("col_br", column_positions[3]),
        ]):
            offset_x = cx - column_positions[0][0]
            offset_y = cy - column_positions[0][1]
            maker.add_at(
                column.solid(name).at("centre"),
                "col_fl", "centre",
                post=ad.translate([offset_x, offset_y, 0])
            )

        # Motherboard shelf crossmember (horizontal bar connecting front columns)
        mobo_shelf_z = self.dim.io_clearance_zone  # Above IO zone
        shelf_width = self.dim.mobo_chamber_width + 2 * vrod
        shelf_bar = ad.Box([shelf_width, vrod, vrod])

        # Front crossmember at mobo height
        maker.add_at(
            shelf_bar.solid("shelf_front").at("centre"),
            "col_fl", "centre",
            post=ad.translate([
                (column_positions[1][0] - column_positions[0][0]) / 2,
                0,
                -(frame_height / 2) + mobo_shelf_z + vrod / 2
            ])
        )

        # Back crossmember at mobo height
        maker.add_at(
            shelf_bar.solid("shelf_back").at("centre"),
            "col_fl", "centre",
            post=ad.translate([
                (column_positions[1][0] - column_positions[0][0]) / 2,
                column_positions[2][1] - column_positions[0][1],
                -(frame_height / 2) + mobo_shelf_z + vrod / 2
            ])
        )

        # PSU shelf crossmember (above cooler)
        psu_shelf_z = (
            self.dim.io_clearance_zone
            + self.dim.standoff_height
            + self.dim.mobo.pcb_thickness
            + self.dim.mobo_to_psu_gap
        )

        maker.add_at(
            shelf_bar.solid("psu_shelf_front").at("centre"),
            "col_fl", "centre",
            post=ad.translate([
                (column_positions[1][0] - column_positions[0][0]) / 2,
                0,
                -(frame_height / 2) + psu_shelf_z + vrod / 2
            ])
        )

        maker.add_at(
            shelf_bar.solid("psu_shelf_back").at("centre"),
            "col_fl", "centre",
            post=ad.translate([
                (column_positions[1][0] - column_positions[0][0]) / 2,
                column_positions[2][1] - column_positions[0][1],
                -(frame_height / 2) + psu_shelf_z + vrod / 2
            ])
        )

        return maker


@ad.shape
@datatree
class TowerBottomPanel(ad.CompositeShape):
    """Bottom panel with IO shield cutout, C14 power inlet, and honeycomb vents.

    The bottom panel sits at the base of the tower. It has:
    - IO shield cutout (inverted motherboard, ports face down)
    - C14 panel-mount power inlet cutout (PSU extension)
    - ESP32 USB-C access cutout
    - Honeycomb ventilation for intake airflow
    """
    dim: TowerDimensions = field(default_factory=TowerDimensions)

    def build(self) -> ad.Maker:
        panel_width = self.dim.mobo_chamber_width + 2 * self.dim.vrod_profile + 2 * self.dim.wall_thickness
        panel_depth = self.dim.mobo_chamber_depth + 2 * self.dim.vrod_profile + 2 * self.dim.wall_thickness

        # Base panel
        panel = ad.Box([panel_width, panel_depth, self.dim.wall_thickness])
        maker = panel.solid("panel").at("centre")

        # IO shield cutout (centered on motherboard position)
        io_cutout = ad.Box([
            self.dim.io_cutout_width,
            self.dim.io_cutout_height,
            self.dim.wall_thickness + 2  # Through-cut
        ])
        maker.add_at(
            io_cutout.hole("io_cutout").at("centre"),
            "panel", "centre"
        )

        # C14 power inlet cutout (offset to side of IO cutout)
        c14_cutout = ad.Box([
            self.dim.c14_cutout_width,
            self.dim.c14_cutout_height,
            self.dim.wall_thickness + 2
        ])
        maker.add_at(
            c14_cutout.hole("c14_cutout").at("centre"),
            "panel", "centre",
            post=ad.translate([self.dim.io_cutout_width / 2 + 20, 0, 0])
        )

        # ESP32 USB-C access cutout
        usb_cutout = ad.Box([
            self.dim.esp32_usb_cutout_width,
            self.dim.esp32_usb_cutout_height,
            self.dim.wall_thickness + 2
        ])
        maker.add_at(
            usb_cutout.hole("usb_cutout").at("centre"),
            "panel", "centre",
            post=ad.translate([-(self.dim.io_cutout_width / 2 + 15), 0, 0])
        )

        return maker
