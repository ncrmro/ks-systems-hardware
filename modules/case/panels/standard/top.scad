// Top panel for minimal/barebones configuration
// Features ventilation honeycomb over CPU cooler area
// Parametric: accepts width and depth for different configurations

include <../../dimensions_minimal.scad>
use <../../../util/honeycomb.scad>

module top_panel(
    width = exterior_panel_width,
    depth = exterior_panel_depth,         // 173mm - extends to cover back panel
    vent_x_offset_extra = wall_thickness  // Offset vent to center over motherboard
) {
    // Panel dimensions (interior, fits between side walls)
    panel_width = width;
    panel_depth = depth;
    panel_thickness = wall_thickness;      // 3mm

    // Ventilation area over CPU cooler
    // Cooler is roughly centered on motherboard
    vent_border = 10;
    vent_width = mobo_width - 2 * vent_border;      // Vent over motherboard area only
    vent_depth = mobo_depth - 2 * vent_border;
    vent_x_offset = vent_border + vent_x_offset_extra;  // Offset to center over motherboard
    vent_y_offset = vent_border;

    color("gray") {
        difference() {
            cube([panel_width, panel_depth, panel_thickness]);

            // Ventilation honeycomb over motherboard/CPU area
            translate([vent_x_offset, vent_y_offset, 0]) {
                honeycomb_xy(honeycomb_radius, panel_thickness, vent_width, vent_depth);
            }

            // Corner mounting holes
            corner_offset = panel_screw_inset;
            hole_positions = [
                [corner_offset, corner_offset],
                [panel_width - corner_offset, corner_offset],
                [corner_offset, panel_depth - corner_offset],
                [panel_width - corner_offset, panel_depth - corner_offset],
                // Additional holes at motherboard/PSU boundary
                [mobo_width + wall_thickness, corner_offset],
                [mobo_width + wall_thickness, panel_depth - corner_offset]
            ];

            for (pos = hole_positions) {
                translate([pos[0], pos[1], -0.1]) {
                    cylinder(h = panel_thickness + 0.2, r = panel_screw_radius, $fn = 20);
                }
            }
        }
    }
}

// Honeycomb pattern on XY plane (for top/bottom panels)
module honeycomb_xy(radius, thickness, width, depth) {
    x_spacing = radius * 2.5;
    y_spacing = radius * 2.5 * sqrt(3)/2;

    cols = floor(width / x_spacing);
    rows = floor(depth / y_spacing);

    actual_width = cols * x_spacing;
    actual_depth = rows * y_spacing;

    x_offset = (width - actual_width) / 2;
    y_offset = (depth - actual_depth) / 2;

    translate([x_offset, y_offset, 0]) {
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
}

// Preview
top_panel();
