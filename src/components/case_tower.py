"""Tower case frame — V-rod structural columns with crossmembers.

Manufacturing: FDM 3D print, PETG
Layout: Inverted motherboard (IO down), SFX PSU on top, vertical GPU side chamber.

Coordinate convention: Origin = center of motherboard chamber (XY), bottom of frame (Z=0).
GPU chamber extends in +X direction from the mobo chamber.
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

    6 vertical columns (4 mobo + 2 GPU) with crossmembers on all sides.
    Origin centered on mobo chamber XY, Z=0 at frame bottom.
    """
    dim: TowerDimensions = field(default_factory=TowerDimensions)

    def build(self) -> ad.Maker:
        vrod = self.dim.vrod_profile
        frame_height = self.dim.total_height - 2 * self.dim.wall_thickness
        hw = self.dim.mobo_chamber_width / 2  # half mobo width
        hd = self.dim.mobo_chamber_depth / 2  # half mobo depth

        # Use a thin invisible reference box at mobo chamber center
        ref = ad.Box([1, 1, 1])
        maker = ref.solid("origin").colour([0, 0, 0, 0]).at("centre")

        column = ad.Box([vrod, vrod, frame_height])

        # ── 4 mobo chamber corner columns ──
        mobo_cols = {
            "col_ml": (-hw - vrod / 2, -hd - vrod / 2),  # mobo front-left
            "col_mr": (hw + vrod / 2,  -hd - vrod / 2),   # mobo front-right
            "col_mbl": (-hw - vrod / 2, hd + vrod / 2),   # mobo back-left
            "col_mbr": (hw + vrod / 2,  hd + vrod / 2),   # mobo back-right
        }

        # ── 2 GPU chamber columns (extend in +X from mobo right columns) ──
        gpu_x = hw + vrod + self.dim.gpu_chamber_width + vrod / 2
        gpu_cols = {
            "col_gf": (gpu_x, -hd - vrod / 2),   # GPU front
            "col_gb": (gpu_x, hd + vrod / 2),     # GPU back
        }

        all_cols = {**mobo_cols, **gpu_cols}

        for name, (cx, cy) in all_cols.items():
            maker.add_at(
                column.solid(name).at("centre"),
                "origin", "centre",
                post=ad.translate([cx, cy, frame_height / 2])
            )

        # ── Crossmembers at two heights ──
        mobo_z = self.dim.io_clearance_zone + vrod / 2
        psu_z = (self.dim.io_clearance_zone + self.dim.standoff_height
                 + self.dim.mobo.pcb_thickness + self.dim.mobo_to_psu_gap + vrod / 2)

        def bar(name, x1, y1, x2, y2, z):
            """Horizontal bar between two column positions at height z."""
            dx, dy = x2 - x1, y2 - y1
            length = (dx**2 + dy**2) ** 0.5
            b = ad.Box([length if abs(dx) > abs(dy) else vrod,
                        vrod if abs(dx) > abs(dy) else length,
                        vrod])
            maker.add_at(
                b.solid(name).at("centre"),
                "origin", "centre",
                post=ad.translate([(x1 + x2) / 2, (y1 + y2) / 2, z])
            )

        for suffix, z in [("lo", mobo_z), ("hi", psu_z)]:
            # Mobo front/back bars (X-axis)
            bar(f"mobo_f_{suffix}", mobo_cols["col_ml"][0], mobo_cols["col_ml"][1],
                mobo_cols["col_mr"][0], mobo_cols["col_mr"][1], z)
            bar(f"mobo_b_{suffix}", mobo_cols["col_mbl"][0], mobo_cols["col_mbl"][1],
                mobo_cols["col_mbr"][0], mobo_cols["col_mbr"][1], z)

            # Mobo side bars (Y-axis)
            bar(f"mobo_l_{suffix}", mobo_cols["col_ml"][0], mobo_cols["col_ml"][1],
                mobo_cols["col_mbl"][0], mobo_cols["col_mbl"][1], z)
            bar(f"mobo_r_{suffix}", mobo_cols["col_mr"][0], mobo_cols["col_mr"][1],
                mobo_cols["col_mbr"][0], mobo_cols["col_mbr"][1], z)

            # GPU front/back bars (X-axis, connecting mobo-right to GPU columns)
            bar(f"gpu_f_{suffix}", mobo_cols["col_mr"][0], mobo_cols["col_mr"][1],
                gpu_cols["col_gf"][0], gpu_cols["col_gf"][1], z)
            bar(f"gpu_b_{suffix}", mobo_cols["col_mbr"][0], mobo_cols["col_mbr"][1],
                gpu_cols["col_gb"][0], gpu_cols["col_gb"][1], z)

        return maker


@ad.shape
@datatree
class TowerBottomPanel(ad.CompositeShape):
    """Bottom panel with IO shield cutout, C14 power inlet, and USB-C access.

    Origin centered on mobo chamber XY (same as frame).
    """
    dim: TowerDimensions = field(default_factory=TowerDimensions)

    def build(self) -> ad.Maker:
        vrod = self.dim.vrod_profile
        # Total panel width includes mobo chamber + GPU chamber
        gpu_extra = self.dim.gpu_chamber_width + vrod
        panel_width = self.dim.mobo_chamber_width + 2 * vrod + 2 * self.dim.wall_thickness + gpu_extra
        panel_depth = self.dim.mobo_chamber_depth + 2 * vrod + 2 * self.dim.wall_thickness

        # Panel center is offset from mobo chamber center by half the GPU extra width
        panel_x_offset = gpu_extra / 2

        panel = ad.Box([panel_width, panel_depth, self.dim.wall_thickness])
        maker = panel.solid("panel").at("centre")

        # Shift panel so mobo chamber center is at X=0
        # (panel center is at +gpu_extra/2 from mobo center)

        # IO cutout centered on mobo chamber (X=0 relative to mobo center = -panel_x_offset relative to panel center)
        io_cutout = ad.Box([
            self.dim.io_cutout_width,
            self.dim.io_cutout_height,
            self.dim.wall_thickness + 2
        ])
        maker.add_at(
            io_cutout.hole("io_cutout").at("centre"),
            "panel", "centre",
            post=ad.translate([-panel_x_offset, 0, 0])
        )

        # C14 power inlet cutout
        c14_cutout = ad.Box([
            self.dim.c14_cutout_width,
            self.dim.c14_cutout_height,
            self.dim.wall_thickness + 2
        ])
        maker.add_at(
            c14_cutout.hole("c14_cutout").at("centre"),
            "panel", "centre",
            post=ad.translate([-panel_x_offset + self.dim.io_cutout_width / 2 + 20, 0, 0])
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
            post=ad.translate([-panel_x_offset - self.dim.io_cutout_width / 2 - 15, 0, 0])
        )

        return maker
