import anchorscad as ad
from anchorscad import datatree
from typing import List, Tuple
from dataclasses import field

@datatree
class SfxDimensions:
    width: float = 125.0
    depth: float = 100.0
    height: float = 63.5

@ad.shape
@datatree
class SfxPsu(ad.CompositeShape):
    dim: SfxDimensions = field(default_factory=SfxDimensions)
    
    def build(self) -> ad.Maker:
        return ad.Box([self.dim.width, self.dim.depth, self.dim.height]).solid("sfx_body").colour("green").at("centre")


@datatree
class FlexAtxDimensions:
    width: float = 40.5  # Standard is often 40.5 or 81.5 depending on orientation
    length: float = 150.0
    height: float = 81.5
    # Mounting holes on rear face (standard Flex ATX)
    # Usually defined relative to edges.
    
    # C14 Inlet
    c14_width: float = 27.0
    c14_height: float = 19.5
    c14_depth: float = 5.0

@ad.shape
@datatree
class FlexAtxPsu(ad.CompositeShape):
    dim: FlexAtxDimensions = field(default_factory=FlexAtxDimensions)
    
    def build(self) -> ad.Maker:
        # Main Body
        body = ad.Box([self.dim.width, self.dim.length, self.dim.height])
        
        shape = body.solid("flex_body").colour("green").at("centre")
        
        # C14 Inlet
        # Calculate offsets relative to center
        # X: (width/2) - 3.4 - c14_width/2 - (width/2) ??
        # Let's convert OpenSCAD pos to Center pos.
        # OpenSCAD X range: 0 to width. Center X = width/2.
        # Pos X = width - 3.4 - width_c14. (This is left edge of C14).
        # Center of C14 X = (width - 3.4 - w_c14) + w_c14/2 = width - 3.4 - w_c14/2.
        # Rel to Center (0): (width - 3.4 - w_c14/2) - width/2 = width/2 - 3.4 - w_c14/2.
        
        c14_x = self.dim.width/2 - 3.4 - self.dim.c14_width/2
        c14_y = self.dim.length/2 + self.dim.c14_depth/2
        c14_z = self.dim.height/2 - 5.0 - self.dim.c14_height/2
        
        c14 = ad.Box([self.dim.c14_width, self.dim.c14_depth, self.dim.c14_height])
        
        shape.add_at(
            c14.solid("c14_inlet").colour("black").at("centre"),
            post=ad.translate([c14_x, c14_y, c14_z])
        )
        
        return shape

@datatree
class PicoPsuDimensions:
    """Dimensions for PicoPSU (minimal footprint)."""
    # Overall envelope derived from legacy OpenSCAD model
    # Connector: 50 (w) x 7 (d) x 13 (h)
    # PCB: 50 (w) x 1.6 (d) x 19 (h) sitting on top of connector
    # Components: 40 (w) x 4 (d) x 9 (h) on PCB face
    barrel_jack_diameter: float = 8.0 # Standard 5.5mm/2.5mm jack needs ~8mm hole?
    width: float = 50.0
    depth: float = 7.0
    height: float = 32.0  # 13 connector + 19 PCB stack
    connector_depth: float = 7.0
    connector_height: float = 13.0
    pcb_thickness: float = 1.6
    pcb_height: float = 19.0
    component_depth: float = 4.0
    component_inset: float = 5.0

@ad.shape
@datatree
class PicoPsu(ad.CompositeShape):
    dim: PicoPsuDimensions = field(default_factory=PicoPsuDimensions)
    
    def build(self) -> ad.Maker:
        connector = ad.Box([self.dim.width, self.dim.connector_depth, self.dim.connector_height])
        pcb = ad.Box([self.dim.width, self.dim.pcb_thickness, self.dim.pcb_height])

        shape = connector.solid("atx_male").colour("yellow").at("centre")

        pcb_z = self.dim.connector_height/2 + self.dim.pcb_height/2
        pcb_y = 0  # center align; component depth stays within connector depth
        shape.add_at(
            pcb.solid("pcb").colour("green").at("centre"),
            post=ad.translate([0, pcb_y, pcb_z])
        )

        components_w = self.dim.width - 2 * self.dim.component_inset
        components = ad.Box([components_w, self.dim.component_depth, self.dim.pcb_height - 10.0])
        comp_z = pcb_z  # same center as PCB, offset handled by height
        comp_y = self.dim.pcb_thickness/2 + self.dim.component_depth/2
        shape.add_at(
            components.solid("components").colour([0.2, 0.2, 0.2]).at("centre"),
            post=ad.translate([0, comp_y, comp_z])
        )

        return shape
