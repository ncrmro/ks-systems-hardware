// Male Dovetail Rail with Center-Slot Snap-Fit Latch
// Integrated design: slot through center allows squeeze-to-insert/release
// Ramped catch bumps on outer faces snap into female windows
// Per SPEC.md Section 9.4

include <dimensions.scad>

// Calculate top width from base width, height, and angle
function dovetail_top_width(base_width, height, angle) =
    base_width + 2 * height * tan(angle);

// Symmetric ramped catch bump module
// Creates a catch with ramps on both entry and exit sides (easy in, easy out)
// Origin at base of entry ramp, extends in +Y direction, bump protrudes in X direction
module ramped_catch(
    bump_height = scaled_catch_height,
    ramp_length = scaled_catch_ramp_length,
    catch_length = scaled_catch_length,
    thickness = scaled_dovetail_height,
    direction = 1  // 1 for +X, -1 for -X
) {
    bump_x = direction > 0 ? 0 : -bump_height;

    union() {
        // Entry ramp (front) - hull between flat start and raised peak
        hull() {
            cube([0.01, ramp_length, thickness]);
            translate([bump_x, ramp_length, 0])
                cube([bump_height, 0.01, thickness]);
        }

        // Catch plateau (middle)
        translate([bump_x, ramp_length, 0])
            cube([bump_height, catch_length, thickness]);

        // Exit ramp (back) - mirror of entry ramp
        hull() {
            translate([bump_x, ramp_length + catch_length, 0])
                cube([bump_height, 0.01, thickness]);
            translate([0, ramp_length + catch_length + ramp_length, 0])
                cube([0.01, 0.01, thickness]);
        }
    }
}

// Male dovetail rail with integrated center-slot latch
// Origin at center of the rail base
// Cross-section in YZ plane: width in Y, height in +Z
// Extrudes along +X (length direction)
module male_dovetail(
    length = scaled_dovetail_length,
    height = scaled_dovetail_height,
    base_width = scaled_dovetail_base_width,
    angle = dovetail_angle,
    // Center slot parameters
    with_latch = true,
    slot_width = scaled_slot_width,
    slot_end_margin = scaled_slot_end_margin,
    // Catch parameters
    catch_height = scaled_catch_height,
    catch_length = scaled_catch_length,
    ramp_length = scaled_catch_ramp_length
) {
    top_width = dovetail_top_width(base_width, height, angle);
    slot_length = length - slot_end_margin;  // Only base margin, extends to free end

    // Calculate catch Y position - symmetric catch at the very end of dovetail
    // Total catch = entry ramp + plateau + exit ramp = 2*ramp_length + catch_length
    catch_y = length/2 - catch_length - 2 * ramp_length;

    union() {
        difference() {
            // Main trapezoidal rail
            rotate([-90, 180, 0])
            linear_extrude(height = length, center = true)
                polygon([
                    [-base_width/2, 0],      // bottom left
                    [base_width/2, 0],       // bottom right
                    [top_width/2, height],   // top right
                    [-top_width/2, height]   // top left
                ]);

            // Center slot (subtract) - creates two flex halves
            // Slot extends from base margin to free end (open at free end for flex)
            if (with_latch) {
                translate([-slot_width/2, -length/2 + slot_end_margin, -0.01])
                    cube([slot_width, slot_length, height + 0.02]);
            }
        }

        // Symmetric ramped catch bumps on outer faces (if latch enabled)
        // Rotated to match the dovetail's tapered angle
        if (with_latch) {
            // Left catch - rotate to match slope, position at base_width edge
            translate([-base_width/2, catch_y, 0])
                rotate([0, -angle, 0])
                    ramped_catch(
                        bump_height = catch_height,
                        ramp_length = ramp_length,
                        catch_length = catch_length,
                        thickness = height,
                        direction = -1
                    );

            // Right catch - rotate to match slope, position at base_width edge
            translate([base_width/2, catch_y, 0])
                rotate([0, angle, 0])
                    ramped_catch(
                        bump_height = catch_height,
                        ramp_length = ramp_length,
                        catch_length = catch_length,
                        thickness = height,
                        direction = 1
                    );
        }
    }
}
