// Left side panel for minimal/barebones configuration
// Features ventilation honeycomb and mounting holes

include <../../dimensions.scad>
use <../../../util/honeycomb.scad>

module side_panel_left() {
    // Panel dimensions (exterior, forms outer wall)
    panel_depth = side_panel_depth;      // 176mm
    panel_height = side_panel_height;    // ~100mm
    panel_thickness = wall_thickness;    // 3mm

    // Honeycomb area (leave border around edges)
    vent_border = 10;
    vent_width = panel_depth - 2 * vent_border;
    vent_height = panel_height - 2 * vent_border;

    color("gray") {
        difference() {
            cube([panel_thickness, panel_depth, panel_height]);

            // Ventilation honeycomb
            translate([0, vent_border, vent_border]) {
                honeycomb_yz(honeycomb_radius, panel_thickness, vent_width, vent_height);
            }

            // Corner mounting holes
            corner_offset = panel_screw_inset;
            hole_positions = [
                [corner_offset, corner_offset],
                [panel_depth - corner_offset, corner_offset],
                [corner_offset, panel_height - corner_offset],
                [panel_depth - corner_offset, panel_height - corner_offset]
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

// Honeycomb pattern on YZ plane (for side panels)
module honeycomb_yz(radius, thickness, width, height) {
    x_spacing = radius * 2.5;
    z_spacing = radius * 2.5 * sqrt(3)/2;

    cols = floor(width / x_spacing);
    rows = floor(height / z_spacing);

    actual_width = cols * x_spacing;
    actual_height = rows * z_spacing;

    y_offset = (width - actual_width) / 2;
    z_offset = (height - actual_height) / 2;

    translate([0, y_offset, z_offset]) {
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
}

// Preview
side_panel_left();
