"""
SFX PSU-based GPU Tower Case Parts.

This module implements a tall vertical tower case with:
- Motherboard on one side with I/O ports facing down
- GPU on the other side with I/O ports also facing down
- SFX PSU mounted above motherboard
- Ventilation on side panels

Case dimensions (from SPEC.md section 8.4):
- Width: 171mm
- Depth: 378mm
- Height: 190mm

The case is designed to stand vertically (tower orientation).
"""

import anchorscad as ad
from anchorscad import datatree
from typing import Literal
from dataclasses import field

from config import SfxCaseDimensions
from registry import register_part


# -----------------------------------------------------------------------------
# Panel Registration
# -----------------------------------------------------------------------------

@register_part("parts_case_sfx_base_panel")
def create_sfx_base_panel() -> ad.Shape:
    return SfxBasePanel(dim=SfxCaseDimensions())


@register_part("parts_case_sfx_io_panel")
def create_sfx_io_panel() -> ad.Shape:
    return SfxIoPanel(dim=SfxCaseDimensions())


@register_part("parts_case_sfx_top_panel")
def create_sfx_top_panel() -> ad.Shape:
    return SfxTopPanel(dim=SfxCaseDimensions())


@register_part("parts_case_sfx_front_panel")
def create_sfx_front_panel() -> ad.Shape:
    return SfxFrontPanel(dim=SfxCaseDimensions())


@register_part("parts_case_sfx_side_panel_mobo")
def create_sfx_side_panel_mobo() -> ad.Shape:
    return SfxSidePanel(dim=SfxCaseDimensions(), side="mobo")


@register_part("parts_case_sfx_side_panel_gpu")
def create_sfx_side_panel_gpu() -> ad.Shape:
    return SfxSidePanel(dim=SfxCaseDimensions(), side="gpu")


@register_part("parts_case_sfx_bottom_shell")
def create_sfx_bottom_shell() -> ad.Shape:
    return SfxBottomShell(dim=SfxCaseDimensions())


@register_part("parts_case_sfx_top_shell")
def create_sfx_top_shell() -> ad.Shape:
    return SfxTopShell(dim=SfxCaseDimensions())


# -----------------------------------------------------------------------------
# Base Panel (Floor when vertical)
# -----------------------------------------------------------------------------

@ad.shape
@datatree
class SfxBasePanel(ad.CompositeShape):
    """
    Base panel for SFX tower case.

    When the case stands vertically, this is the "floor" panel at the back
    of the case (opposite the front panel with any controls/ports).

    Dimensions: Width x Depth x wall_thickness
    """
    dim: SfxCaseDimensions

    def build(self) -> ad.Maker:
        panel_width = self.dim.sfx_case_width
        panel_depth = self.dim.sfx_case_depth
        panel_thickness = self.dim.wall_thickness

        panel = ad.Box([panel_width, panel_depth, panel_thickness])
        shape = panel.solid("panel").colour("gray").at(
            "centre",
            post=ad.translate([panel_width / 2, panel_depth / 2, panel_thickness / 2])
        )

        return shape


# -----------------------------------------------------------------------------
# I/O Panel (Bottom when vertical - houses motherboard and GPU I/O)
# -----------------------------------------------------------------------------

