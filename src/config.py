from anchorscad import datatree
from typing import Tuple, List
from dataclasses import field

# Import component dimensions
from vitamins.motherboard import MiniItxDimensions
from vitamins.psu import FlexAtxDimensions, SfxDimensions, PicoPsuDimensions
from vitamins.cooling import CoolingDimensions
from vitamins.heatsink import NOCTUA_L9, NOCTUA_L12S

@datatree
class CommonDimensions:
    """Shared dimensions for all case configurations."""
    wall_thickness: float = 3.0
    
    # Components
    mobo: MiniItxDimensions = field(default_factory=MiniItxDimensions)

    # Standoffs
    standoff_height: float = 6.0
    standoff_locations: List[Tuple[float, float]] = field(default_factory=lambda: [
        (6.35, 5.0),       # Front-left
        (163.65, 5.0),     # Front-right
        (6.35, 160.0),     # Back-left
        (163.65, 137.0)    # Back-right
    ])
    
    # Integrated Bottom Panel Standoffs
    standoff_boss_height: float = 2.5
    standoff_hex_size_flat_to_flat: float = 5.0
    standoff_pocket_depth: float = 2.2
    standoff_boss_diameter: float = 6.85
    standoff_mounting_screw_length: float = 8.0
    standoff_screw_clearance_hole: float = 3.3
    
    # Ventilation
    honeycomb_radius: float = 3.0
    vent_padding: float = 5.0
    
    # Panel Assembly
    panel_screw_radius: float = 1.6
    panel_screw_inset: float = 8.0


@datatree
class PicoDimensions(CommonDimensions):
    """Configuration for Pico ITX case."""
    
    psu: PicoPsuDimensions = field(default_factory=PicoPsuDimensions)
    cooling: CoolingDimensions = field(default_factory=lambda: CoolingDimensions(
        nh_l9_total_height=NOCTUA_L9.total_height,
        nh_l9_base_height=NOCTUA_L9.base_height,
        nh_l9_heatsink_height=NOCTUA_L9.fins_height,
        nh_l9_fan_height=NOCTUA_L9.fan_height,
        nh_l9_width=NOCTUA_L9.width,
        nh_l9_depth=NOCTUA_L9.depth,
        nh_l9_fan_size=NOCTUA_L9.fan_size
    ))

    @property
    def pico_case_width(self) -> float:
        return self.mobo.width + (2 * self.wall_thickness)

    @property
    def pico_case_depth(self) -> float:
        return self.mobo.depth + (2 * self.wall_thickness)

    # HDD top hat allowance
    hdd_height_allowance: float = 12.5  # 9.5mm SSD + 3mm clearance

    @property
    def pico_exterior_height_hdd(self) -> float:
        return self.pico_exterior_height + self.hdd_height_allowance

    # Latch
    latch_arm_length: float = 12.0
    latch_arm_thickness: float = 1.5
    latch_arm_width: float = 10.0
    latch_hook_depth: float = 2.0
    latch_hook_height: float = 1.5

    # Variation: "normal" or "server"
    variation: str = "normal"

    @property
    def extra_interior_height(self) -> float:
        # Server variation adds height for 2.5" drives
        return 15.0 if self.variation == "server" else 0.0

    @property
    def pico_interior_chamber_height(self) -> float:
        cooler_stack = self.standoff_height + self.mobo.pcb_thickness + self.cooling.nh_l9_total_height
        io_stack = self.standoff_height + self.mobo.pcb_thickness + self.mobo.io_shield_z_offset + self.mobo.io_shield_height
        
        base_height = max(cooler_stack, io_stack)
        return base_height + self.extra_interior_height

    @property
    def pico_exterior_height(self) -> float:
        return self.pico_interior_chamber_height + (2 * self.wall_thickness)


@datatree
class MinimalDimensions(CommonDimensions):
    """Configuration for Minimal/NAS case."""
    
    psu: FlexAtxDimensions = field(default_factory=FlexAtxDimensions)
    cooling: CoolingDimensions = field(default_factory=lambda: CoolingDimensions(
        nh_l12s_total_height=NOCTUA_L12S.total_height,
        nh_l12s_width=NOCTUA_L12S.width,
        nh_l12s_depth=NOCTUA_L12S.depth
    ))
    
    nas_2disk_rail_width: float = 2.0
    nas_2disk_gap: float = 5.0
    nas_2disk_padding: float = 2.0
    
    hdd_width: float = 101.6 # Could be moved to storage.py lib

    @property
    def nas_2disk_width(self) -> float:
        bay_width = self.hdd_width + 2 * self.nas_2disk_rail_width
        inner_width = 2 * bay_width + self.nas_2disk_gap
        return inner_width + 2 * (self.wall_thickness + self.nas_2disk_padding)

    @property
    def interior_chamber_height(self) -> float:
        return self.standoff_height + self.mobo.pcb_thickness + self.cooling.nh_l12s_total_height

    @property
    def minimal_exterior_height(self) -> float:
        return self.interior_chamber_height + 2 * self.wall_thickness
    
    @property
    def minimal_with_psu_width(self) -> float:
        return self.nas_2disk_width


@datatree
class GpuDimensions:
    """Reference 2-slot GPU dimensions."""
    length: float = 267.0
    height: float = 120.0
    thickness: float = 40.0


