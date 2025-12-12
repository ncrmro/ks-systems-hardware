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
use <../../../util/honeycomb.scad>
use <../../../util/dovetail/female_dovetail.scad>
use <top.scad>  // For honeycomb_xy module

module top_panel_pico(
    width = exterior_panel_width,
    depth = exterior_panel_depth,         // 173mm - extends to cover back panel
    vent_x_offset_extra = wall_thickness, // Offset vent to center over motherboard
    with_dovetails = true
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
        }
    }
}

// Preview
top_panel_pico();
