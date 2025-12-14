// Top panel for Pico configuration
// Features ventilation honeycomb over CPU cooler area
//
// DOVETAIL JOINTS (Top Shell Assembly):
// - Female clip dovetails on front/left/right edges connect to panel top edges
// - These are internal connections that hold the top shell together
// - Per SPEC.md Section 9.6
//
// Standalone file for 3D printing - uses pico dimensions

include <../../dimensions_pico.scad>
include <../../../util/dovetail/dimensions.scad>
include <../../../components/storage/ssd_2_5.scad>  // For SSD dimensions
use <../../../util/honeycomb.scad>
use <../../../util/dovetail/female_dovetail.scad>
use <top.scad>  // For honeycomb_xy module

module top_panel_pico(
    width = exterior_panel_width,
    depth = exterior_panel_depth,         // 173mm - extends to cover back panel
    vent_x_offset_extra = wall_thickness, // Offset vent to center over motherboard
    with_dovetails = true,
    with_ssd_divider = false              // SSD harness divider wall
) {
    // Panel dimensions
    panel_width = width;
    panel_depth = depth;
    panel_thickness = wall_thickness;      // 3mm

    // Ventilation area over CPU cooler
    vent_border = 10;
    vent_width = mobo_width - 2 * vent_border;
    vent_depth = mobo_depth - 2 * vent_border;
    vent_x_offset = vent_border + vent_x_offset_extra;
    vent_y_offset = vent_border;

    // Front edge dovetail positions (clip - internal top shell connection)
    front_dovetail_positions = [width * 0.25, width * 0.75];
    front_dovetail_y = dovetail_length / 2 + dovetail_clearance;

    // Left edge dovetail positions (clip - internal top shell connection)
    // Inset by wall_thickness so side panel fits flush
    left_dovetail_positions = [depth * 0.33, depth * 0.67];
    left_dovetail_x = wall_thickness + dovetail_length / 2 + dovetail_clearance;

    // Right edge dovetail positions (clip - internal top shell connection)
    // Inset by wall_thickness so side panel fits flush
    right_dovetail_positions = [depth * 0.33, depth * 0.67];
    right_dovetail_x = width - wall_thickness - (dovetail_length / 2 + dovetail_clearance);

    // Back edge dovetail positions (latchless - structural connection to back panel)
    // Two dovetails at 25% and 75% of panel width
    back_dovetail_positions = [width * 0.75];
    back_dovetail_y = depth - (dovetail_length / 2 + dovetail_clearance) - wall_thickness;

    union() {
        color("gray") {
            difference() {
                cube([panel_width, panel_depth, panel_thickness]);

                // Ventilation honeycomb over motherboard/CPU area
                translate([vent_x_offset, vent_y_offset, 0]) {
                    honeycomb_xy(honeycomb_radius, panel_thickness, vent_width, vent_depth);
                }
            }
        }

        // Female clip dovetails (internal top shell connections)
        // Bosses extend downward from inside face (Z=0) into case interior
        if (with_dovetails) {
            // Front edge dovetails (clip - connects to front panel top edge)
            // Boss extends downward (-Z), channel faces +Y (outward from panel center)
            for (x_pos = front_dovetail_positions) {
                translate([x_pos, front_dovetail_y, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                        female_dovetail(with_catch_windows = true);
            }

            // Left edge dovetails (clip - connects to left side panel top edge)
            // Boss extends downward (-Z), channel faces +X (outward from panel center)
            for (y_pos = left_dovetail_positions) {
                translate([left_dovetail_x, y_pos, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                    rotate([0, 0, -90])  // Channel faces +X (outward toward left edge)
                        female_dovetail(with_catch_windows = true);
            }

            // Right edge dovetails (clip - connects to right side panel top edge)
            // Boss extends downward (-Z), channel faces -X (outward from panel center)
            for (y_pos = right_dovetail_positions) {
                translate([right_dovetail_x, y_pos, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                    rotate([0, 0, 90])   // Channel faces -X (outward toward right edge)
                        female_dovetail(with_catch_windows = true);
            }

            // Back edge dovetails (latchless - structural connection to back panel)
            // Boss extends downward (-Z), channel faces +Y (toward back panel)
            for (x_pos = back_dovetail_positions) {
                translate([x_pos, back_dovetail_y, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                        female_dovetail(with_catch_windows = false);  // Latchless for structural integrity
            }
        }

        // SSD divider walls with screw channels
        if (with_ssd_divider) {
            divider_height = 9;    // 9mm tall to support SSD height
            divider_thickness = wall_thickness; // 3mm

            // Screw channel dimensions (vertical slots for M3 screws)
            // Channels allow screws to slide to accommodate different SSD heights
            channel_width = ssd_2_5_hole_diameter + 0.5;  // M3 + clearance
            channel_depth = divider_thickness + 0.2;      // Through the lip

            // Horizontal lip along front edge of SSD 1 (back-left SSD)
            // SSD 1 origin is near back edge, extends 69.85mm in -Y (width after rotation)
            // This lip runs along X at the front edge of SSD 1, inset 3 wall thicknesses
            ssd1_front_y = panel_depth - ssd_2_5_width - 3 * wall_thickness;

            // Screw channel positions along the lip (SSD hole positions from SFF-8201)
            ssd1_lip_start_x = wall_thickness;
            channel_positions = [
                ssd1_lip_start_x + ssd_2_5_hole_front,  // Front hole: 14mm from SSD front
                ssd1_lip_start_x + ssd_2_5_hole_rear    // Rear hole: 90.6mm from SSD front
            ];

            color("gray")
            difference() {
                // The lip itself
                translate([wall_thickness, ssd1_front_y, -divider_height])
                    cube([ssd_2_5_length, divider_thickness, divider_height]);

                // Screw channels (vertical slots through the lip)
                for (x_pos = channel_positions) {
                    translate([x_pos - channel_width/2, ssd1_front_y - 0.1, -divider_height - 0.1])
                        cube([channel_width, channel_depth, divider_height + 0.2]);
                }
            }

            // Vertical divider (separates back-left and front-right SSD zones)
            // Position after SSD 1's length (rotated -90°, so length runs along X)
            // SSD 1 starts at X=wall_thickness, extends 100mm in +X
            // Ends 20mm past the inside edge of back SSD
            // Also serves as mounting lip for SSD 2 (front-right, length along Y)
            divider_x = ssd_2_5_length + wall_thickness;
            divider_length = ssd1_front_y + 20;

            // Screw channel positions for SSD 2 (along Y axis, from front edge)
            ssd2_channel_positions = [
                ssd_2_5_hole_front,  // Front hole: 14mm from front
                ssd_2_5_hole_rear    // Rear hole: 90.6mm from front
            ];

            color("gray")
            difference() {
                translate([divider_x, 0, -divider_height])
                    cube([divider_thickness, divider_length, divider_height]);

                // Screw channels for SSD 2 (vertical slots through the divider)
                for (y_pos = ssd2_channel_positions) {
                    translate([divider_x - 0.1, y_pos - channel_width/2, -divider_height - 0.1])
                        cube([channel_depth, channel_width, divider_height + 0.2]);
                }
            }
        }
    }
}

// Preview
top_panel_pico();