@datatree
class SensorBayDimensions:
    """ESP32-C3 + SCD41 + BME280 sensor bay dimensions."""
    esp32_width: float = 18.0
    esp32_depth: float = 22.5
    scd41_width: float = 13.3
    scd41_depth: float = 21.75
    bme280_width: float = 11.0
    bme280_depth: float = 14.0
    sensor_clearance: float = 1.0
    vent_hole_count: int = 6
    vent_hole_diameter: float = 5.0

    @property
    def bay_width(self) -> float:
        """Width = widest sensor + clearance."""
        return max(self.esp32_width, self.scd41_width, self.bme280_width) + 2 * self.sensor_clearance

    @property
    def bay_depth(self) -> float:
        """Depth = all sensors stacked + clearance gaps."""
        return self.esp32_depth + self.scd41_depth + self.bme280_depth + 4 * self.sensor_clearance


@datatree
class TowerDimensions(CommonDimensions):
    """Configuration for Tower case — inverted IO, PSU on top, vertical GPU."""

    psu: SfxDimensions = field(default_factory=SfxDimensions)
    gpu: GpuDimensions = field(default_factory=GpuDimensions)
    cooling: CoolingDimensions = field(default_factory=lambda: CoolingDimensions(
        nh_l12s_total_height=NOCTUA_L12S.total_height,
        nh_l12s_width=NOCTUA_L12S.width,
        nh_l12s_depth=NOCTUA_L12S.depth
    ))
    sensor_bay: SensorBayDimensions = field(default_factory=SensorBayDimensions)

    # V-rod frame
    vrod_profile: float = 20.0  # 20×20mm square columns (configurable to 10×10)

    # Clearances
    mobo_clearance: float = 1.0
    psu_clearance: float = 2.0
    gpu_clearance: float = 3.0
    sensor_clearance: float = 1.0

    # IO clearance zone (inverted IO — cables plug in from below)
    io_clearance_zone: float = 55.0  # IO shield 49.45mm + cable bend radius

    # Mobo-to-PSU vertical gap (must fit cooler + airflow)
    mobo_to_psu_gap: float = 75.0  # NH-L12S 70mm + 5mm

    # Fan
    fan_size: float = 120.0
    fan_depth: float = 25.0
    fan_mount_hole_inset: float = 7.5

    # C14 power panel-mount cutout
    c14_cutout_width: float = 28.0
    c14_cutout_height: float = 22.0
    c14_mount_hole_spacing_x: float = 32.0
    c14_mount_hole_spacing_y: float = 24.0

    # PCIe riser cable routing slot
    pcie_slot_width: float = 90.0  # 85mm cable + 5mm clearance
    pcie_slot_height: float = 8.0  # 3mm cable + 5mm clearance

    # PSU cable pass-through
    psu_cable_passthrough: float = 15.0

    # GPU anti-sag
    gpu_antisag_depth: float = 3.0
    gpu_antisag_width: float = 10.0

    # ESP32 USB-C access cutout
    esp32_usb_cutout_width: float = 11.0
    esp32_usb_cutout_height: float = 5.0

    # Dovetail joints (reuse existing dimensions)
    dovetail_engagement: float = 25.0
    dovetail_clearance: float = 0.3

    # --- Computed properties ---

    @property
    def mobo_chamber_width(self) -> float:
        return self.mobo.width + 2 * self.mobo_clearance

    @property
    def mobo_chamber_depth(self) -> float:
        return self.mobo.depth + 2 * self.mobo_clearance

    @property
    def gpu_chamber_width(self) -> float:
        return self.gpu.thickness + 2 * self.gpu_clearance

    @property
    def gpu_chamber_depth(self) -> float:
        return self.gpu.length + 2 * self.gpu_clearance

    @property
    def psu_chamber_height(self) -> float:
        return self.psu.height + 2 * self.psu_clearance

    @property
    def io_cutout_width(self) -> float:
        return self.mobo.io_shield_width + 1.25

    @property
    def io_cutout_height(self) -> float:
        return self.mobo.io_shield_height + 1.25

    @property
    def sensor_bay_width(self) -> float:
        return self.sensor_bay.bay_width

    @property
    def sensor_bay_depth(self) -> float:
        return self.sensor_bay.bay_depth

    @property
    def fan_mount_depth(self) -> float:
        return self.fan_depth

    @property
    def top_panel_width(self) -> float:
        """Top panel must fit the 120mm fan."""
        return self.mobo_chamber_width + 2 * self.vrod_profile

    @property
    def total_height(self) -> float:
        """Full case height from bottom wall to top wall."""
        return (
            self.wall_thickness          # bottom wall
            + self.io_clearance_zone     # cable space below inverted IO
            + self.standoff_height       # mobo standoffs
            + self.mobo.pcb_thickness    # PCB
            + self.mobo_to_psu_gap       # cooler + airflow
            + self.psu_chamber_height    # SFX PSU + clearance
            + self.fan_depth             # top exhaust fan
            + self.wall_thickness        # top wall
        )

    @property
    def total_width(self) -> float:
        """Case width: mobo chamber + GPU chamber + frame columns + walls."""
        return (
            self.wall_thickness
            + self.vrod_profile
            + self.mobo_chamber_width
            + self.vrod_profile
            + self.gpu_chamber_width
            + self.vrod_profile
            + self.wall_thickness
        )
