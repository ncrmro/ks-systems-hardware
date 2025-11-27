// GPU Configuration Right Side Panel
// Extended height for vertical GPU orientation
// Features ventilation for GPU cooling

include <../../dimensions.scad>
use <../../../util/honeycomb.scad>

module gpu_side_panel_right() {
    panel_depth = gpu_config_depth;
    panel_height = gpu_config_height;
    panel_thickness = wall_thickness;

    // Ventilation area
    vent_border = 15;
    vent_width = panel_depth - 2 * vent_border;
    vent_height = panel_height - 2 * vent_border;

    color("gray") {
        difference() {
            cube([panel_thickness, panel_depth, panel_height]);

            // Large ventilation area for GPU airflow
            translate([0, vent_border, vent_border]) {
                honeycomb_yz(honeycomb_radius, panel_thickness, vent_width, vent_height);
            }

            // Corner mounting holes
            hole_positions = [
                [panel_screw_inset, panel_screw_inset],
                [panel_depth - panel_screw_inset, panel_screw_inset],
                [panel_screw_inset, panel_height - panel_screw_inset],
                [panel_depth - panel_screw_inset, panel_height - panel_screw_inset]
            ];
            for (pos = hole_positions) {
                translate([-0.1, pos[0], pos[1]]) {
                    rotate([0, 90, 0]) {
                        cylinder(h = panel_thickness + 0.2, r = panel_screw_radius, $fn = 20);
                    }
                }
            }
        }
    }
}

// Honeycomb pattern on YZ plane
module honeycomb_yz(radius, thickness, width, height) {
    x_spacing = radius * 2.5;
    z_spacing = radius * 2.5 * sqrt(3)/2;

    cols = floor(width / x_spacing);
    rows = floor(height / z_spacing);

    for (row = [0:rows-1]) {
        for (col = [0:cols-1]) {
            y = col * x_spacing;
            z = row * z_spacing + (col % 2 == 1 ? z_spacing / 2 : 0);
            translate([thickness/2, y, z]) {
                rotate([0, 90, 0]) {
                    cylinder(h = thickness + 0.2, r = radius, $fn = 6, center=true);
                }
            }
        }
    }
}

// Preview
gpu_side_panel_right();
