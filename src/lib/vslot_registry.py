"""
Registry entries for common V-slot sizes.
"""
from registry import register_part
from lib.vslot import Vslot, VslotDimensions


@register_part("vslot_10x10")
def vslot_10x10():
    """V-slot 10x10mm profile, 100mm length."""
    return Vslot(
        dim=VslotDimensions(
            size=10.0,
            groove_width=6.0,
            groove_depth=1.0,
            center_hole_diameter=3.0,  # M3 clearance
        ),
        length=100.0
    )


@register_part("vslot_20x20")
def vslot_20x20():
    """V-slot 20x20mm profile, 100mm length."""
    return Vslot(
        dim=VslotDimensions(
            size=20.0,
            groove_width=6.0,
            groove_depth=1.5,
            center_hole_diameter=4.2,  # M5 clearance
        ),
        length=100.0
    )


@register_part("vslot_30x30")
def vslot_30x30():
    """V-slot 30x30mm profile, 100mm length."""
    return Vslot(
        dim=VslotDimensions(
            size=30.0,
            groove_width=6.0,
            groove_depth=1.5,
            center_hole_diameter=5.5,  # M6 clearance
        ),
        length=100.0
    )


@register_part("vslot_40x40")
def vslot_40x40():
    """V-slot 40x40mm profile, 100mm length."""
    return Vslot(
        dim=VslotDimensions(
            size=40.0,
            groove_width=6.0,
            groove_depth=1.5,
            center_hole_diameter=5.5,  # M6 clearance
        ),
        length=100.0
    )


@register_part("vslot_60x60")
def vslot_60x60():
    """V-slot 60x60mm profile, 100mm length."""
    return Vslot(
        dim=VslotDimensions(
            size=60.0,
            groove_width=6.0,
            groove_depth=1.5,
            center_hole_diameter=5.5,  # M6 clearance
        ),
        length=100.0
    )


@register_part("vslot_80x80")
def vslot_80x80():
    """V-slot 80x80mm profile, 100mm length."""
    return Vslot(
        dim=VslotDimensions(
            size=80.0,
            groove_width=6.0,
            groove_depth=1.5,
            center_hole_diameter=5.5,  # M6 clearance
        ),
        length=100.0
    )
