// Front Panel with Male Dovetail
// Male dovetail rail on top edge to mate with top panel

use <../modules/dovetail.scad>

// Panel parameters (can be overridden)
panel_width = 100;        // X dimension (matches top panel width)
panel_height = 100;       // Z dimension (vertical height of front panel)
panel_thickness = 3;      // Y dimension (wall thickness)

// Dovetail parameters (must match top panel channel)
dovetail_angle = 50;
dovetail_height = 3;      // Must match top panel channel height
dovetail_length = 30;
dovetail_base_width = 8;

// Scale factor for prototyping
scale_factor = 1.0;

// Scaled dimensions
scaled_width = panel_width * scale_factor;
scaled_panel_height = panel_height * scale_factor;
scaled_thickness = panel_thickness * scale_factor;
scaled_dovetail_height = dovetail_height * scale_factor;
scaled_dovetail_length = dovetail_length * scale_factor;
scaled_dovetail_base_width = dovetail_base_width * scale_factor;

module front_panel(
    width = scaled_width,
    panel_h = scaled_panel_height,
    thickness = scaled_thickness,
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

        // Male dovetail - top flush with panel top at Z=panel_h
        // After rotate([90,0,0]), dovetail base is at Z and widens toward -Z
        // Place at Z=panel_h so top is flush, dovetail extends down to panel_h-dt_height
        translate([width/2, thickness, panel_h])
            rotate([90, 0, 0])
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
