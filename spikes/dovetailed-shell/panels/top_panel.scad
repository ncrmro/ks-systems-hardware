// Top Panel with Female Dovetails
// Two female dovetail channels on front edge to mate with front panel

include <../dimensions.scad>
use <../modules/dovetail.scad>

module top_panel(
    width = scaled_width,
    depth = scaled_depth,
    thickness = scaled_top_thickness,
    dt_angle = dovetail_angle,
    dt_height = scaled_dovetail_height,
    dt_length = scaled_dovetail_length,
    dt_base_width = scaled_dovetail_base_width,
    dt_clearance = scaled_clearance
) {
    difference() {
        // Base panel
        // Origin at corner, panel extends in +X, +Y, +Z
        cube([width, depth, thickness]);

        // Left female dovetail on front edge (Y=0) at 1/4 width
        // Matches front panel's left male dovetail position
        translate([width/4, 0, 0])
            rotate([0, 0, 0])
            female_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle,
                clearance = dt_clearance
            );

        // Right female dovetail on front edge (Y=0) at 3/4 width
        // Matches front panel's right male dovetail position
        translate([width * 3/4, 0, 0])
            rotate([0, 0, 0])
            female_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle,
                clearance = dt_clearance
            );
    }
}

// Render the panel
color("LightGray") top_panel();
