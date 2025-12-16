import anchorscad as ad
from anchorscad import datatree
from dataclasses import field
from config import CommonDimensions
from registry import register_part
from lib.cooling import CoolingDimensions

@register_part("noctua_l12s")
def create_noctua_l12s() -> ad.Shape:
    """Creates a Noctua NH-L12S heatsink for rendering."""
    return NoctuaL12S()

@ad.shape
@datatree
class CpuBase(ad.CompositeShape):
    w: float = 38.0
    d: float = 40.0
    h: float = 5.0
    
    def build(self) -> ad.Maker:
        return ad.Box([self.w, self.d, self.h]).solid("base").colour([0.72, 0.45, 0.2]).at("centre")

@ad.shape
@datatree
class Heatpipes(ad.CompositeShape):
    count: int = 4
    spacing: float = 20.0
    height: float = 30.0
    diameter: float = 6.0
    
    def build(self) -> ad.Maker:
        r = self.diameter / 2
        pipes_maker = None
        
        start_x = -((self.count - 1) * self.spacing) / 2
        
        for i in range(self.count):
            x = start_x + (i * self.spacing)
            # Create cylinder shape
            pipe_shape = ad.Cylinder(r=r, h=self.height, fn=32)
            
            # Create Maker positioned and colored
            # Note: .at() must be called on the object returned by .solid() (or similar context)
            # and .colour() must be called BEFORE .at().
            m = pipe_shape.solid(f"pipe_{i}").colour([0.72, 0.45, 0.2]).at("centre", post=ad.translate([x, 0, self.height/2]))
            
            if pipes_maker is None:
                pipes_maker = m
            else:
                pipes_maker.add_at(m, post=ad.IDENTITY)
                
        return pipes_maker

@ad.shape
@datatree
class Fan120x15(ad.CompositeShape):
    size: float = 120.0
    thickness: float = 15.0
    
    def build(self) -> ad.Maker:
        # Frame Shape
        frame_shape = ad.Box([self.size, self.size, self.thickness])
        # Hole Shape
        hole_r = (self.size - 15) / 2
        hole_shape = ad.Cylinder(r=hole_r, h=self.thickness + 1, fn=60)
        
        # Create Makers
        # Main body is solid, colored
        m_frame = frame_shape.solid("frame").colour("tan").at("centre")
        
        # Hole is a hole (subtraction)
        m_hole = hole_shape.hole("hole").at("centre")
        
        # Add hole to frame
        m_frame.add_at(m_hole)
        
        return m_frame

@ad.shape
@datatree
class HeatsinkFins(ad.CompositeShape):
    w: float = 128.0
    d: float = 146.0
    h: float = 20.0
    cutout_depth: float = 13.0
    
    def build(self) -> ad.Maker:
        # Main block shape
        block_shape = ad.Box([self.w, self.d, self.h])
        
        # Cutout shape
        cutout_w = self.w + 10 # Oversize
        cutout_shape = ad.Box([cutout_w, self.cutout_depth, self.h + 1])
        
        # Create Makers
        m_block = block_shape.solid("block").colour("silver").at("centre")
        
        cutout_y = -(self.d / 2) + (self.cutout_depth / 2)
        m_cutout = cutout_shape.hole("cutout").at("centre", post=ad.translate([0, cutout_y, 0]))
        
        # Add hole to block
        m_block.add_at(m_cutout)
        
        return m_block

@ad.shape
@datatree
class NoctuaL12S(ad.CompositeShape):
    """Noctua NH-L12S Low Profile Cooler."""
    dim: CoolingDimensions = field(default_factory=CoolingDimensions)
    
    def build(self) -> ad.Maker:
        # Dimensions
        base_h = 5.0
        pipes_h = 30.0
        fan_h = 15.0
        fins_h = 20.0
        
        cooler_w = 128.0
        cooler_d = 146.0
        
        # 1. Base (Reference anchor is center of base plate)
        # Base is 5mm thick. Center Z=0 means plate spans -2.5 to 2.5?
        # Usually "Base" anchor is the contact surface (bottom).
        # So we place Base such that its bottom face is at Z=0.
        base = CpuBase(h=base_h)
        # CpuBase.build() returns centered box.
        # Move up by h/2
        assembly = base.solid("base").at("centre", post=ad.translate([0, 0, base_h/2]))
        
        # 2. Heatpipes
        # Sit on top of base (Z = base_h)
        # Positioned Y = 20mm from front edge of cooler.
        # Cooler depth 146. Base depth 40. Both centered on Z-axis of assembly?
        # Legacy: Base centered in Cooler.
        # Front edge of cooler is at Y = -146/2 = -73.
        # Pipes at Y = 20 from front => Y = -73 + 20 = -53.
        pipes = Heatpipes(height=pipes_h)
        # Pipes build() returns centered cylinders?
        # ad.Cylinder(h=30).solid() -> Z -15 to 15.
        # We want pipes to sit on top of base. Z_bottom = base_h.
        # So Z_center = base_h + pipes_h/2 = 5 + 15 = 20.
        
        # Heatpipes.build() puts cylinders at Z=height/2 relative to origin.
        # So Heatpipes origin is at Z=0 (bottom of pipes).
        # We place Heatpipes origin at Z=base_h.
        
        assembly.add_at(
            pipes.solid("pipes").at("centre"), 
            post=ad.translate([0, -53, base_h])
        )
        
        # 3. Fan
        # Sits on top of pipes (Z = base_h + pipes_h = 35)
        # Centered in cooler (X=0, Y=0).
        fan = Fan120x15()
        # Fan.build() returns centered box.
        # Z_center = 35 + 15/2 = 42.5
        assembly.add_at(
            fan.solid("fan").at("centre"),
            post=ad.translate([0, 0, base_h + pipes_h + fan_h/2])
        )
        
        # 4. Fins
        # Sit on top of fan (Z = 50)
        # Centered in cooler (X=0, Y=0).
        fins = HeatsinkFins(h=fins_h)
        # Z_center = 50 + 20/2 = 60
        assembly.add_at(
            fins.solid("fins").at("centre"),
            post=ad.translate([0, 0, base_h + pipes_h + fan_h + fins_h/2])
        )
        
        return assembly

    @ad.anchor("base")
    def base(self):
        """Base contact point (CPU surface)."""
        return ad.IDENTITY
