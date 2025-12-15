import anchorscad as ad
from anchorscad import datatree
from typing import Tuple, List
from dataclasses import field

@datatree
class MiniItxDimensions:
    """Standard Mini-ITX Motherboard Dimensions."""
    width: float = 170.0
    depth: float = 170.0
    pcb_thickness: float = 1.6
    
    # Mounting holes relative to top-left corner (0,0) of the PCB
    # Standard Mini-ITX hole positions
    # Hole C: (6.35, 5.0)
    # Hole F: (163.65, 5.0)
    # Hole H: (6.35, 160.0)
    # Hole J: (163.65, 137.0) 
    mounting_holes: List[Tuple[float, float]] = field(default_factory=lambda: [
        (6.35, 5.0),       # Front-left (C)
        (163.65, 5.0),     # Front-right (F)
        (6.35, 160.0),     # Back-left (H)
        (163.65, 137.0)    # Back-right (J)
    ])

    # I/O Shield Dimensions
    io_shield_width: float = 158.75
    io_shield_height: float = 44.45
    
    @property
    def io_shield_x_offset(self) -> float:
        return (self.width - self.io_shield_width) / 2
        
    io_shield_z_offset: float = 5.0 # From bottom of PCB

@ad.shape
@datatree
class MiniItxMotherboard(ad.CompositeShape):
    """A mock shape for a Mini-ITX motherboard."""
    dim: MiniItxDimensions = field(default_factory=MiniItxDimensions)
    
    def build(self) -> ad.Maker:
        # Simple placeholder PCB
        pcb = ad.Box([self.dim.width, self.dim.depth, self.dim.pcb_thickness])
        
        # Color it purple like the original OScad
        return pcb.solid("pcb").at("centre")

    @ad.anchor("mounting_hole")
    def mounting_hole(self, index: int = 0):
        """Anchor for a specific mounting hole index (0-3)."""
        x, y = self.dim.mounting_holes[index]
        # Anchor is at the BOTTOM of the PCB (where standoff touches)
        # Z = 0 relative to PCB shape
        return ad.translate((x, y, 0))