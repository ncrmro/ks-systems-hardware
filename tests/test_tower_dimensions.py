"""Tests for Tower case configuration — all acceptance criteria from part_requirements.md."""
import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'src'))

import pytest
from config import TowerDimensions
from vitamins.motherboard import MiniItxDimensions
from vitamins.psu import SfxDimensions
from vitamins.heatsink import NOCTUA_L12S
from registry import get_registry
import components.case_tower  # Trigger @register_part decorators


@pytest.fixture
def dims():
    return TowerDimensions()


class TestMotherboardFit:
    """Motherboard must fit in the mobo chamber with clearance."""

    def test_mobo_width_fits(self, dims):
        assert dims.mobo.width + 2 * dims.mobo_clearance <= dims.mobo_chamber_width

    def test_mobo_depth_fits(self, dims):
        assert dims.mobo.depth + 2 * dims.mobo_clearance <= dims.mobo_chamber_depth


class TestIOClearance:
    """Inverted IO — shield hangs below mobo, cables plug from below."""

    def test_io_zone_accommodates_shield(self, dims):
        io_protrusion = dims.mobo.io_shield_z_offset + dims.mobo.io_shield_height
        assert dims.io_clearance_zone >= io_protrusion + 5.0  # 5mm cable bend

    def test_io_cutout_width(self, dims):
        assert dims.io_cutout_width >= dims.mobo.io_shield_width + 1.25

    def test_io_cutout_height(self, dims):
        assert dims.io_cutout_height >= dims.mobo.io_shield_height + 1.25


class TestCoolerFit:
    """NH-L12S must fit between motherboard and PSU shelf."""

    def test_cooler_gap(self, dims):
        assert dims.mobo_to_psu_gap >= dims.cooling.nh_l12s_total_height + 5.0


class TestPSUChamber:
    """SFX PSU must fit in the top chamber."""

    def test_psu_height(self, dims):
        assert dims.psu_chamber_height >= dims.psu.height + 2 * dims.psu_clearance

    def test_c14_cutout_width(self, dims):
        assert dims.c14_cutout_width >= 28.0

    def test_c14_cutout_height(self, dims):
        assert dims.c14_cutout_height >= 22.0

    def test_psu_cable_passthrough(self, dims):
        assert dims.psu_cable_passthrough >= 15.0


class TestGPUChamber:
    """2-slot GPU must fit in the side chamber."""

    def test_gpu_width(self, dims):
        assert dims.gpu_chamber_width >= dims.gpu.thickness + 2 * dims.gpu_clearance

    def test_gpu_depth(self, dims):
        assert dims.gpu_chamber_depth >= dims.gpu.length + 2 * dims.gpu_clearance

    def test_gpu_antisag_depth(self, dims):
        assert dims.gpu_antisag_depth >= 3.0

    def test_gpu_antisag_width(self, dims):
        assert dims.gpu_antisag_width >= 10.0


class TestPCIeRouting:
    """PCIe riser cable routing slot dimensions."""

    def test_pcie_slot_width(self, dims):
        assert dims.pcie_slot_width >= 90.0

    def test_pcie_slot_height(self, dims):
        assert dims.pcie_slot_height >= 8.0


class TestFanMount:
    """120mm exhaust fan at top-back."""

    def test_top_panel_fits_fan(self, dims):
        assert dims.top_panel_width >= 120

    def test_fan_mount_depth(self, dims):
        assert dims.fan_mount_depth >= 25


