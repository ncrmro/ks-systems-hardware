import anchorscad as ad
from anchorscad import datatree
from dataclasses import field
import math
from typing import Literal

# Define DovetailDimensions based on dimensions.scad
@datatree
class DovetailDimensions:
    dovetail_angle: float = 15.0
    dovetail_height: float = 3.0
    dovetail_length: float = 20.0
    dovetail_base_width: float = 8.0
    dovetail_clearance: float = 0.15
    dovetail_boss_margin: float = 3.0
    catch_bump_height: float = 0.8
    catch_bump_length: float = 3.0
    catch_ramp_length: float = 2.0
    window_clearance: float = 0.10
    center_slot_width: float = 3.0
    center_slot_end_margin: float = 6.0

    # Scaled dimensions (assuming scale factor 1.0 for now)
    @property
    def scaled_dovetail_height(self) -> float: return self.dovetail_height
    @property
    def scaled_dovetail_length(self) -> float: return self.dovetail_length
    @property
    def scaled_dovetail_base_width(self) -> float: return self.dovetail_base_width
    @property
    def scaled_clearance(self) -> float: return self.dovetail_clearance
    @property
    def scaled_boss_margin(self) -> float: return self.dovetail_boss_margin
    @property
    def scaled_catch_height(self) -> float: return self.catch_bump_height
    @property
    def scaled_catch_length(self) -> float: return self.catch_bump_length
    @property
    def scaled_catch_ramp_length(self) -> float: return self.catch_ramp_length
    @property
    def scaled_window_clearance(self) -> float: return self.window_clearance
    @property
    def scaled_slot_width(self) -> float: return self.center_slot_width
    @property
    def scaled_slot_end_margin(self) -> float: return self.center_slot_end_margin

@ad.shape
@datatree
class FemaleDovetail(ad.CompositeShape):
    """
    Female Dovetail with Integrated Boss and Inner Catch Recesses.
    Corresponds to modules/util/dovetail/female_dovetail.scad
    Origin at center of boss top surface (where it attaches to panel)
    Boss extends in +Z direction, channel opens toward +Z.
    """
    dim: DovetailDimensions = field(default_factory=DovetailDimensions)
    with_catch_windows: bool = True
    
    # Orientation of the dovetail boss relative to the panel.
    # Defines which way the channel *opens*.
    # +Y: Channel opens towards positive Y axis.
    # -Y: Channel opens towards negative Y axis.
    # +X: Channel opens towards positive X axis.
    # -X: Channel opens towards negative X axis.
    channel_direction: Literal["+Y", "-Y", "+X", "-X"] = "+Y"

    def build(self) -> ad.Maker:
        dd = self.dim

        # Simple Rectangular Dovetail
        dovetail_width = dd.scaled_dovetail_base_width + 2 * dd.scaled_clearance
        dovetail_length = dd.scaled_dovetail_length + 2 * dd.scaled_clearance
        dovetail_height = dd.scaled_dovetail_height

        boss_width = dovetail_width + 2 * dd.scaled_boss_margin
        boss_depth = dovetail_length + 2 * dd.scaled_boss_margin
        boss_height = dovetail_height

        # Boss (Solid) - Centered at Part Origin
        base_maker = ad.Box([boss_width, boss_depth, boss_height]).solid("boss").at("centre")

        # Channel (Hole) - Centered at Part Origin
        # Slightly taller to ensure clean cut
        channel_maker = ad.Box([dovetail_width, dovetail_length, boss_height + 0.02]).hole("channel_cut").at("centre")
        
        # Combine: Add hole to solid
        base_maker.add_at(channel_maker)

        return base_maker

@ad.shape
@datatree
class MaleDovetail(ad.CompositeShape):
    """
    Male Dovetail Rail with Center-Slot Snap-Fit Latch.
    Corresponds to modules/util/dovetail/male_dovetail.scad
    Origin at center of the rail base (XY plane), extends in +Z direction.
    """
    dim: DovetailDimensions = field(default_factory=DovetailDimensions)
    with_latch: bool = True
    
    # Orientation of the dovetail boss relative to the panel.
    # Defines which way the channel *opens*.
    # +Y: Channel opens towards positive Y axis.
    # -Y: Channel opens towards negative Y axis.
    # +X: Channel opens towards positive X axis.
    # -X: Channel opens towards negative X axis.
    # Note: internal geometry assumes length along Y, height along Z, width along X
    # then a final transform is applied.
    dovetail_orientation: Literal["along_X", "along_Y"] = "along_Y"

    def build(self) -> ad.Maker:
        dd = self.dim

        # Simple Rectangular Dovetail Rail (Placeholder)
        # Dimensions (Matching Female)
        base_width = dd.scaled_dovetail_base_width # Use base width as the "tab" width
        length = dd.scaled_dovetail_length
        height = dd.scaled_dovetail_height

        # Main Rail (Solid) - Centered at Part Origin
        main_rail = ad.Box([base_width, length, height]).solid("main_rail").at("centre")

        # Center slot (subtract)
        if self.with_latch:
            slot_width = dd.scaled_slot_width
            slot_end_margin = dd.scaled_slot_end_margin
            slot_length = length - slot_end_margin
            
            # Slot geometry
            # To offset it, we use add_at with post=translate.
            # Slot center needs to be calculated.
            # Rail is centered at 0,0,0.
            # Slot length along Y.
            # Slot starts at -length/2 + slot_end_margin.
            # Slot center Y = start + slot_length/2.
            slot_cy = -length/2 + slot_end_margin + slot_length/2
            
            slot_maker = ad.Box([slot_width, slot_length, height + 0.2]).hole("center_slot").at("centre")
            
            main_rail.add_at(
                slot_maker,
                post=ad.translate([0, slot_cy, 0])
            )

        return main_rail

# End of src/parts/dovetail.py
