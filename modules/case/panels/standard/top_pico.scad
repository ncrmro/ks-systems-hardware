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
    with_dovetails = true,
    with_ssd_divider = false              // SSD harness divider wall
) {
    // Panel dimensions
    panel_width = width;
    panel_depth = depth;
    panel_thickness = wall_thickness;      // 3mm

    // Ventilation area over CPU cooler (NH-L9: 95x95mm)
    // Sized to cover cooler area while avoiding SSD lip zones and dovetails
    // Left dovetail boss at ~8mm, SSD vertical divider at X=103mm, horizontal lip at Y≈94mm
    vent_width = 70;   // Shifted right to clear left dovetail
    vent_depth = 68;   // Covers cooler, stays in front of back SSD lip
    vent_x_offset = 25;  // Clears left edge dovetail boss (~2 hex rows removed)
    vent_y_offset = 22;  // Clears front edge dovetail (~1 hex row removed)

    // Front edge dovetail positions (latchless - internal top shell connection)
    // When SSD divider enabled: hide right dovetail (front-right SSD clearance)
    front_edge_dovetail_length = 9;  // Used for both position and module call - keeps them in sync
    front_dovetail_positions = with_ssd_divider
        ? [width * 0.25]
        : [width * 0.25, width * 0.75];
    front_dovetail_y = front_edge_dovetail_length / 2 + dovetail_clearance;

    // Left edge dovetail positions (clip - internal top shell connection)
    // Inset by wall_thickness so side panel fits flush
    // Use (depth - wall_thickness) to match side panel's shortened panel_depth
    // When SSD divider enabled: hide back dovetail (back-left SSD clearance)
    side_dovetail_depth = depth - wall_thickness;  // Match side panel's effective depth
    side_edge_dovetail_length = 9;  // Used for both position and module call - keeps them in sync
    left_dovetail_positions = with_ssd_divider
        ? [side_dovetail_depth * 0.33]
        : [side_dovetail_depth * 0.33, side_dovetail_depth * 0.67];
    left_dovetail_x = wall_thickness + side_edge_dovetail_length / 2 + dovetail_clearance;

    // Right edge dovetail positions (clip - internal top shell connection)
    // Inset by wall_thickness so side panel fits flush
    // When SSD divider enabled: hide front dovetail (front-right SSD clearance)
    right_dovetail_positions = with_ssd_divider
        ? [side_dovetail_depth * 0.67]
        : [side_dovetail_depth * 0.33, side_dovetail_depth * 0.67];
    right_dovetail_x = width - wall_thickness - (side_edge_dovetail_length / 2 + dovetail_clearance);

    // Back edge dovetail positions (latchless - structural connection to back panel)
    back_edge_dovetail_length = 9;  // Used for both position and module call - keeps them in sync
    back_dovetail_positions = [width * 0.75];
    back_dovetail_y = depth - (back_edge_dovetail_length / 2 + dovetail_clearance) - wall_thickness;

    union() {
        color("gray") {
            union() {
                difference() {
                    cube([panel_width, panel_depth, panel_thickness]);

                    // Ventilation honeycomb over motherboard/CPU area
                    translate([vent_x_offset, vent_y_offset, 0]) {
                        honeycomb_xy(honeycomb_radius, panel_thickness, vent_width, vent_depth);
                    }
                }

            }
        }

        // Female clip dovetails (internal top shell connections)
        // Bosses extend downward from inside face (Z=0) into case interior
        if (with_dovetails) {
            // Front edge dovetails (latchless - connects to front panel top edge)
            // Boss extends downward (-Z), channel faces -Y (toward front panel)
            for (x_pos = front_dovetail_positions) {
                translate([x_pos, front_dovetail_y, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                    rotate([0, 0, 180])  // Channel faces -Y (toward front edge)
                        female_dovetail(length = front_edge_dovetail_length, with_catch_windows = false);
            }

            // Left edge dovetails (latchless - connects to left side panel top edge)
            // Boss extends downward (-Z), channel faces +X (outward from panel center)
            for (y_pos = left_dovetail_positions) {
                translate([left_dovetail_x, y_pos, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                    rotate([0, 0, -90])  // Channel faces +X (outward toward left edge)
                        female_dovetail(length = side_edge_dovetail_length, with_catch_windows = false);
            }

            // Right edge dovetails (latchless - connects to right side panel top edge)
            // Boss extends downward (-Z), channel faces -X (outward from panel center)
            for (y_pos = right_dovetail_positions) {
                translate([right_dovetail_x, y_pos, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                    rotate([0, 0, 90])   // Channel faces -X (outward toward right edge)
                        female_dovetail(length = side_edge_dovetail_length, with_catch_windows = false);
            }

            // Back edge dovetails (latchless - structural connection to back panel)
            // Boss extends downward (-Z), channel faces +Y (toward back panel)
            for (x_pos = back_dovetail_positions) {
                translate([x_pos, back_dovetail_y, 0])
                    rotate([180, 0, 0])  // Flip so boss extends -Z (into case)
                        female_dovetail(length = back_edge_dovetail_length, with_catch_windows = false);
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
            channel_bridge = wall_thickness;              // 3mm bridge at bottom of channel

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

                // Screw channels (vertical slots with 3mm bridge at bottom)
                for (x_pos = channel_positions) {
                    translate([x_pos - channel_width/2, ssd1_front_y - 0.1, -divider_height + channel_bridge])
                        cube([channel_width, channel_depth, divider_height - channel_bridge + 0.1]);
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

                // Screw channels for SSD 2 (vertical slots with 3mm bridge at bottom)
                for (y_pos = ssd2_channel_positions) {
                    translate([divider_x - 0.1, y_pos - channel_width/2, -divider_height + channel_bridge])
                        cube([channel_depth, channel_width, divider_height - channel_bridge + 0.1]);
                }
            }
        }
    }
}

// Preview
top_panel_pico(with_ssd_divider = true);
