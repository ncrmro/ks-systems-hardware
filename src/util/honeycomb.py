import anchorscad as ad
from anchorscad import datatree
import math

@ad.shape
@datatree
class Honeycomb(ad.CompositeShape):
    """
    Honeycomb pattern for ventilation.
    Generated on the XY plane, centered at (0,0).
    """
    width: float
    height: float
    thickness: float
    radius: float = 3.0
    
    def build(self) -> ad.Maker:
        # Spacing based on hex geometry
        # Distance between centers of adjacent hexagons in a row
        x_spacing = self.radius * 2.5
        # Distance between rows
        y_spacing = self.radius * 2.5 * math.sqrt(3) / 2
        
        cols = int(self.width / x_spacing)
        rows = int(self.height / y_spacing)
        
        if cols == 0 or rows == 0:
            return ad.Box([0.1, 0.1, self.thickness]).hole("dummy").at("centre")

        holes = []
        for row in range(rows):
            for col in range(cols):
                x = col * x_spacing
                y = row * y_spacing + (y_spacing / 2 if col % 2 == 1 else 0)
                holes.append((x, y))
        
        # Calculate the bounding box of the generated hole centers
        pts_x = [h[0] for h in holes]
        pts_y = [h[1] for h in holes]
        min_x, max_x = min(pts_x), max(pts_x)
        min_y, max_y = min(pts_y), max(pts_y)
        
        center_x = (min_x + max_x) / 2
        center_y = (min_y + max_y) / 2
        
        # We use a single Cylinder shape and add it multiple times
        # Note: fn=6 for hexagon
        hex_hole = ad.Cylinder(r=self.radius, h=self.thickness + 0.5, fn=6)
        
        # Start with the first hole as the root of the Maker
        first_x, first_y = holes[0]
        shape = hex_hole.hole("hex_0").at("centre", post=ad.translate([first_x - center_x, first_y - center_y, 0]))
        
        for i, (x, y) in enumerate(holes[1:]):
            shape.add_at(
                hex_hole.hole(f"hex_{i+1}").at("centre"),
                post=ad.translate([x - center_x, y - center_y, 0])
            )
            
        return shape
