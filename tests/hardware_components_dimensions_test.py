"""
This test module verifies the dimensions and calculations for various hardware components
to determine the minimum size allowed for the interior of a case given these dimensions.
"""

import anchorscad as ad
import numpy as np
import pytest
from config import CommonDimensions, MinimalDimensions, PicoDimensions
from parts.frame import Standoff
from lib.motherboard import MiniItxMotherboard
from lib.cooling import CoolingDimensions
from lib.psu import PicoPsuDimensions

# --- Tests from test_basic_parts.py ---

def test_standoff_instantiation():
    """Verifies that a Standoff object can be instantiated."""
    dims = CommonDimensions(
        standoff_hex_size_flat_to_flat=5.5,
        standoff_height=6.0
    )
    standoff = Standoff(dim=dims)
    assert standoff is not None
    assert isinstance(standoff, Standoff)

def test_standoff_build_produces_maker():
    """Verifies that the build method of Standoff produces an anchorscad Maker."""
    dims = CommonDimensions(
        standoff_hex_size_flat_to_flat=5.5,
        standoff_height=6.0
    )
    standoff = Standoff(dim=dims)
    maker = standoff.build()
    assert maker is not None
    assert isinstance(maker, ad.Maker)

def test_standoff_dimensions_reflect_input():
    """Verifies that the Standoff uses the provided dimensions."""
    test_hex_size = 7.0
    test_height = 10.0
    dims = CommonDimensions(
        standoff_hex_size_flat_to_flat=test_hex_size,
        standoff_height=test_height
    )
    standoff = Standoff(dim=dims)
    assert standoff.dim.standoff_hex_size_flat_to_flat == test_hex_size
    assert standoff.dim.standoff_height == test_height

# --- Tests from test_motherboard.py ---

def test_real_mini_itx_motherboard_instantiation():
    """
    Verifies that the real MiniItxMotherboard can be instantiated
    and has the correct default dimensions (170x170mm).
    """
    dim = MinimalDimensions()
    mobo = MiniItxMotherboard(dim=dim.mobo)
    
    assert mobo is not None
    assert mobo.dim.width == 170.0
    assert mobo.dim.depth == 170.0
    
    # Check that it produces a Maker
    maker = mobo.build()
    assert isinstance(maker, ad.Maker)

def test_mini_itx_mounting_holes():
    """
    Verifies that the 4 standard Mini-ITX mounting hole anchors exist
    and are accessible.
    """
    dim = MinimalDimensions()
    mobo = MiniItxMotherboard(dim=dim.mobo)
    
    # Mini-ITX has 4 mounting holes (Index 0-3)
    for i in range(4):
        anchor = mobo.mounting_hole(i)
        assert anchor is not None
        
def test_mini_itx_io_shield_params():
    """
    Verifies the I/O shield dimensions and offset properties on the real motherboard.
    """
    dim = MinimalDimensions()
    mobo = MiniItxMotherboard(dim=dim.mobo)
    
    # Standard I/O shield width is ~158.75mm
    assert np.isclose(mobo.dim.io_shield_width, 158.75)
    
    # Calculated X offset to center it
    expected_offset = (170.0 - 158.75) / 2
    assert np.isclose(mobo.dim.io_shield_x_offset, expected_offset)

# --- Tests from test_cooling_height.py ---

def test_nh_l12s_dimensions():
    """
    Verifies the dimensions of the Noctua NH-L12S cooler.
    """
    cooling_dim = CoolingDimensions()
    
    # Verify based on manufacturer specs / project requirements
    assert cooling_dim.nh_l12s_total_height == 70.0
    assert cooling_dim.nh_l12s_width == 128.0
    assert cooling_dim.nh_l12s_depth == 146.0

def test_nh_l9_dimensions():
    """
    Verifies the dimensions of the Noctua NH-L9 low-profile cooler.
    """
    cooling_dim = CoolingDimensions()

    assert cooling_dim.nh_l9_total_height == 37.0
    assert cooling_dim.nh_l9_width == 95.0
    assert cooling_dim.nh_l9_depth == 95.0
    assert cooling_dim.nh_l9_base_height == 5.0
    assert cooling_dim.nh_l9_heatsink_height == 18.0
    assert cooling_dim.nh_l9_fan_height == 14.0

def test_minimal_interior_height_calculation():
    """
    Verifies that the Minimal configuration's interior chamber height
    is correctly calculated based on the Standoff + Motherboard + Cooler stack.
    """
    dim = MinimalDimensions()
    
    # 1. Retrieve individual component heights
    standoff_h = dim.standoff_height
    pcb_h = dim.mobo.pcb_thickness
    cooler_h = dim.cooling.nh_l12s_total_height
    
    # 2. Calculate expected total height
    expected_height = standoff_h + pcb_h + cooler_h
    
    # 3. Assert the property matches the sum
    # Using np.isclose to avoid floating point issues
    assert np.isclose(dim.interior_chamber_height, expected_height)
    
    # 4. Assert the absolute value to ensure defaults are as expected
    # 6.0 + 1.6 + 70.0 = 77.6 mm
    assert np.isclose(dim.interior_chamber_height, 77.6)

def test_pico_interior_height_uses_taller_stack():
    """
    Pico interior height should accommodate whichever is taller:
    the cooler stack or the I/O shield stack.
    """
    dim = PicoDimensions()

    cooler_stack = dim.standoff_height + dim.mobo.pcb_thickness + dim.cooling.nh_l9_total_height
    io_stack = dim.standoff_height + dim.mobo.pcb_thickness + dim.mobo.io_shield_z_offset + dim.mobo.io_shield_height

    assert np.isclose(dim.pico_interior_chamber_height, max(cooler_stack, io_stack))

def test_interior_height_updates_with_params():
    """
    Verifies that changing a component dimension updates the total chamber height.
    """
    dim = MinimalDimensions()
    
    # Change standoff height
    dim.standoff_height = 10.0
    
    # Expected: 10.0 + 1.6 + 70.0 = 81.6
    assert np.isclose(dim.interior_chamber_height, 81.6)

def test_pico_psu_dimensions_match_legacy():
    """
    Validates PicoPSU dimensions mirror the legacy OpenSCAD model.
    """
    psu = PicoPsuDimensions()

    assert np.isclose(psu.width, 50.0)
    assert np.isclose(psu.depth, 7.0)
    assert np.isclose(psu.height, 32.0)
    assert np.isclose(psu.connector_depth, 7.0)
    assert np.isclose(psu.connector_height, 13.0)
    assert np.isclose(psu.pcb_thickness, 1.6)
    assert np.isclose(psu.pcb_height, 19.0)
