import anchorscad as ad
from anchorscad import datatree
from dataclasses import field
from registry import register_part


@datatree
class DovetailDimensions:
    """Thickened dovetail dimensions for structural back-panel connection."""
    dovetail_angle: float = 15.0
    dovetail_height: float = 5.0       # was 3.0 - deeper engagement
    dovetail_length: float = 25.0      # was 20.0 - longer rail
    dovetail_base_width: float = 12.0  # was 8.0 - wider contact
    dovetail_clearance: float = 0.15
    dovetail_boss_margin: float = 4.0  # was 3.0 - more wall
    catch_bump_height: float = 1.2     # was 0.8 - stronger catch
    catch_bump_length: float = 4.0     # was 3.0
    catch_ramp_length: float = 2.5     # was 2.0
    center_slot_width: float = 4.0     # was 3.0 - proportional
    center_slot_end_margin: float = 8.0  # was 6.0


@ad.shape
@datatree
class FemaleDovetail(ad.CompositeShape):
    """
    Female dovetail with integrated boss and channel recess.
    Origin at center of boss top surface.
    Boss extends in +Z direction, channel opens along specified axis.
    """
    dim: DovetailDimensions = field(default_factory=DovetailDimensions)

    def build(self) -> ad.Maker:
        dd = self.dim

        dovetail_width = dd.dovetail_base_width + 2 * dd.dovetail_clearance
        dovetail_length = dd.dovetail_length + 2 * dd.dovetail_clearance
        dovetail_height = dd.dovetail_height

        boss_width = dovetail_width + 2 * dd.dovetail_boss_margin
        boss_depth = dovetail_length + 2 * dd.dovetail_boss_margin
        boss_height = dovetail_height

        # Boss (solid)
        boss = ad.Box([boss_width, boss_depth, boss_height])
        shape = boss.solid("boss").colour("dimgray").at("centre")

        # Channel (hole) - open on +Y side (toward mating back panel)
        # The +Y face of the channel is flush with the +Y face of the boss,
        # allowing the male rail to slide in from the back (+Y direction).
        # Solid wall on -Y side retains the rail once seated.
        channel = ad.Box([dovetail_width, dovetail_length + dd.dovetail_boss_margin, boss_height + 0.02])
        shape.add_at(
            channel.hole("channel_cut").at("centre"),
            post=ad.translate([0, dd.dovetail_boss_margin / 2, 0])
        )

        return shape


@ad.shape
@datatree
class MaleDovetail(ad.CompositeShape):
    """
    Male dovetail rail with center-slot snap-fit.
    Origin at center of rail base (XY plane), extends in +Z direction.
    """
    dim: DovetailDimensions = field(default_factory=DovetailDimensions)
    with_latch: bool = True

    def build(self) -> ad.Maker:
        dd = self.dim

        base_width = dd.dovetail_base_width
        length = dd.dovetail_length
        height = dd.dovetail_height

        # Main rail
        rail = ad.Box([base_width, length, height])
        shape = rail.solid("main_rail").colour("dimgray").at("centre")

        # Center slot for flex retention
        if self.with_latch:
            slot_width = dd.center_slot_width
            slot_end_margin = dd.center_slot_end_margin
            slot_length = length - slot_end_margin

            slot_cy = -length / 2 + slot_end_margin + slot_length / 2

            slot = ad.Box([slot_width, slot_length, height + 0.2])
            shape.add_at(
                slot.hole("center_slot").at("centre"),
                post=ad.translate([0, slot_cy, 0])
            )

        return shape


@register_part("dovetail_female", part_type="component")
def create_dovetail_female() -> ad.Shape:
    return FemaleDovetail()


@register_part("dovetail_male", part_type="component")
def create_dovetail_male() -> ad.Shape:
    return MaleDovetail()
