// Side panel for Pico configuration
// Features ventilation honeycomb
// Parameterized for left or right side
//
// DOVETAIL JOINTS (Two-Shell Assembly):
// - Male clip dovetails on top edge connect to top panel female clips (internal)
// - Female clip dovetails on back edge connect to back panel male clips (EXTERNAL)
//   These are user-accessible release points
// - Per SPEC.md Section 9.6
//
// Standalone file for 3D printing - uses pico dimensions

include <../../dimensions_pico.scad>
include <../../../util/dovetail/dimensions.scad>
use <../../../util/honeycomb.scad>
use <../../../util/dovetail/male_dovetail.scad>
use <../../../util/dovetail/female_dovetail.scad>

module side_panel_pico(
    side = "left",                 // "left" or "right"
    depth = side_panel_depth,      // 176mm - extends to cover back panel
    height = side_panel_height,    // ~57mm - shortened to sit between top/bottom panels
    with_dovetails = true
) {
    is_left = (side == "left");

    // Panel dimensions (exterior, forms outer wall)
    panel_depth = depth - wall_thickness;  // Shortened 3mm from front
    panel_height = height;
    panel_thickness = wall_thickness;      // 3mm

    // Honeycomb area (leave border around edges)
    vent_border = 10;
    vent_width = panel_depth - 2 * vent_border;
    vent_height = panel_height - 2 * vent_border;

    // Top edge dovetail positions (clip - connects to top panel)
    top_dovetail_positions = [panel_depth * 0.33, panel_depth * 0.67];

    // Back edge dovetail position (female clip - EXTERNAL user-accessible release)
    // Single clip connects to back panel male clip
    back_dovetail_position = panel_height * 0.5;

    union() {
        color("gray") {
            difference() {
                cube([panel_thickness, panel_depth, panel_height]);

                // Ventilation honeycomb
                translate([0, vent_border, vent_border]) {
                    honeycomb_yz(honeycomb_radius, panel_thickness, vent_width, vent_height);
                }
            }
        }

        // Dovetails
        if (with_dovetails) {
            // Top edge dovetails (clip - connects to top panel female clips)
            // Rails extend from top edge upward toward +Z
            for (y_pos = top_dovetail_positions) {
                translate([panel_thickness / 2, y_pos, panel_height])
                    rotate([-90, 0, 0])
                        male_dovetail(with_latch = true);  // Clip for top shell connection
            }

            // Back edge dovetail (female clip - EXTERNAL user-accessible release)
            if (is_left) {
                // Left side: Boss extends toward +X (into case), channel faces +Y (back panel)
                translate([panel_thickness + dovetail_height, panel_depth, back_dovetail_position])
                    rotate([180, 90, 0])
                        female_dovetail(with_catch_windows = true);
            } else {
                // Right side: Boss extends toward -X (into case), channel faces +Y (back panel)
                translate([-dovetail_height, panel_depth, back_dovetail_position])
                    rotate([0, 90, 0])
                    rotate([0, 0, 90])
                        female_dovetail(with_catch_windows = true);
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

// Preview - change side parameter to preview left or right
side_panel_pico(side = "left");
