import anchorscad as ad
from anchorscad import datatree
from typing import List, Tuple
from dataclasses import field

@datatree
class CoolingDimensions:
    """Dimensions for CPU Coolers and other cooling components."""
    # Noctua NH-L12S
    # Base (5) + Pipes (30) + Fan (15) + Fins (20) = 70mm
    nh_l12s_total_height: float = 70.0
    nh_l12s_width: float = 128.0
    nh_l12s_depth: float = 146.0

    # Noctua NH-L9
    nh_l9_total_height: float = 37.0
    nh_l9_width: float = 95.0
    nh_l9_depth: float = 95.0
    nh_l9_base_height: float = 5.0
    nh_l9_heatsink_height: float = 18.0
    nh_l9_fan_height: float = 14.0
    nh_l9_fan_size: float = 92.0
    
    # Generic Fans
    fan_120_25_thickness: float = 25.0
    fan_120_15_thickness: float = 15.0

@datatree
class FanDimensions:
    """Standard Fan Dimensions."""
    size: float
    thickness: float
    mount_hole_inset: float = 7.5
    mount_hole_radius: float = 2.2
    hub_diameter: float = 40.0
    
    @property
    def hole_spacing(self) -> float:
        return self.size - 2 * self.mount_hole_inset

@ad.shape
@datatree
class Fan(ad.CompositeShape):
    """A parametric case fan."""
    dim: FanDimensions
    
    def build(self) -> ad.Maker:
        # Frame
        frame = ad.Box([self.dim.size, self.dim.size, self.dim.thickness])
        
        # Center Hole (Airflow)
        hole_r = (self.dim.size - 15) / 2
        center_hole = ad.Cylinder(r=hole_r, h=self.dim.thickness + 1, fn=60)
        
        # Mounting Holes
        mount_hole = ad.Cylinder(r=self.dim.mount_hole_radius, h=self.dim.thickness + 1, fn=20)
        
        # Hub
        hub = ad.Cylinder(r=self.dim.hub_diameter/2, h=self.dim.thickness - 4, fn=40)
        
        # Assembly
        # Frame
        shape = frame.solid("frame").colour("tan" if self.dim.thickness == 15 else "dimgray").at("centre")
        
        # Subtract Center Hole
        shape.add_at(center_hole.hole("airflow").at("centre"))
        
        # Subtract Mounting Holes
        # Positions relative to center
        # Top-Right: (size/2 - inset, size/2 - inset)
        d = self.dim.size / 2 - self.dim.mount_hole_inset
        offsets = [
            (d, d),
            (-d, d),
            (-d, -d),
            (d, -d)
        ]
        
        for i, (x, y) in enumerate(offsets):
            shape.add_at(
                mount_hole.hole(f"mount_{i}").at("centre", post=ad.translate([x, y, 0]))
            )
            
        # Add Hub (Solid)
        shape.add_at(hub.solid("hub").colour("black").at("centre"))
        
        return shape

# Pre-defined configurations
FAN_120_25 = FanDimensions(size=120, thickness=25)
FAN_120_15 = FanDimensions(size=120, thickness=15)
