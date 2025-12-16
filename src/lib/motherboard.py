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
class Atx24PinConnector(ad.CompositeShape):
    """Standard ATX 24-pin power connector."""
    length: float = 51.6
    width: float = 10.0
    height: float = 13.0
    
    def build(self) -> ad.Maker:
        return ad.Box([self.length, self.width, self.height]).solid("atx_connector").at("face_centre", 0)

@ad.shape
@datatree
class MiniItxMotherboard(ad.CompositeShape):
    """A mock shape for a Mini-ITX motherboard."""
    dim: MiniItxDimensions = field(default_factory=MiniItxDimensions)
    
    def build(self) -> ad.Maker:
        # PCB
        pcb = ad.Box([self.dim.width, self.dim.depth, self.dim.pcb_thickness])
        
        # IO Shield
        io_shield_thickness = 2.0
        io_shield = ad.Box([
            self.dim.io_shield_width, 
            io_shield_thickness, 
            self.dim.io_shield_height
        ])
        
        # ATX Connector
        atx = Atx24PinConnector()
        
        # Assembly
        # PCB is base, centered at (0,0,0)
        shape = pcb.solid("pcb").at("centre")
        
        # IO Shield Placement
        # Y: Back edge (depth/2) - half thickness
        # Z: Top of PCB (thick/2) + half height
        io_y = self.dim.depth / 2 - io_shield_thickness / 2
        io_z = self.dim.pcb_thickness / 2 + self.dim.io_shield_height / 2
        
        shape.add_at(
            io_shield.solid("io_shield").at("centre"),
            post=ad.translate([0, io_y, io_z])
        )
        
        # ATX Connector Placement
        # OpenSCAD: [width, 25, thick] with rotZ(90)
        # Rotated size: X=10, Y=51.6
        # Center X: Right edge (width/2) - half width (5)
        # Center Y: Front (-depth/2) + 25 + half length (51.6/2)
        # Center Z: Top (thick/2) + half height (13/2)
        
        atx_rot_width = 10.0
        atx_rot_length = 51.6
        atx_height = 13.0
        
        atx_x = self.dim.width / 2 - atx_rot_width / 2
        atx_y = -self.dim.depth / 2 + 25.0 + atx_rot_length / 2
        atx_z = self.dim.pcb_thickness / 2 + atx_height / 2
        
        shape.add_at(
            atx.solid("atx_connector").at("centre"),
            post=ad.translate([atx_x, atx_y, atx_z]) * ad.rotZ(90)
        )

        return shape

    @ad.anchor("mounting_hole")
    def mounting_hole(self, index: int = 0):
        """Anchor for a specific mounting hole index (0-3)."""
        x, y = self.dim.mounting_holes[index]
        # Anchor is at the BOTTOM of the PCB (where standoff touches)
        # Z = 0 relative to PCB shape
        return ad.translate((x, y, 0))