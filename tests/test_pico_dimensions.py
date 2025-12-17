import unittest
import sys
import os

# Ensure src is in path
sys.path.append(os.path.join(os.getcwd(), 'src'))

from config import PicoDimensions
from lib.motherboard import MiniItxDimensions
from lib.heatsink import NOCTUA_L9

class TestPicoDimensions(unittest.TestCase):
    def setUp(self):
        self.pico = PicoDimensions()
        self.mobo = MiniItxDimensions()

    def test_interior_width_fits_motherboard(self):
        """Verify the interior width accommodates a Mini-ITX motherboard."""
        interior_width = self.pico.pico_case_width - (2 * self.pico.wall_thickness)
        self.assertGreaterEqual(interior_width, self.mobo.width)

    def test_interior_depth_fits_motherboard(self):
        """Verify the interior depth accommodates a Mini-ITX motherboard."""
        interior_depth = self.pico.pico_case_depth - (2 * self.pico.wall_thickness)
        self.assertGreaterEqual(interior_depth, self.mobo.depth)

    def test_interior_height_fits_heatsink_stack(self):
        """Verify the interior height accommodates the motherboard, standoffs, and CPU cooler."""
        stack_height = (
            self.pico.standoff_height + 
            self.mobo.pcb_thickness + 
            NOCTUA_L9.total_height
        )
        self.assertGreaterEqual(self.pico.pico_interior_chamber_height, stack_height)

    def test_interior_height_fits_io_shield_stack(self):
        """Verify the interior height accommodates the I/O shield stack."""
        io_stack_height = (
            self.pico.standoff_height + 
            self.mobo.pcb_thickness + 
            self.mobo.io_shield_z_offset + 
            self.mobo.io_shield_height
        )
        self.assertGreaterEqual(self.pico.pico_interior_chamber_height, io_stack_height)

if __name__ == '__main__':
    unittest.main()
