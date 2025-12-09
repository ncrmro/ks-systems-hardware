// Front Panel with Male Dovetail
// Male dovetail rail on top edge to mate with top panel

include <../dimensions.scad>
use <../modules/male_dovetail.scad>

module front_panel(
    width = scaled_width,
    panel_h = scaled_height,
    thickness = scaled_wall_thickness,
    dt_angle = dovetail_angle,
    dt_height = scaled_dovetail_height,
    dt_length = scaled_dovetail_length,
    dt_base_width = scaled_dovetail_base_width
) {
    // Panel is vertical: width in X, thickness in Y, height in Z
    // Origin at front-bottom-left corner

    union() {
        // Base panel - stops below dovetail
        cube([width, thickness, panel_h - dt_height]);

        // Two male dovetails - each centered in one half of the panel width
        // rotate([0,0,90]) orients dovetail length along Y-axis (depth direction)
        // Y position beyond panel back allows dovetails to slot into top panel channels
        // Z position at panel_h - 2*height aligns with top panel's bottom-cut channel

        // Left dovetail - centered at 1/4 panel width
        translate([width/4, thickness + dt_length/2, panel_h - (dt_height*2)])
            male_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle
            );

        // Right dovetail - centered at 3/4 panel width
        translate([width * 3/4, thickness + dt_length/2, panel_h - (dt_height*2)])
            male_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle
            );
    }
}

// Render the panel
color("DarkGray") front_panel();
