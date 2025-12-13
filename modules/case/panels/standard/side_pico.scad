// Side panel for Pico configuration
// Features ventilation honeycomb
// Parameterized for left or right side
//
// DOVETAIL JOINTS (Two-Shell Assembly):
// - Male clip dovetails on top edge connect to top panel female clips (internal)
// - Female clip dovetails on back edge connect to back panel male clips (EXTERNAL)
//   These are user-accessible release points
// - Female clip dovetails on front edge connect to front panel male clips (internal)
// - Per SPEC.md Section 9.6
//
// Standalone file for 3D printing - uses pico dimensions

include <../../dimensions_pico.scad>
include <../../../util/dovetail/dimensions.scad>
use <../../../util/honeycomb.scad>
use <../../../util/dovetail/male_dovetail.scad>
use <../../../util/dovetail/female_dovetail.scad>
use <../../../util/dovetail/female_dovetail_pocket.scad>

module side_panel_pico(
    side = "left",                 // "left" or "right"
    depth = side_panel_depth,      // 176mm - extends to cover back panel
    height = side_panel_height,    // ~57mm - shortened to sit between top/bottom panels
    ventilation = false,           // Honeycomb ventilation
    center_cutout = true,          // Simple rectangular cutout (alternative to honeycomb)
    with_dovetails = true
) {
    is_left = (side == "left");

    // Panel dimensions (exterior, forms outer wall)
    panel_depth = depth - 2 * wall_thickness;  // Shortened 3mm from front and back
    panel_height = height;  // Extended to be flush with front panel
    panel_thickness = wall_thickness;      // 3mm

    // Honeycomb area (leave border around edges)
    vent_border_y = 35;  // Front/back border (depth dimension) - reduced by ~1/3
    vent_border_z = 10;  // Top/bottom border (height dimension)
    vent_width = panel_depth - 2 * vent_border_y;
    vent_height = panel_height - 2 * vent_border_z;

    // Center cutout dimensions (simple rectangular cutout alternative)
    cutout_width = 90;   // Y dimension
    cutout_height = 30;  // Z dimension
    cutout_y = (panel_depth - cutout_width) / 2;
    cutout_z = (panel_height - cutout_height) / 2;

    // Top edge dovetail positions (clip - connects to top panel)
    top_dovetail_positions = [panel_depth * 0.33, panel_depth * 0.67];

    // Back edge dovetail position (female clip - EXTERNAL user-accessible release)
    // Single clip connects to back panel male clip
    back_dovetail_position = panel_height * 0.5;

    // Front edge dovetail position (female clip - connects to front panel male clip)
    front_dovetail_position = panel_height * 0.5;

    // Dovetail channel length (shared calculation)
    channel_length = dovetail_length + 2 * dovetail_clearance;

    // Calculate back dovetail Y position (used for cutout and shelf)
    // After rotation, the pocket's opening faces +Y
    // Position so opening is flush with panel back edge
    back_dovetail_y = panel_depth - channel_length/2;

    // Front dovetail Y position - opening faces -Y, flush with front edge
    front_dovetail_y = channel_length/2;

    // Retention lip dimensions (matches front panel)
    retention_lip_width = wall_thickness;  // Protrudes inward
    retention_lip_height = wall_thickness;

    // Internal module builds geometry as "left" panel
    // Right panel is created by mirroring this geometry
    module _panel_geometry() {
        union() {
            color("gray") {
                difference() {
                    cube([panel_thickness, panel_depth, panel_height]);

                    // Ventilation honeycomb
                    if (ventilation) {
                        translate([0, vent_border_y, vent_border_z]) {
                            honeycomb_yz(honeycomb_radius, panel_thickness, vent_width, vent_height);
                        }
                    }

                    // Center rectangular cutout (alternative to honeycomb)
                    if (center_cutout) {
                        translate([-0.1, cutout_y, cutout_z]) {
                            cube([panel_thickness + 0.2, cutout_width, cutout_height]);
                        }
                    }

                    // Cutout for back dovetail (goes through panel)
                    // Sized to fit the dovetail boss only
                    if (with_dovetails) {
                        // Boss dimensions (must match female_dovetail)
                        boss_width = (dovetail_base_width + 2 * dovetail_height * tan(dovetail_angle))
                                     + 2 * dovetail_boss_margin;
                        boss_depth = channel_length + dovetail_boss_margin;

                        // After rotation: boss_width → Z dimension, boss_depth → Y dimension
                        // Flush with back edge of panel
                        translate([-0.1, panel_depth - boss_depth,
                                   back_dovetail_position - boss_width/2])
                            cube([panel_thickness + 0.2, boss_depth + 0.1, boss_width]);
                    }
                }

            }

            // Dovetails (all positioned for left panel)
            if (with_dovetails) {
                // Top edge dovetails (clip - connects to top panel female clips)
                // Positioned flush with top edge
                for (y_pos = top_dovetail_positions) {
                    translate([panel_thickness + dovetail_length / 2, y_pos, panel_height])
                        rotate([180, 0, 90])
                            male_dovetail(with_latch = true);
                }

                // Back edge dovetail (female clip with shelf - EXTERNAL user-accessible release)
                // Outer edge at X=0
                translate([0, back_dovetail_y, back_dovetail_position])
                    rotate([0, -90, 180])
                        female_dovetail_pocket(with_catch_windows = true);

                // Front edge dovetail (female clip - INTERNAL non-visible)
                // On interior side, offset inward by dovetail_height
                translate([panel_thickness + dovetail_height, front_dovetail_y, front_dovetail_position])
                    rotate([0, -90, 0])
                        female_dovetail(with_catch_windows = true);
            }
        }
    }

    // Output: left panel directly, right panel mirrored
    if (is_left) {
        _panel_geometry();
    } else {
        translate([panel_thickness, 0, 0])
        mirror([1, 0, 0])
            _panel_geometry();
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
