import anchorscad as ad
from keystone import register_part
from keystone.config import MinimalDimensions
from keystone.lib.motherboard import MiniItxMotherboard
from keystone.parts.frame import Standoff

@register_part("test_mobo_assembly")
def test_mobo_assembly() -> ad.Shape:
    """A test assembly of a Motherboard + 4 Standoffs."""
    
    # 1. Create dimensions
    dim = MinimalDimensions()
    
    # 2. Create Components
    mobo = MiniItxMotherboard(dim=dim.mobo)
    standoff_shape = Standoff(dim=dim)
    
    # 3. Create Assembly Maker
    # Use the motherboard as the base for the assembly, anchored at mounting hole 0
    assembly = mobo.solid("mobo").at("mounting_hole", 0)
    
    # 4. Attach 4 standoffs to the motherboard holes
    for i in range(4):
        # We want the 'top' of the standoff to match the mounting hole location.
        # So we create a Maker for the standoff anchored at its 'top'.
        # Must give unique name for each instance in the assembly.
        standoff_maker = standoff_shape.solid(f"standoff_{i}").at("top")
        
        assembly.add_at(
            standoff_maker, 
            post=mobo.mounting_hole(i)
        )
        
    return assembly
