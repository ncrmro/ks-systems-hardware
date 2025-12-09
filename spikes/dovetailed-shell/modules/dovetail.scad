// Dovetail Joint Primitives
// Re-exports all dovetail modules for convenience

include <../dimensions.scad>
use <male_dovetail.scad>
use <female_dovetail.scad>

// Calculate top width from base width, height, and angle
function dovetail_top_width(base_width, height, angle) =
    base_width + 2 * height * tan(angle);

// Test visualization - shows both male and female
module dovetail_test() {
    // Female dovetail with boss (gray)
    color("gray") female_dovetail();

    // Male dovetail positioned to slot in (red, transparent)
    color("red", 0.5) translate([0, 0, -scaled_dovetail_height])
        male_dovetail();
}

dovetail_test();
