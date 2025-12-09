// Female Dovetail with Integrated Boss
// Creates a rectangular boss with trapezoidal channel cut into it
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
    margin = scaled_boss_margin
) {
    // Channel dimensions with clearance
    narrow_width = base_width + 2 * clearance;      // at Z=0 (top)
    wide_width = dovetail_top_width(narrow_width, height + clearance, angle);  // at Z=-height (bottom)
    channel_length = length + 2 * clearance;

    // Boss dimensions
    boss_width = wide_width + 2 * margin;
    boss_depth = channel_length + margin;
    boss_height = height;

    rotate([0, 180, 0])
    difference() {
        // Rectangular boss extending in -Z
        translate([-boss_width/2, -channel_length/2, -boss_height])
            cube([boss_width, boss_depth, boss_height]);

        // Trapezoidal channel via hull of two thin cubes
        hull() {
            // Narrow rectangle at top (Z=0), extends slightly above for clean cut
            translate([0, 0, clearance])
                cube([narrow_width, channel_length, 0.01], center=true);

            // Wide rectangle at bottom (Z=-height)
            translate([0, 0, -height - clearance])
                cube([wide_width, channel_length, 0.01], center=true);
        }
    }
}

// Test visualization
color("gray") female_dovetail();
