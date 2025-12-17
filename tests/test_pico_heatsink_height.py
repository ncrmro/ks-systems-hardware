
import anchorscad as ad
import numpy as np
import pytest
from config import PicoDimensions

def test_pico_heatsink_height_from_mobo_bottom():
    """
    Verifies that the height from the bottom of the motherboard to the top of the heatsink is 45mm.
    """
    dim = PicoDimensions()
    
    # Mobo bottom is at Z = 0 (relative to a reference where mobo sits on standoffs)
    # Actually, let's look at the component stack.
    
    pcb_thickness = dim.mobo.pcb_thickness
    cooler_height = dim.cooling.nh_l9_total_height
    
    # Height from bottom of mobo to top of cooler:
    # Stack = PCB + Cooler
    total_height = pcb_thickness + cooler_height
    
    # Requirement: 45mm
    assert np.isclose(total_height, 45.0), f"Expected 45.0mm, got {total_height}mm"