@ad.shape
@datatree
class SfxIoPanel(ad.CompositeShape):
    """
    I/O panel for SFX tower case.

    This panel is at the bottom when the case stands vertically.
    It contains cutouts for:
    - Motherboard rear I/O shield
    - GPU display outputs (PCIe slot bracket area)
    - Power inlet (C14 or C13)

    The panel is divided into zones for mobo I/O and GPU I/O.
    """
    dim: SfxCaseDimensions

    def build(self) -> ad.Maker:
        # Panel dimensions (when vertical: this is the bottom)
        panel_width = self.dim.sfx_case_width
        panel_depth = self.dim.sfx_case_depth - 2 * self.dim.wall_thickness
        panel_thickness = self.dim.wall_thickness

        # Main panel body
        panel = ad.Box([panel_width, panel_depth, panel_thickness])
        shape = panel.solid("panel").colour("darkgray").at(
            "centre",
            post=ad.translate([panel_width / 2, panel_depth / 2, panel_thickness / 2])
        )

        # Motherboard I/O Shield cutout
        # Standard I/O shield: 158.75mm x 44.45mm
        io_shield_width = self.dim.mobo.io_shield_width
        io_shield_height = self.dim.mobo.io_shield_height

        # Position I/O shield cutout on the motherboard side (front half of depth)
        # Centered on the mobo chamber
        io_cutout_x = (panel_width - io_shield_width) / 2
        io_cutout_y = self.dim.mobo_chamber_depth / 2 - io_shield_height / 2

        io_cutout = ad.Box([io_shield_width, io_shield_height, panel_thickness + 0.2])
        io_cutout_shape = io_cutout.hole("io_shield_cutout").at(
            "centre",
            post=ad.translate([
                io_cutout_x + io_shield_width / 2,
                io_cutout_y + io_shield_height / 2,
                panel_thickness / 2
            ])
        )
        shape.add_at(io_cutout_shape, post=ad.IDENTITY)

        # GPU I/O cutout (PCIe bracket area - 3 slots)
        # Standard PCIe bracket: ~120mm wide for 3 slots, ~20mm per slot
        gpu_bracket_width = self.dim.gpu_max_width + 10  # 70mm
        gpu_bracket_height = 80.0  # Standard PCIe bracket height

        # Position GPU cutout on the GPU side (back half of depth)
        gpu_cutout_x = (panel_width - gpu_bracket_width) / 2
        gpu_cutout_y = self.dim.mobo_chamber_depth + self.dim.divider_thickness + \
                       (self.dim.gpu_chamber_depth - gpu_bracket_height) / 2

        gpu_cutout = ad.Box([gpu_bracket_width, gpu_bracket_height, panel_thickness + 0.2])
        gpu_cutout_shape = gpu_cutout.hole("gpu_bracket_cutout").at(
            "centre",
            post=ad.translate([
                gpu_cutout_x + gpu_bracket_width / 2,
                gpu_cutout_y + gpu_bracket_height / 2,
                panel_thickness / 2
            ])
        )
        shape.add_at(gpu_cutout_shape, post=ad.IDENTITY)

        # Power inlet cutout (C14 inlet)
        # Standard C14: 27mm x 19.5mm
        c14_width = 27.0
        c14_height = 19.5

        # Position near the edge, on the PSU side
        c14_x = panel_width - 15 - c14_width / 2
        c14_y = panel_depth - 30

        c14_cutout = ad.Box([c14_width, c14_height, panel_thickness + 0.2])
        c14_cutout_shape = c14_cutout.hole("power_inlet_cutout").at(
            "centre",
            post=ad.translate([c14_x, c14_y, panel_thickness / 2])
        )
        shape.add_at(c14_cutout_shape, post=ad.IDENTITY)

        return shape


# -----------------------------------------------------------------------------
# Top Panel (Top when vertical)
# -----------------------------------------------------------------------------

@ad.shape
@datatree
class SfxTopPanel(ad.CompositeShape):
    """
    Top panel for SFX tower case.

    When the case stands vertically, this is the top.
    May include ventilation for PSU exhaust.
    """
    dim: SfxCaseDimensions

    def build(self) -> ad.Maker:
        panel_width = self.dim.sfx_case_width
        panel_depth = self.dim.sfx_case_depth - 2 * self.dim.wall_thickness
        panel_thickness = self.dim.wall_thickness

        panel = ad.Box([panel_width, panel_depth, panel_thickness])
        shape = panel.solid("panel").colour("gray").at(
            "centre",
            post=ad.translate([panel_width / 2, panel_depth / 2, panel_thickness / 2])
        )

        # Ventilation for PSU exhaust
        # Create a grid of circular vents above the PSU area
        vent_diameter = 6.0
        vent_spacing = 10.0
        vent_area_width = self.dim.psu.width - 20  # PSU width minus margins
        vent_area_depth = self.dim.psu.depth - 20

        # Calculate number of vents
        num_vents_x = int(vent_area_width / vent_spacing)
        num_vents_y = int(vent_area_depth / vent_spacing)

        # Center vent area on the motherboard chamber side (where PSU sits)
        vent_start_x = (panel_width - num_vents_x * vent_spacing) / 2
        vent_start_y = (self.dim.mobo_chamber_depth - num_vents_y * vent_spacing) / 2

        for i in range(num_vents_x):
            for j in range(num_vents_y):
                vent_x = vent_start_x + i * vent_spacing + vent_spacing / 2
                vent_y = vent_start_y + j * vent_spacing + vent_spacing / 2

                vent = ad.Cylinder(r=vent_diameter / 2, h=panel_thickness + 0.2, fn=20)
                vent_shape = vent.hole(f"vent_{i}_{j}").at(
                    "centre",
                    post=ad.translate([vent_x, vent_y, panel_thickness / 2])
                )
                shape.add_at(vent_shape, post=ad.IDENTITY)

        return shape


