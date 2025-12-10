// Female Dovetail with Integrated Boss and Inner Catch Recesses
// Creates a rectangular boss with trapezoidal channel cut into it
// Catch recesses in INNER channel walls for snap-fit latch
// Uses hull() approach for intuitive geometry definition

include <../dimensions.scad>

function dovetail_top_width(base_width, height, angle) =
    base_width + 2 * height * tan(angle);

// Female dovetail - boss with channel cut into it
// Origin at center of boss top surface (where it attaches to panel)
// Boss extends in -Z direction, channel opens toward -Z
//
// The hull() approach connects two rectangles at different Z positions:
// - Narrow rectangle at Z=0 (panel surface, where male locks in)
// - Wide rectangle at Z=-height (entry point for male dovetail)
//
module female_dovetail(
    length = scaled_dovetail_length,
    height = scaled_dovetail_height,
    base_width = scaled_dovetail_base_width,
    angle = dovetail_angle,
    clearance = scaled_clearance,
    margin = scaled_boss_margin,
    // Catch recess parameters
    with_catch_windows = true,
    catch_height = scaled_catch_height,
    catch_length = scaled_catch_length,
    ramp_length = scaled_catch_ramp_length,
    window_clearance = scaled_window_clearance
) {
    // Channel dimensions with clearance
    narrow_width = base_width + 2 * clearance;      // at Z=0 (top)
    wide_width = dovetail_top_width(narrow_width, height + clearance, angle);  // at Z=-height (bottom)
    channel_length = length + 2 * clearance;

    // Boss dimensions
    boss_width = wide_width + 2 * margin;
    boss_depth = channel_length + margin;
    boss_height = height;

    // Recess dimensions (sized for catch bump + clearance)
    recess_depth = catch_height + window_clearance;  // How far into wall at plateau

    // Y positions for ramped recess sections (matching male catch)
    // Male catch positioned so exit ramp ends at length/2
    recess_y_start = length/2 - 2 * ramp_length - catch_length;

    // Section boundaries
    entry_ramp_end = recess_y_start + ramp_length;
    plateau_end = entry_ramp_end + catch_length;
    exit_ramp_end = plateau_end + ramp_length;  // = length/2

    rotate([0, 180, 0])
    difference() {
        // Rectangular boss extending in -Z
        translate([-boss_width/2, -channel_length/2, -boss_height])
            cube([boss_width, boss_depth, boss_height]);

        // Channel + recesses as single union (same coordinate system)
        union() {
            // Trapezoidal channel via hull of two thin cubes
            hull() {
                // Narrow rectangle at top (Z=0), extends slightly above for clean cut
                translate([0, 0, clearance])
                    cube([narrow_width, channel_length, 0.01], center=true);

                // Wide rectangle at bottom (Z=-height)
                translate([0, 0, -height - clearance])
                    cube([wide_width, channel_length, 0.01], center=true);
            }

            // Inner channel recesses - ramped to match male catch profile
            if (with_catch_windows) {
                // Left recess (negative X side)
                // Entry ramp (0 → full depth)
                hull() {
                    // Start of ramp - at channel wall
                    translate([-narrow_width/2 - 0.01, recess_y_start, -height - clearance])
                        cube([0.02, 0.01, height + 2*clearance]);
                    // End of ramp - at full depth
                    translate([-narrow_width/2 - recess_depth, entry_ramp_end, -height - clearance])
                        cube([recess_depth, 0.01, height + 2*clearance]);
                }
                // Plateau (full depth)
                translate([-narrow_width/2 - recess_depth, entry_ramp_end, -height - clearance])
                    cube([recess_depth, catch_length, height + 2*clearance]);
                // Exit ramp (full depth → 0)
                hull() {
                    // Start of exit ramp - at full depth
                    translate([-narrow_width/2 - recess_depth, plateau_end, -height - clearance])
                        cube([recess_depth, 0.01, height + 2*clearance]);
                    // End of exit ramp - at channel wall
                    translate([-narrow_width/2 - 0.01, exit_ramp_end, -height - clearance])
                        cube([0.02, 0.01, height + 2*clearance]);
                }

                // Right recess (positive X side) - mirror of left
                // Entry ramp (0 → full depth)
                hull() {
                    translate([narrow_width/2 - 0.01, recess_y_start, -height - clearance])
                        cube([0.02, 0.01, height + 2*clearance]);
                    translate([narrow_width/2, entry_ramp_end, -height - clearance])
                        cube([recess_depth, 0.01, height + 2*clearance]);
                }
                // Plateau (full depth)
                translate([narrow_width/2, entry_ramp_end, -height - clearance])
                    cube([recess_depth, catch_length, height + 2*clearance]);
                // Exit ramp (full depth → 0)
                hull() {
                    translate([narrow_width/2, plateau_end, -height - clearance])
                        cube([recess_depth, 0.01, height + 2*clearance]);
                    translate([narrow_width/2 - 0.01, exit_ramp_end, -height - clearance])
                        cube([0.02, 0.01, height + 2*clearance]);
                }
            }
        }
    }
}

// Test visualization
color("gray") female_dovetail();
