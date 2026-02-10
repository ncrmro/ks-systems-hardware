import anchorscad as ad
from anchorscad import datatree
from dataclasses import field, replace
from typing import List
from registry import register_part

@datatree
class HingeDimensions:
    barrel_diameter: float = 5.0
    clearance: float = 0.3
    knuckle_width: float = 10.0
    knuckle_count: int = 5
    pin_length: float = 2.0
    pin_diameter_ratio: float = 0.6

@ad.shape
@datatree
class HingeKnuckle(ad.CompositeShape):
    """
    A single hinge knuckle. 
    'male' has pins on both ends.
    'female' has sockets on both ends.
    """
    dim: HingeDimensions
    mode: str = "male" # "male" or "female"
    
    def build(self) -> ad.Maker:
        r = self.dim.barrel_diameter / 2
        w = self.dim.knuckle_width
        cl = self.dim.clearance
        pin_r = r * self.dim.pin_diameter_ratio
        pin_h = self.dim.pin_length
        
        # Main barrel
        # Cylinder default is at centre, height along Z.
        barrel = ad.Cylinder(r=r, h=w, fn=32)
        shape = barrel.solid("barrel").at("centre")
        
        if self.mode == "male":
            # Male has pins on the ends
            # Tapered pin for easier snap-fit
            pin = ad.Cone(r_base=pin_r - cl, r_top=pin_r - cl - 0.5, h=pin_h, fn=32)
            
            # Pin on +Z end
            shape.add_at(
                pin.solid("pin_pos").at("base"),
                post=ad.translate([0, 0, w/2])
            )
            # Pin on -Z end
            shape.add_at(
                pin.solid("pin_neg").at("base"),
                post=ad.translate([0, 0, -w/2]) * ad.rotX(180)
            )
        else:
            # Female has sockets on the ends
            # Sockets are slightly deeper than pins
            socket_h = pin_h + cl
            socket = ad.Cone(r_base=pin_r, r_top=pin_r - 0.5, h=socket_h, fn=32)
            
            # Socket on +Z end
            shape.add_at(
                socket.hole("socket_pos").at("base"),
                post=ad.translate([0, 0, w/2 - socket_h]) # Goes inwards
            )
            
            # Socket on -Z end
            shape.add_at(
                socket.hole("socket_neg").at("base"),
                post=ad.translate([0, 0, -w/2 + socket_h]) * ad.rotX(180) # Goes inwards
            )
            
        return shape
    
    @ad.anchor
    def axis(self):
        return ad.IDENTITY

@ad.shape
@datatree
class HingeLine(ad.CompositeShape):
    """
    An array of alternating knuckles along a given length.
    """
    dim: HingeDimensions
    length: float
    indices: List[int] = field(default_factory=lambda: [0, 2, 4])
    total_count: int = 5
    mode: str = "male"
    
    def build(self) -> ad.Maker:
        pitch = self.length / self.total_count
        
        # Override knuckle_width to match pitch so they interlock
        knuckle_dim = replace(self.dim, knuckle_width=pitch)
        
        # Base is a dummy box or just use the first knuckle if indices not empty
        if not self.indices:
            return ad.Box([0.1, 0.1, 0.1]).hole("dummy").at("centre")
        
        # We'll use a coordinate system centered on the line.
        # Line runs along Z axis by default.
        
        # Find the first index to start the shape
        first_idx = self.indices[0]
        first_z = (first_idx * pitch) - (self.length / 2) + (pitch / 2)
        
        knuckle = HingeKnuckle(dim=knuckle_dim, mode=self.mode)
        shape = knuckle.solid(f"knuckle_{first_idx}").at("centre", post=ad.translate([0, 0, first_z]))
        
        for idx in self.indices[1:]:
            z = (idx * pitch) - (self.length / 2) + (pitch / 2)
            shape.add_at(
                knuckle.solid(f"knuckle_{idx}").at("centre"),
                post=ad.translate([0, 0, z])
            )
            
        return shape

@ad.shape
@datatree
class LatchHook(ad.CompositeShape):
    """
    Press-to-release hook for back panel closure.
    """
    hook_height: float = 3.0
    width: float = 10.0
    depth: float = 5.0
    thickness: float = 2.0
    
    def build(self) -> ad.Maker:
        # Base plate
        base = ad.Box([self.width, self.depth, self.thickness])
        shape = base.solid("base").at("centre")
        
        # Hook arm
        arm_h = 10.0
        arm = ad.Box([self.width, self.thickness, arm_h])
        shape.add_at(
            arm.solid("arm").at("centre"),
            post=ad.translate([0, self.depth/2 - self.thickness/2, self.thickness/2 + arm_h/2])
        )
        
        # Hook tip
        tip = ad.Box([self.width, self.hook_height + self.thickness, self.thickness])
        shape.add_at(
            tip.solid("tip").at("centre"),
            post=ad.translate([0, self.depth/2 - self.thickness/2 + self.hook_height/2, self.thickness/2 + arm_h - self.thickness/2])
        )
        
        return shape

@register_part("parts_hinge_knuckle")
def create_hinge_knuckle() -> ad.Shape:
    return HingeKnuckle(dim=HingeDimensions())

@register_part("parts_hinge_line")
def create_hinge_line() -> ad.Shape:
    return HingeLine(dim=HingeDimensions(), length=176.0)

@register_part("parts_latch_hook")
def create_latch_hook() -> ad.Shape:
    return LatchHook()