# -----------------------------------------------------------------------------
# Front Panel
# -----------------------------------------------------------------------------

@ad.shape
@datatree
class SfxFrontPanel(ad.CompositeShape):
    """
    Front panel for SFX tower case.

    User-facing panel that may include:
    - Power button
    - USB ports
    - Status LEDs
    """
    dim: SfxCaseDimensions

    def build(self) -> ad.Maker:
        # Front panel spans the height and depth of the case
        panel_width = self.dim.sfx_case_height - 2 * self.dim.wall_thickness
        panel_depth = self.dim.sfx_case_depth - 2 * self.dim.wall_thickness
        panel_thickness = self.dim.wall_thickness

        panel = ad.Box([panel_width, panel_depth, panel_thickness])
        shape = panel.solid("panel").colour("dimgray").at(
            "centre",
            post=ad.translate([panel_width / 2, panel_depth / 2, panel_thickness / 2])
        )

        # Power button hole (standard 16mm momentary switch)
        power_button_diameter = 16.5  # With tolerance
        power_button_x = panel_width / 2
        power_button_y = 40  # Near the front edge

        power_hole = ad.Cylinder(r=power_button_diameter / 2, h=panel_thickness + 0.2, fn=30)
        power_hole_shape = power_hole.hole("power_button").at(
            "centre",
            post=ad.translate([power_button_x, power_button_y, panel_thickness / 2])
        )
        shape.add_at(power_hole_shape, post=ad.IDENTITY)

        return shape


# -----------------------------------------------------------------------------
# Side Panels (with ventilation)
# -----------------------------------------------------------------------------

@ad.shape
@datatree
class SfxSidePanel(ad.CompositeShape):
    """
    Side panel for SFX tower case.

    Two variants:
    - "mobo" side: Ventilation for CPU cooler and motherboard VRM
    - "gpu" side: Ventilation for GPU cooling

    The side panels include honeycomb-style ventilation patterns.
    """
    dim: SfxCaseDimensions
    side: Literal["mobo", "gpu"] = "mobo"

    def build(self) -> ad.Maker:
        # Side panel spans width and height of the case
        panel_width = self.dim.sfx_case_width
        panel_height = self.dim.sfx_case_height - 2 * self.dim.wall_thickness
        panel_thickness = self.dim.wall_thickness

        panel = ad.Box([panel_width, panel_height, panel_thickness])
        shape = panel.solid("panel").colour("silver").at(
            "centre",
            post=ad.translate([panel_width / 2, panel_height / 2, panel_thickness / 2])
        )

        # Add ventilation based on which side
        if self.side == "mobo":
            # Motherboard side: ventilation for CPU cooler area
            self._add_mobo_ventilation(shape, panel_width, panel_height, panel_thickness)
        else:
            # GPU side: large ventilation area for GPU intake/exhaust
            self._add_gpu_ventilation(shape, panel_width, panel_height, panel_thickness)

        return shape

    def _add_mobo_ventilation(
        self, shape: ad.Maker, panel_width: float, panel_height: float, panel_thickness: float
    ) -> None:
        """Add ventilation holes for the motherboard side (CPU cooler area)."""
        # Ventilation area centered on CPU socket position
        # CPU socket is roughly centered on Mini-ITX board
        vent_diameter = 5.0
        vent_spacing = 8.0

        # Vent area: approximately 100mm x 100mm over CPU area
        vent_area_size = 100.0
        num_vents = int(vent_area_size / vent_spacing)

        # Center the vent area on the panel
        vent_start_x = (panel_width - num_vents * vent_spacing) / 2
        vent_start_y = (panel_height - num_vents * vent_spacing) / 2

        for i in range(num_vents):
            for j in range(num_vents):
                vent_x = vent_start_x + i * vent_spacing + vent_spacing / 2
                vent_y = vent_start_y + j * vent_spacing + vent_spacing / 2

                vent = ad.Cylinder(r=vent_diameter / 2, h=panel_thickness + 0.2, fn=16)
                vent_shape = vent.hole(f"vent_{i}_{j}").at(
                    "centre",
                    post=ad.translate([vent_x, vent_y, panel_thickness / 2])
                )
                shape.add_at(vent_shape, post=ad.IDENTITY)

    def _add_gpu_ventilation(
        self, shape: ad.Maker, panel_width: float, panel_height: float, panel_thickness: float
    ) -> None:
        """Add ventilation holes for the GPU side."""
        # GPU needs more airflow - larger vent area
        vent_diameter = 6.0
        vent_spacing = 9.0

        # Vent area: approximately 140mm x 280mm (most of the GPU length)
        vent_area_width = 140.0
        vent_area_height = min(280.0, panel_height - 20)

        num_vents_x = int(vent_area_width / vent_spacing)
        num_vents_y = int(vent_area_height / vent_spacing)

        # Center the vent area
        vent_start_x = (panel_width - num_vents_x * vent_spacing) / 2
        vent_start_y = (panel_height - num_vents_y * vent_spacing) / 2

        for i in range(num_vents_x):
            for j in range(num_vents_y):
                vent_x = vent_start_x + i * vent_spacing + vent_spacing / 2
                vent_y = vent_start_y + j * vent_spacing + vent_spacing / 2

                vent = ad.Cylinder(r=vent_diameter / 2, h=panel_thickness + 0.2, fn=16)
                vent_shape = vent.hole(f"vent_{i}_{j}").at(
                    "centre",
                    post=ad.translate([vent_x, vent_y, panel_thickness / 2])
                )
                shape.add_at(vent_shape, post=ad.IDENTITY)


