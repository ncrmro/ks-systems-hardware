import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

@datatree
class VslotDimensions:
    """
    Dimensions for V-slot aluminum extrusion profiles.
    
    V-slot is a standard aluminum extrusion system with V-shaped grooves
    on all four sides for mounting wheels, brackets, and other components.
    Common sizes: 10x10, 20x20, 30x30, 40x40, 60x60, 80x80 mm.
    
    Based on OpenBuilds V-slot specification.
    """
    # Main cross-section size (square profile)
    size: float = 20.0
    
    # V-groove dimensions
    groove_width: float = 6.0  # Width of V-groove at surface
    groove_depth: float = 1.5  # Depth of V-groove
    groove_angle: float = 45.0  # Angle of V-groove sides
    
    # Center hole dimensions
    center_hole_diameter: float = 4.2  # M5 clearance hole (standard for 20x20)
    
    # Inner channel dimensions (created by the V-grooves)
    # The V-grooves create a recessed channel in the center of each face
    channel_width: float = field(init=False)
    
    def __post_init__(self):
        # Calculate channel width based on size and groove positions
        # Typically the channel is centered and takes up most of the face
        self.channel_width = self.size - 2 * self.groove_depth - 2.0
    
    @property
    def wall_thickness(self) -> float:
        """Thickness of outer wall before groove."""
        return self.groove_depth + 1.0
    
    @property
    def groove_offset(self) -> float:
        """Distance from center to groove centerline."""
        # Grooves are typically positioned symmetrically
        return (self.size / 2) - self.groove_depth


@ad.shape
@datatree
class Vslot(ad.CompositeShape):
    """
    Parametric V-slot aluminum extrusion profile.
    
    Creates a V-slot extrusion cross-section that can be used as a building
    block for structural frames. The length is parametric and can be specified
    when instantiating.
    
    The V-slot has:
    - Square cross-section (size x size)
    - V-grooves on all four faces
    - Center hole for mounting
    - Parametric length
    """
    dim: VslotDimensions = field(default_factory=VslotDimensions)
    length: float = 100.0  # Length of extrusion
    
    EPSILON = 0.01  # Small value for CSG operations
    
    def build(self) -> ad.Maker:
        """Build the V-slot extrusion."""
        # Main body - square profile
        body = ad.Box([self.dim.size, self.dim.size, self.length])
        shape = body.solid("vslot_body").colour("silver").at("centre")
        
        # Center hole through the length
        if self.dim.center_hole_diameter > 0:
            center_hole = ad.Cylinder(
                r=self.dim.center_hole_diameter / 2,
                h=self.length + self.EPSILON,
                fn=32
            )
            shape.add_at(center_hole.hole("center_hole").at("centre"))
        
        # Add V-grooves on all four faces
        # Each face gets a V-groove that runs the full length
        self._add_v_grooves(shape)
        
        return shape
    
    def _add_v_grooves(self, shape: ad.Maker):
        """Add V-shaped grooves to all four faces."""
        # V-groove is created using two angled box cuts to form a V shape
        # Each groove runs the full length of the extrusion
        
        groove_depth = self.dim.groove_depth
        groove_width = self.dim.groove_width
        
        # Create a V-groove by cutting two angled wedges
        # The angle is 45 degrees, so we need to cut at that angle
        
        # Create a wedge cutter - a box rotated 45 degrees
        # The cutter needs to be large enough to cut through the groove depth
        cutter_size = groove_depth * 1.5  # Make it larger than needed
        
        # For each face, we need two cutters (left and right side of V)
        # positioned symmetrically about the face center
        
        # Create the basic cutter shape - a thin box
        cutter = ad.Box([groove_width, self.length + self.EPSILON, cutter_size])
        
        # Helper function to add a V-groove on a face
        def add_v_on_face(face_name, face_offset, rotation_pre, rotation_post):
            """Add a V-groove to one face."""
            # Left side of V (45° angle)
            left_offset = groove_width / 4
            shape.add_at(
                cutter.hole(f"groove_{face_name}_left").at('centre'),
                post=rotation_pre * ad.translate([
                    -left_offset, 0, face_offset - groove_depth/2
                ]) * ad.rotX(45) * rotation_post
            )
            
            # Right side of V (45° angle, opposite direction)
            right_offset = groove_width / 4
            shape.add_at(
                cutter.hole(f"groove_{face_name}_right").at('centre'),
                post=rotation_pre * ad.translate([
                    right_offset, 0, face_offset - groove_depth/2
                ]) * ad.rotX(-45) * rotation_post
            )
        
        # Top face (Z+)
        add_v_on_face(
            "top",
            self.dim.size / 2,
            ad.IDENTITY,
            ad.IDENTITY
        )
        
        # Bottom face (Z-)
        add_v_on_face(
            "bottom",
            -self.dim.size / 2,
            ad.rotZ(180),
            ad.IDENTITY
        )
        
        # Right face (X+)
        add_v_on_face(
            "right",
            self.dim.size / 2,
            ad.rotZ(90),
            ad.IDENTITY
        )
        
        # Left face (X-)
        add_v_on_face(
            "left",
            -self.dim.size / 2,
            ad.rotZ(-90),
            ad.IDENTITY
        )
    
    @ad.anchor("end")
    def end_anchor(self, end: int = 0):
        """
        Anchor at the end of the extrusion.
        
        Args:
            end: 0 for start end (-Y), 1 for finish end (+Y)
        """
        z = -self.length / 2 if end == 0 else self.length / 2
        # Orient so +Z points outward from the extrusion end
        rotation = ad.IDENTITY if end == 1 else ad.rotX(180)
        return ad.translate([0, 0, z]) * rotation
    
    @ad.anchor("face")
    def face_anchor(self, face: int = 0):
        """
        Anchor on one of the four side faces.
        
        Args:
            face: 0=top(+Z), 1=right(+X), 2=bottom(-Z), 3=left(-X)
        """
        offsets = [
            (0, 0, self.dim.size / 2),   # Top
            (self.dim.size / 2, 0, 0),   # Right
            (0, 0, -self.dim.size / 2),  # Bottom
            (-self.dim.size / 2, 0, 0),  # Left
        ]
        rotations = [
            ad.IDENTITY,              # Top (normal +Z)
            ad.rotY(90),             # Right (normal +X)
            ad.rotX(180),            # Bottom (normal -Z)
            ad.rotY(-90),            # Left (normal -X)
        ]
        
        x, y, z = offsets[face]
        return ad.translate([x, y, z]) * rotations[face]
