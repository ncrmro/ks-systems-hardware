// Top Panel with Female Dovetails
// Female dovetail channels on all 4 edges, pointing inward

use <../modules/dovetail.scad>

// Panel parameters (can be overridden)
panel_width = 100;        // X dimension
panel_depth = 100;        // Y dimension
panel_thickness = 6;      // Z dimension (total panel thickness)

// Dovetail parameters
dovetail_angle = 50;
dovetail_height = 3;      // Trapezoid height (cut into bottom 3mm, leaving top 3mm solid)
dovetail_length = 30;
dovetail_base_width = 8;
clearance = 0.3;

// Scale factor for prototyping
scale_factor = 1.0;

// Scaled dimensions
scaled_width = panel_width * scale_factor;
scaled_depth = panel_depth * scale_factor;
scaled_thickness = panel_thickness * scale_factor;
scaled_dovetail_height = dovetail_height * scale_factor;
scaled_dovetail_length = dovetail_length * scale_factor;
scaled_dovetail_base_width = dovetail_base_width * scale_factor;
scaled_clearance = clearance * scale_factor;

module top_panel(
    width = scaled_width,
    depth = scaled_depth,
    thickness = scaled_thickness,
    dt_angle = dovetail_angle,
    dt_height = scaled_dovetail_height,
    dt_length = scaled_dovetail_length,
    dt_base_width = scaled_dovetail_base_width,
    dt_clearance = scaled_clearance
) {
    // Dovetail channel inset from panel edge
    dt_edge_inset = 3;  // How far from panel edge the channel center sits

    difference() {
        // Base panel
        // Origin at corner, panel extends in +X, +Y, +Z
        cube([width, depth, thickness]);

        // Female dovetail on front edge (Y=0)
        // Channel at front edge to mate with front panel's dovetail
        // (Front panel sits in front of top panel in assembly)
        translate([width/2, 0, 0])
            rotate([0, 0, 0])    // No rotation needed - channel opens upward (+Z)
            rotate([90, 0, 0])   // Rotate so length runs along X axis
            female_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle,
                clearance = dt_clearance
            );

        // Female dovetail on back edge (Y=depth)
        // Channel centered on X, inset from Y=depth edge
        translate([width/2, depth - dt_edge_inset, 0])
            rotate([0, 0, 0])
            rotate([90, 0, 0])
            female_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle,
                clearance = dt_clearance
            );

        // Female dovetail on left edge (X=0)
        // Channel centered on Y, inset from X=0 edge
        translate([dt_edge_inset, depth/2, 0])
            rotate([0, 0, 0])
            rotate([90, 0, 90])  // Rotate so length runs along Y axis
            female_dovetail(
                length = dt_length,
                height = dt_height,
                base_width = dt_base_width,
                angle = dt_angle,
                clearance = dt_clearance
            );

        // Female dovetail on right edge (X=width)
        // Channel centered on Y, inset from X=width edge
        translate([width - dt_edge_inset, depth/2, 0])
            rotate([0, 0, 0])
            rotate([90, 0, 90])
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