# -----------------------------------------------------------------------------
# Shell Assemblies
# -----------------------------------------------------------------------------

@ad.shape
@datatree
class SfxBottomShell(ad.CompositeShape):
    """
    Bottom shell assembly for SFX tower case.

    Combines:
    - Base panel (back when vertical)
    - I/O panel (bottom when vertical)
    - Partial side walls for structural rigidity

    This shell remains assembled during normal case opening.
    """
    dim: SfxCaseDimensions

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        width = self.dim.sfx_case_width
        depth = self.dim.sfx_case_depth
        height = self.dim.sfx_case_height

        # Base panel (floor)
        base = ad.Box([width, depth, wall])
        shape = base.solid("base").colour("dimgray").at("centre")

        # I/O panel (bottom when vertical - at Y=-depth/2)
        io_panel_width = width
        io_panel_height = height - 2 * wall  # Interior height
        io_panel = ad.Box([io_panel_width, wall, io_panel_height])

        shape.add_at(
            io_panel.solid("io_panel").colour("darkgray").at("centre"),
            post=ad.translate([0, -depth / 2 + wall / 2, io_panel_height / 2 + wall / 2])
        )

        # Back wall stub for structural connection
        back_stub_height = 30.0  # Partial height for rigidity
        back_stub = ad.Box([width, wall, back_stub_height])

        shape.add_at(
            back_stub.solid("back_stub").colour("dimgray").at("centre"),
            post=ad.translate([0, depth / 2 - wall / 2, back_stub_height / 2 + wall / 2])
        )

        return shape


@ad.shape
@datatree
class SfxTopShell(ad.CompositeShape):
    """
    Top shell assembly for SFX tower case.

    Combines:
    - Top panel
    - Front panel
    - Side panels (left and right)

    This shell slides off as a single unit for access to internals.
    """
    dim: SfxCaseDimensions

    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        width = self.dim.sfx_case_width
        depth = self.dim.sfx_case_depth
        height = self.dim.sfx_case_height

        # Top panel (ceiling)
        top = ad.Box([width, depth, wall])
        shape = top.solid("top").colour("gray").at("centre")

        # Front panel (at Y=depth/2)
        front_height = height - 2 * wall
        front = ad.Box([width, wall, front_height])

        shape.add_at(
            front.solid("front").colour("dimgray").at("centre"),
            post=ad.translate([0, depth / 2 - wall / 2, -front_height / 2 - wall / 2])
        )

        # Side panels
        side_depth = depth - 2 * wall
        side_height = height - 2 * wall

        # Left side (at X=-width/2)
        left_side = ad.Box([wall, side_depth, side_height])
        shape.add_at(
            left_side.solid("left_side").colour("silver").at("centre"),
            post=ad.translate([-width / 2 + wall / 2, 0, -side_height / 2 - wall / 2])
        )

        # Right side (at X=width/2)
        right_side = ad.Box([wall, side_depth, side_height])
        shape.add_at(
            right_side.solid("right_side").colour("silver").at("centre"),
            post=ad.translate([width / 2 - wall / 2, 0, -side_height / 2 - wall / 2])
        )

        return shape
