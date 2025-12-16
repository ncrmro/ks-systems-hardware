import anchorscad as ad
from anchorscad import datatree

@datatree
class FlexAtxDimensions:
    """Flex ATX Power Supply Dimensions."""
    width: float = 40.0
    length: float = 150.0
    height: float = 80.0
    
    mount_hole_radius: float = 2.1
    mount_x_inset: float = 5.0
    mount_z_inset: float = 5.0

@datatree
class SfxDimensions:
    """SFX Power Supply Dimensions."""
    width: float = 100.0
    length: float = 125.0
    height: float = 63.5

@datatree
class PicoPsuDimensions:
    """Pico PSU (DC-DC) Dimensions."""
    # This is a rough approx for the connector/PCB sticking up
    width: float = 20.0
    depth: float = 44.0 
    height: float = 30.0 
    
    barrel_jack_diameter: float = 7.0 # Panel mount diameter

