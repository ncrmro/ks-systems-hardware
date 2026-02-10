from anchorscad import datatree
from typing import Tuple, List
from dataclasses import field

# Import component dimensions
from lib.motherboard import MiniItxDimensions
from lib.psu import FlexAtxDimensions, SfxDimensions, PicoPsuDimensions
from lib.cooling import CoolingDimensions
from lib.heatsink import NOCTUA_L9, NOCTUA_L12S

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

    # Hinge and Latch
    hinge_barrel_diameter: float = 5.0
    hinge_clearance: float = 0.3
    hinge_knuckle_width: float = 10.0
    latch_hook_height: float = 3.0
    
    # Side Wall and Flap
    side_wall_height: float = 10.0
    side_lip_width: float = 3.0
    side_lip_height: float = 2.0
    side_ledge_width: float = 3.0
    side_ledge_height: float = 2.0
    
    # Top Hat
    tophat_interior_height: float = 15.0

    @property
    def pico_case_width(self) -> float:
        return self.mobo.width + (2 * self.wall_thickness)

    @property
    def pico_case_depth(self) -> float:
        return self.mobo.depth + (2 * self.wall_thickness)

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
