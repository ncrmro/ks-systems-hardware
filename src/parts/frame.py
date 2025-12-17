import anchorscad as ad
from anchorscad import datatree
from config import CommonDimensions
from registry import register_part

@register_part("parts_standoff")
def create_standoff() -> ad.Shape:
    """Creates a standard standoff for rendering."""
    return Standoff(dim=CommonDimensions())

@ad.shape
@datatree
class Standoff(ad.CompositeShape):
    """A hexagonal standoff."""
    dim: CommonDimensions
    
    def build(self) -> ad.Maker:
        # Hexagonal prism
        # cylinder with fn=6 creates a hex
        # r = size / sqrt(3) for flat-to-flat conversion?
        # OpenSCAD cylinder(r=...) is point-to-point radius if fn is defined?
        # For hex: d_flat_to_flat = 2 * r * cos(30) = r * sqrt(3)
        # r = d / sqrt(3)
        
        r = (self.dim.standoff_hex_size_flat_to_flat / 1.732)
        
        # Standoff body (Z=0 to Z=height)
        body = ad.Cylinder(
            r=r, 
            h=self.dim.standoff_height, 
            fn=6
        )
        
        return body.solid("body").at("centre")

    @ad.anchor("top")
    def top(self):
        """Top center of the standoff (connects to mobo bottom)."""
        return ad.translate([0, 0, self.dim.standoff_height])

    @ad.anchor("bottom")
    def bottom(self):
        """Bottom center of the standoff (connects to case panel)."""
        return ad.identity()
