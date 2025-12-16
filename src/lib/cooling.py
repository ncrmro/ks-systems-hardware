import anchorscad as ad
from anchorscad import datatree

@datatree
class CoolingDimensions:
    """Dimensions for Fans and Coolers."""
    
    # Fans
    fan_120_size: float = 120.0
    fan_120_thickness: float = 25.0
    
    # Coolers
    # Noctua NH-L9i/a
    nh_l9_total_height: float = 37.0
    
    # Noctua NH-L12S
    nh_l12s_total_height: float = 70.0
    nh_l12s_width: float = 128.0
    nh_l12s_depth: float = 146.0

