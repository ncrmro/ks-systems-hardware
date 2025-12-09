// Top Panel with Female Dovetails (Boss-Based Design)
// Two female dovetail channels on front edge to mate with front panel
// Uses female_dovetail_boss module for raised boss sections

include <../dimensions.scad>
use <../modules/female_dovetail.scad>

module top_panel(
    width = scaled_width,
    depth = scaled_depth,
    thickness = scaled_top_thickness,
    dt_angle = dovetail_angle,
    dt_height = scaled_dovetail_height,
    dt_length = scaled_dovetail_length,
    dt_base_width = scaled_dovetail_base_width,
    dt_clearance = scaled_clearance,
    boss_margin = scaled_boss_margin
) {
    union() {
        // Base panel (standard thickness)
        // Raised by dovetail height so dovetails hang underneath
        // Origin at corner, panel extends in +X, +Y, +Z
        translate([0, 0, dt_height])
            cube([width, depth, thickness]);

        // Left female dovetail at 1/4 width
        // Position at front edge (Y offset for dovetail center)
        translate([width/4, dt_length/2 + dt_clearance, 0])
            female_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle,
                clearance = dt_clearance,
                margin = boss_margin
            );

        // Right female dovetail at 3/4 width
        translate([width*3/4, dt_length/2 + dt_clearance, 0])
            female_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle,
                clearance = dt_clearance,
                margin = boss_margin
            );
    }
}

// Render the panel
color("LightGray") top_panel();
