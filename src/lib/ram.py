import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

@datatree
class RamStickDimensions:
    """Standard DDR4 RAM Stick Dimensions."""
    length: float = 133.35
    height: float = 31.25
    thickness: float = 1.2

@ad.shape
@datatree
class RamStick(ad.CompositeShape):
    """A mock shape for a RAM stick."""
    dim: RamStickDimensions = field(default_factory=RamStickDimensions)
    
    def build(self) -> ad.Maker:
        # Note: OpenSCAD module uses thickness as Y and height as Z?
        # cube([ram_l, ram_t, ram_h])
        # x=L, y=T, z=H
        return ad.Box([self.dim.length, self.dim.thickness, self.dim.height]).solid("ram_stick").at("centre")