class TestSensorBay:
    """ESP32-C3 + SCD41 + BME280 sensor bay."""

    def test_sensor_bay_width(self, dims):
        sensor_bay_min_width = (
            max(dims.sensor_bay.esp32_width, dims.sensor_bay.scd41_width, dims.sensor_bay.bme280_width)
            + 2 * dims.sensor_bay.sensor_clearance
        )
        assert dims.sensor_bay_width >= sensor_bay_min_width

    def test_sensor_bay_depth(self, dims):
        sensor_bay_min_depth = (
            dims.sensor_bay.esp32_depth
            + dims.sensor_bay.scd41_depth
            + dims.sensor_bay.bme280_depth
            + 4 * dims.sensor_bay.sensor_clearance
        )
        assert dims.sensor_bay_depth >= sensor_bay_min_depth

    def test_sensor_vent_hole_count(self, dims):
        assert dims.sensor_bay.vent_hole_count >= 6

    def test_sensor_vent_hole_diameter(self, dims):
        assert dims.sensor_bay.vent_hole_diameter >= 5.0

    def test_esp32_usb_cutout_width(self, dims):
        assert dims.esp32_usb_cutout_width >= 11.0

    def test_esp32_usb_cutout_height(self, dims):
        assert dims.esp32_usb_cutout_height >= 5.0


class TestVentilation:
    """Honeycomb vent parameters match project standard."""

    def test_honeycomb_radius(self, dims):
        assert dims.honeycomb_radius == 3.0

    def test_vent_padding(self, dims):
        assert dims.vent_padding >= 5.0


class TestStructural:
    """V-rod frame and wall structural minimums."""

    def test_vrod_profile_minimum(self, dims):
        assert dims.vrod_profile >= 10.0

    def test_wall_thickness_minimum(self, dims):
        assert dims.wall_thickness >= 3.0

    def test_dovetail_engagement(self, dims):
        assert dims.dovetail_engagement >= 25.0

    def test_dovetail_clearance(self, dims):
        assert dims.dovetail_clearance >= 0.3


class TestOverallDimensions:
    """Total case dimensions must be within bounds."""

    def test_total_height_minimum(self, dims):
        expected_height = (
            dims.wall_thickness
            + dims.io_clearance_zone
            + dims.standoff_height
            + dims.mobo.pcb_thickness
            + dims.mobo_to_psu_gap
            + dims.psu_chamber_height
            + dims.wall_thickness
        )
        assert dims.total_height >= expected_height

    def test_total_height_minimum_absolute(self, dims):
        # 3 + 55 + 6 + 1.6 + 75 + 67.5 + 25 + 3 = 236.1mm
        assert dims.total_height >= 230.0

    def test_total_width_maximum(self, dims):
        # 3 + 20 + 172 + 20 + 46 + 20 + 3 = 284mm
        assert dims.total_width <= 290.0


class TestParametricBehavior:
    """Changing config values must propagate correctly."""

    def test_mobo_clearance_affects_chamber_width(self):
        dims_tight = TowerDimensions(mobo_clearance=0.5)
        dims_loose = TowerDimensions(mobo_clearance=2.0)
        assert dims_loose.mobo_chamber_width > dims_tight.mobo_chamber_width
        assert dims_tight.mobo_chamber_width == 170.0 + 2 * 0.5
        assert dims_loose.mobo_chamber_width == 170.0 + 2 * 2.0

    def test_gpu_clearance_affects_chamber(self):
        dims = TowerDimensions(gpu_clearance=5.0)
        assert dims.gpu_chamber_width == 40.0 + 2 * 5.0

    def test_vrod_profile_affects_total_width(self):
        dims_thin = TowerDimensions(vrod_profile=10.0)
        dims_thick = TowerDimensions(vrod_profile=20.0)
        assert dims_thick.total_width > dims_thin.total_width

    def test_io_zone_affects_total_height(self):
        dims_short = TowerDimensions(io_clearance_zone=50.0)
        dims_tall = TowerDimensions(io_clearance_zone=60.0)
        assert dims_tall.total_height - dims_short.total_height == 10.0


class TestRegistration:
    """Tower components must be discoverable in the registry."""

    def test_tower_frame_in_registry(self):
        registry = get_registry()
        assert "tower_frame" in registry

    def test_tower_bottom_panel_in_registry(self):
        registry = get_registry()
        assert "tower_bottom_panel" in registry

    def test_tower_frame_instantiation(self):
        from components.case_tower import TowerFrame
        frame = TowerFrame(dim=TowerDimensions())
        assert frame is not None

    def test_tower_bottom_panel_instantiation(self):
        from components.case_tower import TowerBottomPanel
        panel = TowerBottomPanel(dim=TowerDimensions())
        assert panel is not None
