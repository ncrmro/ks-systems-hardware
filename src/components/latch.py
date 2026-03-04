import anchorscad as ad
from anchorscad import datatree
from dataclasses import field

from registry import register_part


@datatree
class LatchDimensions:
    """Snap-fit flex-arm latch dimensions."""
    arm_length: float = 12.0
    arm_thickness: float = 1.5
    arm_width: float = 10.0
    hook_depth: float = 2.0
    hook_height: float = 1.5


@ad.shape
@datatree
class LatchArm(ad.CompositeShape):
    """
    Vertical flex arm with outward hook at bottom.
    Attaches to the inner face of the top shell front wall.
    The arm hangs downward (-Z) and the hook protrudes outward (+Y).
    Origin at geometric centre of arm.
    """
    dim: LatchDimensions = field(default_factory=LatchDimensions)

    def build(self) -> ad.Maker:
        dd = self.dim

        # Vertical arm (hangs downward from attachment)
        arm = ad.Box([dd.arm_width, dd.arm_thickness, dd.arm_length])
        shape = arm.solid("arm").colour("orange").at("centre")

        # Hook at bottom - protrudes outward (+Y direction)
        hook = ad.Box([dd.arm_width, dd.hook_depth + dd.arm_thickness, dd.hook_height])
        hook_y = dd.hook_depth / 2
        hook_z = -dd.arm_length / 2 + dd.hook_height / 2

        shape.add_at(
            hook.solid("hook").colour("orange").at("centre"),
            post=ad.translate([0, hook_y, hook_z])
        )

        return shape


@ad.shape
@datatree
class LatchLedge(ad.CompositeShape):
    """
    Rectangular protrusion on the base panel front edge.
    The latch arm hook catches under this ledge.
    Origin at geometric centre of ledge.
    """
    dim: LatchDimensions = field(default_factory=LatchDimensions)

    def build(self) -> ad.Maker:
        dd = self.dim

        # Ledge protrudes inward from the panel edge
        ledge = ad.Box([dd.arm_width, dd.hook_depth, dd.hook_height])
        shape = ledge.solid("ledge").colour("dimgray").at("centre")

        return shape


@register_part("latch_arm", part_type="component")
def create_latch_arm() -> ad.Shape:
    return LatchArm()


@register_part("latch_ledge", part_type="component")
def create_latch_ledge() -> ad.Shape:
    return LatchLedge()
