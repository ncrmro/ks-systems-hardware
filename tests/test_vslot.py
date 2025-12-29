"""
Tests for V-slot aluminum extrusion component.
"""
import pytest
import anchorscad as ad
from lib.vslot import Vslot, VslotDimensions


def test_vslot_dimensions_default():
    """Test that VslotDimensions has correct defaults."""
    dim = VslotDimensions()
    assert dim.size == 20.0
    assert dim.groove_width == 6.0
    assert dim.groove_depth == 1.5
    assert dim.groove_angle == 45.0
    assert dim.center_hole_diameter == 4.2


def test_vslot_dimensions_parametric():
    """Test that VslotDimensions can be created with different sizes."""
    sizes = [10.0, 20.0, 30.0, 40.0, 60.0, 80.0]
    for size in sizes:
        dim = VslotDimensions(size=size)
        assert dim.size == size
        # Channel width should be calculated based on size
        expected_channel = size - 2 * dim.groove_depth - 2.0
        assert dim.channel_width == expected_channel


def test_vslot_10x10_instantiation():
    """Test that a 10x10mm V-slot can be instantiated."""
    dim = VslotDimensions(size=10.0, center_hole_diameter=3.0)
    vslot = Vslot(dim=dim, length=100.0)
    assert vslot is not None
    assert vslot.dim.size == 10.0
    assert vslot.length == 100.0


def test_vslot_20x20_instantiation():
    """Test that a 20x20mm V-slot can be instantiated."""
    dim = VslotDimensions(size=20.0)
    vslot = Vslot(dim=dim, length=100.0)
    assert vslot is not None
    assert vslot.dim.size == 20.0
    assert vslot.length == 100.0


def test_vslot_30x30_instantiation():
    """Test that a 30x30mm V-slot can be instantiated."""
    dim = VslotDimensions(size=30.0, center_hole_diameter=5.5)
    vslot = Vslot(dim=dim, length=150.0)
    assert vslot is not None
    assert vslot.dim.size == 30.0
    assert vslot.length == 150.0


def test_vslot_build_produces_maker():
    """Test that building a V-slot produces a valid Maker."""
    vslot = Vslot()
    maker = vslot.build()
    assert maker is not None
    assert isinstance(maker, ad.Maker)


def test_vslot_parametric_length():
    """Test that V-slot length can be varied."""
    lengths = [50.0, 100.0, 200.0, 500.0]
    for length in lengths:
        vslot = Vslot(length=length)
        assert vslot.length == length


def test_vslot_end_anchors():
    """Test that end anchors can be accessed."""
    vslot = Vslot(length=100.0)
    
    # Test start end (0)
    start_anchor = vslot.end_anchor(0)
    assert start_anchor is not None
    
    # Test finish end (1)
    end_anchor = vslot.end_anchor(1)
    assert end_anchor is not None


def test_vslot_face_anchors():
    """Test that face anchors can be accessed."""
    vslot = Vslot()
    
    # Test all four faces
    for face in range(4):
        anchor = vslot.face_anchor(face)
        assert anchor is not None


def test_vslot_dimensions_wall_thickness():
    """Test that wall thickness is calculated correctly."""
    dim = VslotDimensions(groove_depth=1.5)
    # wall_thickness = groove_depth + 1.0
    assert dim.wall_thickness == 2.5


def test_vslot_dimensions_groove_offset():
    """Test that groove offset is calculated correctly."""
    dim = VslotDimensions(size=20.0, groove_depth=1.5)
    # groove_offset = (size / 2) - groove_depth
    expected_offset = (20.0 / 2) - 1.5
    assert dim.groove_offset == expected_offset


def test_vslot_custom_groove_dimensions():
    """Test V-slot with custom groove dimensions."""
    dim = VslotDimensions(
        size=40.0,
        groove_width=8.0,
        groove_depth=2.0
    )
    vslot = Vslot(dim=dim, length=200.0)
    assert vslot.dim.groove_width == 8.0
    assert vslot.dim.groove_depth == 2.0


def test_vslot_no_center_hole():
    """Test V-slot without center hole."""
    dim = VslotDimensions(center_hole_diameter=0.0)
    vslot = Vslot(dim=dim)
    maker = vslot.build()
    assert maker is not None
    # Should still build successfully, just without the center hole


def test_vslot_sizes_match_common_standards():
    """Test that common V-slot sizes can be created."""
    common_sizes = [
        (10.0, 3.0),   # 10x10 with M3
        (20.0, 4.2),   # 20x20 with M5
        (30.0, 5.5),   # 30x30 with M6
        (40.0, 5.5),   # 40x40 with M6
        (60.0, 5.5),   # 60x60 with M6
        (80.0, 5.5),   # 80x80 with M6
    ]
    
    for size, hole_dia in common_sizes:
        dim = VslotDimensions(size=size, center_hole_diameter=hole_dia)
        vslot = Vslot(dim=dim, length=100.0)
        assert vslot.dim.size == size
        assert vslot.dim.center_hole_diameter == hole_dia
        # Should build without errors
        maker = vslot.build()
        assert maker is not None
