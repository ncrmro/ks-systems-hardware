// Front panel for minimal/barebones configuration
// Features power button hole and optional LED/USB cutouts

include <../../dimensions.scad>

module front_panel() {
    // Panel dimensions (extended 3mm each side to cover side panel gap)
    panel_width = front_back_panel_width + 2 * wall_thickness;  // ~226mm (+6mm)
    panel_height = front_back_panel_height;  // ~94mm
    panel_thickness = wall_thickness;        // 3mm

    // Power button (typical 12mm momentary switch)
    power_btn_diameter = 12;
    power_btn_x = 30;  // Left side of panel
    power_btn_z = panel_height / 2;

    // Power LED hole
    power_led_diameter = 3;
    power_led_x = power_btn_x + 20;
    power_led_z = power_btn_z;

    // HDD activity LED hole
    hdd_led_diameter = 3;
    hdd_led_x = power_led_x + 10;
    hdd_led_z = power_btn_z;

    // Extended panel height (raised 3mm)
    extended_panel_height = panel_height + wall_thickness;  // +3mm

    // Raised lip dimensions
    lip_height = wall_thickness;      // 3mm
    lip_depth = wall_thickness;       // 3mm (protrudes into case)
    lip_z_offset = wall_thickness;    // 3mm from bottom

    color("gray") {
        union() {
            difference() {
                cube([panel_width, panel_thickness, extended_panel_height]);

            // Power button hole
            translate([power_btn_x, -0.1, power_btn_z]) {
                rotate([-90, 0, 0]) {
                    cylinder(h = panel_thickness + 0.2, d = power_btn_diameter, $fn = 30);
                }
            }

            // Power LED hole
            translate([power_led_x, -0.1, power_led_z]) {
                rotate([-90, 0, 0]) {
                    cylinder(h = panel_thickness + 0.2, d = power_led_diameter, $fn = 20);
                }
            }

            // HDD activity LED hole
            translate([hdd_led_x, -0.1, hdd_led_z]) {
                rotate([-90, 0, 0]) {
                    cylinder(h = panel_thickness + 0.2, d = hdd_led_diameter, $fn = 20);
                }
            }

            // Corner mounting holes
            corner_offset = panel_screw_inset;
            hole_positions = [
                [corner_offset, corner_offset],
                [panel_width - corner_offset, corner_offset],
                [corner_offset, extended_panel_height - corner_offset],
                [panel_width - corner_offset, extended_panel_height - corner_offset]
            ];

            for (pos = hole_positions) {
                translate([pos[0], -0.1, pos[1]]) {
                    rotate([-90, 0, 0]) {
                        cylinder(h = panel_thickness + 0.2, r = panel_screw_radius, $fn = 20);
                    }
                }
            }
            }

            // Bottom lip (protrudes backward into case, inset 3mm from sides)
            translate([wall_thickness, panel_thickness, lip_z_offset]) {
                cube([panel_width - 2 * wall_thickness, lip_depth, lip_height]);
            }

            // Top lip (protrudes backward into case, inset 3mm from sides)
            translate([wall_thickness, panel_thickness, panel_height - 6]) {
                cube([panel_width - 2 * wall_thickness, lip_depth, lip_height]);
            }
        }
    }
}

// Preview
front_panel();
