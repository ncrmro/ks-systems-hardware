// Front panel for Pico configuration
// Features power button hole and optional LED cutouts
//
// DOVETAIL JOINTS (Top Shell Assembly):
// - Male clip dovetails on top edge connect to top panel female clips (internal)
// - Male clip dovetails on left/right edges connect to side panels (internal)
// - Per SPEC.md Section 9.6
//
// Standalone file for 3D printing - uses pico dimensions

include <../../dimensions_pico.scad>
include <../../../util/dovetail/dimensions.scad>
use <../../../util/dovetail/male_dovetail.scad>

module front_panel_pico(
    width = front_back_panel_width + 2 * wall_thickness,  // Extended width to cover side panel edges
    height = front_back_panel_height,                      // ~63mm (full height)
    with_dovetails = true
) {
    // Panel dimensions
    panel_width = width;
    panel_height = height;
    panel_thickness = wall_thickness;        // 3mm

    // Power button (typical 12mm momentary switch)
    power_btn_diameter = 12;
    power_btn_x = 30;
    power_btn_z = panel_height / 2;

    // Power LED hole
    power_led_diameter = 3;
    power_led_x = power_btn_x + 20;
    power_led_z = power_btn_z;

    // HDD activity LED hole
    hdd_led_diameter = 3;
    hdd_led_x = power_led_x + 10;
    hdd_led_z = power_btn_z;

    // Raised lip dimensions
    lip_height = wall_thickness;
    lip_depth = wall_thickness;
    lip_z_offset = wall_thickness;

    // Dovetail positions on top edge (clip - connects to top panel)
    // Adjusted X positions to account for extended panel width
    top_dovetail_positions = [width * 0.25, width * 0.75];

    // Side edge dovetail positions (connects to side panels)
    // Single dovetail centered on each side edge
    side_dovetail_z = panel_height / 2;

    union() {
        color("gray") {
            difference() {
                cube([panel_width, panel_thickness, panel_height]);

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
            }

            // Bottom lip (protrudes backward into case)
            translate([wall_thickness, panel_thickness, lip_z_offset]) {
                cube([panel_width - 2 * wall_thickness, lip_depth, lip_height]);
            }

            // Top lip (protrudes backward into case)
            translate([wall_thickness, panel_thickness, panel_height - wall_thickness - lip_height]) {
                cube([panel_width - 2 * wall_thickness, lip_depth, lip_height]);
            }
        }

        // Dovetails
        if (with_dovetails) {
            color("gray") {
                // Top edge dovetails (clip - connects to top panel female clips)
                // Rails extend outward along +Y axis (into case)
                // Positioned beneath top edge by panel thickness
                for (x_pos = top_dovetail_positions) {
                    translate([x_pos, panel_thickness + dovetail_length / 2, panel_height - dovetail_height - wall_thickness])
                        rotate([0, 0, 0])
                            male_dovetail(with_latch = true);  // Clip for top shell connection
                }

                // Left edge dovetail (connects to left side panel)
                // Extends inward along +Y axis
                translate([wall_thickness, panel_thickness + dovetail_length / 2, side_dovetail_z])
                    rotate([0, 90, 0])
                        male_dovetail(with_latch = true);

                // Right edge dovetail (connects to right side panel)
                // Extends inward along +Y axis
                translate([panel_width - wall_thickness, panel_thickness + dovetail_length / 2, side_dovetail_z])
                    rotate([0, -90, 0])
                        male_dovetail(with_latch = true);
            }
        }
    }
}

// Preview
front_panel_pico();
