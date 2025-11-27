// Bottom panel for minimal/barebones configuration
// Features feet mounts and optional NAS expansion connector points

include <../../dimensions.scad>
use <top.scad>  // For honeycomb_xy module

module bottom_panel() {
    // Panel dimensions (full width including PSU area)
    panel_width = minimal_with_psu_width;            // ~258mm
    panel_depth = mobo_depth + 2 * wall_thickness;  // 176mm
    panel_thickness = wall_thickness;                // 3mm

    // Feet dimensions
    foot_diameter = 15;
    foot_height = 8;
    foot_inset = 15;  // Distance from edge

    // Ventilation area (smaller than top, for bottom intake)
    vent_border = 20;
    vent_width = mobo_width - 2 * vent_border;
    vent_depth = mobo_depth - 2 * vent_border;
    vent_x_offset = wall_thickness + vent_border;
    vent_y_offset = wall_thickness + vent_border;

    // NAS expansion connector holes (for future stacking)
    nas_connector_positions = [
        [wall_thickness + 20, wall_thickness + 20],
        [wall_thickness + mobo_width - 20, wall_thickness + 20],
        [wall_thickness + 20, wall_thickness + mobo_depth - 20],
        [wall_thickness + mobo_width - 20, wall_thickness + mobo_depth - 20]
    ];

    union() {
        // Main panel
        color("gray") {
            difference() {
                cube([panel_width, panel_depth, panel_thickness]);

                // Ventilation honeycomb (less dense than top)
                translate([vent_x_offset, vent_y_offset, 0]) {
                    honeycomb_xy(honeycomb_radius + 1, panel_thickness, vent_width, vent_depth);
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

                // NAS expansion connector holes
                for (pos = nas_connector_positions) {
                    translate([pos[0], pos[1], -0.1]) {
                        cylinder(h = panel_thickness + 0.2, r = 2.5, $fn = 20);  // M5 clearance
                    }
                }
            }
        }

        // Feet (rubber bumper mounts)
        color("darkgray") {
            foot_positions = [
                [foot_inset, foot_inset],
                [panel_width - foot_inset, foot_inset],
                [foot_inset, panel_depth - foot_inset],
                [panel_width - foot_inset, panel_depth - foot_inset]
            ];

            for (pos = foot_positions) {
                translate([pos[0], pos[1], -foot_height]) {
                    cylinder(h = foot_height, d = foot_diameter, $fn = 30);
                }
            }
        }
    }
}

// Preview
bottom_panel();
