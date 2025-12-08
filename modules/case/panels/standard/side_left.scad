// Left side panel for minimal/barebones configuration
// Features ventilation honeycomb and mounting holes
// Parametric: accepts depth and height for different configurations

include <../../dimensions.scad>
use <../../../util/honeycomb.scad>

module side_panel_left(
    depth = side_panel_depth,
    height = side_panel_height
) {
    // Panel dimensions (exterior, forms outer wall)
    panel_depth = depth - wall_thickness;  // Shortened 3mm from front
    panel_height = height;
    panel_thickness = wall_thickness;    // 3mm

    // Honeycomb area (leave border around edges)
    vent_border = 10;
    vent_width = panel_depth - 2 * vent_border;
    vent_height = panel_height - 2 * vent_border;

    // Lip dimensions
    lip_height = wall_thickness;      // 3mm
    lip_depth = wall_thickness;       // 3mm (protrudes into case)
    lip_inset = 6;                    // 6mm from top/bottom

    color("gray") {
        union() {
            difference() {
                cube([panel_thickness, panel_depth, panel_height]);

            // Ventilation honeycomb
            translate([0, vent_border, vent_border]) {
                honeycomb_yz(honeycomb_radius, panel_thickness, vent_width, vent_height);
            }
            }

            // Bottom lip (protrudes into case, inset 3mm from front/back)
            translate([panel_thickness, wall_thickness, lip_inset]) {
                cube([lip_depth, panel_depth - 2 * wall_thickness, lip_height]);
            }

            // Top lip (protrudes into case, inset 3mm from front/back)
            translate([panel_thickness, wall_thickness, panel_height - lip_inset - lip_height]) {
                cube([lip_depth, panel_depth - 2 * wall_thickness, lip_height]);
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
