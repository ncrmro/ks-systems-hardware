// Right side panel for minimal/barebones configuration
// Mirror of left panel - features ventilation honeycomb and mounting holes
// Parametric: passes parameters through to side_panel_left

include <../../dimensions.scad>
use <side_left.scad>

module side_panel_right(
    depth = side_panel_depth,
    height = side_panel_height
) {
    // Right panel mirrors the left panel with 180° rotation around Y axis
    // Rotation inverts X and Z, so translate to correct position
    translate([wall_thickness, 0, height]) {
        rotate([0, 180, 0]) {
            side_panel_left(depth = depth, height = height);
        }
    }
}

// Preview
side_panel_right();
