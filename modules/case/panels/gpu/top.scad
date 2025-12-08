// GPU Configuration Top Panel
// PSU mounts above motherboard in this config
// Features ventilation

include <../../dimensions_minimal.scad>
use <../../../util/honeycomb.scad>

module gpu_top_panel() {
    panel_width = gpu_config_width;
    panel_depth = gpu_config_depth;
    panel_thickness = wall_thickness;

    // Ventilation area
    vent_border = 15;
    vent_width = panel_width - 2 * vent_border;
    vent_depth = panel_depth - 2 * vent_border;

    color("gray") {
        difference() {
            cube([panel_width, panel_depth, panel_thickness]);

            // Ventilation honeycomb
            translate([vent_border, vent_border, 0]) {
                honeycomb_xy(honeycomb_radius, panel_thickness, vent_width, vent_depth);
            }

            // Corner mounting holes
            hole_positions = [
                [panel_screw_inset, panel_screw_inset],
                [panel_width - panel_screw_inset, panel_screw_inset],
                [panel_screw_inset, panel_depth - panel_screw_inset],
                [panel_width - panel_screw_inset, panel_depth - panel_screw_inset]
            ];
            for (pos = hole_positions) {
                translate([pos[0], pos[1], -0.1]) {
                    cylinder(h = panel_thickness + 0.2, r = panel_screw_radius, $fn = 20);
                }
            }
        }
    }
}

// Honeycomb pattern on XY plane
module honeycomb_xy(radius, thickness, width, depth) {
    x_spacing = radius * 2.5;
    y_spacing = radius * 2.5 * sqrt(3)/2;

    cols = floor(width / x_spacing);
    rows = floor(depth / y_spacing);

    for (row = [0:rows-1]) {
        for (col = [0:cols-1]) {
            x = col * x_spacing;
            y = row * y_spacing + (col % 2 == 1 ? y_spacing / 2 : 0);
            translate([x, y, thickness/2]) {
                cylinder(h = thickness + 0.2, r = radius, $fn = 6, center=true);
            }
        }
    }
}

// Preview
gpu_top_panel();
