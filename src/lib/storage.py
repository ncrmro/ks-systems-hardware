import anchorscad as ad
from anchorscad import datatree
from typing import Tuple, List
from dataclasses import field

@datatree
class SSD25Dimensions:
    """Standard 2.5" SSD/HDD Dimensions (SFF-8201)."""
    width: float = 69.85
    length: float = 100.0
    height: float = 9.5
    
    # Mounting hole positions (Side)
    # Measured from front edge (y=0)
    hole_front_y: float = 14.0
    hole_rear_y: float = 90.6
    # Measured from bottom surface (z=0)
    hole_z: float = 4.07
    
    # Bottom mounting holes
    # Usually 4 holes on bottom as well. 
    # SFF-8201: 
    # Width separation: 61.72mm (centered) -> (69.85 - 61.72)/2 = 4.065mm from side
    # Length locations: 14mm and 90.6mm from front (same as side?)
    # Let's add them if needed, but side holes seem to be the focus of the scad file variables.
    
    @property
    def side_hole_locations(self) -> List[Tuple[float, float, float]]:
        """Returns list of (x, y, z) for side mounting holes.
        Coordinates relative to bottom-front-left corner (0,0,0) of the drive body.
        But anchorscad shapes are usually centered. 
        We will return them relative to the corner, and the shape class will handle anchoring.
        """
        # Left side (x=0) and Right side (x=width)
        # However, holes go *into* the drive.
        # Let's just define the centers on the surface.
        return [
            (0, self.hole_front_y, self.hole_z),            # Left Front
            (0, self.hole_rear_y, self.hole_z),             # Left Rear
            (self.width, self.hole_front_y, self.hole_z),   # Right Front
            (self.width, self.hole_rear_y, self.hole_z)     # Right Rear
        ]

@ad.shape
@datatree
class SSD25(ad.CompositeShape):
    """A mock shape for a 2.5" SSD."""
    dim: SSD25Dimensions = field(default_factory=SSD25Dimensions)
    
    def build(self) -> ad.Maker:
        body = ad.Box([self.dim.width, self.dim.length, self.dim.height])
        return body.solid("ssd_body").at("centre")

    @ad.anchor("side_hole")
    def side_hole(self, index: int):
        """Anchor for a specific side mounting hole (0-3).
        0: Left Front
        1: Left Rear
        2: Right Front
        3: Right Rear
        """
        # Calculate position relative to center
        # Center is at width/2, length/2, height/2 relative to corner
        
        # Get corner coords
        cx, cy, cz = self.dim.side_hole_locations[index]
        
        # Transform to center coords
        x = cx - self.dim.width / 2
        y = cy - self.dim.length / 2
        z = cz - self.dim.height / 2
        
        # Orientation: Hole axis is X axis.
        # Left holes (index 0, 1): Pointing -X (normal out of drive) or +X (into drive)?
        # Usually anchors face *out*.
        # Left side normal is -X. Right side normal is +X.
        
        rot = [0, 0, 0]
        if index < 2: # Left side
            rot = [0, 180, 0] # Face Left (-X)? No, default box face is +X. 180 makes it -X.
            # wait, ad.Box default face 0 is +X?
            # actually anchorscad standard orientation for holes/screws is typically +Z.
            # If we want a screw to go *into* the hole, the hole anchor usually faces *out*.
            pass
        
        # Let's just place the point for now. Orientation can be refined.
        return ad.translate((x, y, z))
