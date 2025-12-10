// Bottom panel for Pico configuration
//
// INTEGRATED STANDOFF MOUNTING DESIGN:
// - Hexagonal receptacles at Mini-ITX standoff positions
// - Hexagonal bosses (2.5mm height) accept M3x10+6mm male-female standoffs
// - M3 x 8mm socket head cap screws secure standoffs from underneath
//
// DOVETAIL JOINTS (Base Assembly):
// - Female dovetails on back edge connect to back panel male dovetails
// - Bosses extend upward (+Z) into case interior
// - Per SPEC.md Section 9.6
//
// Standalone file for 3D printing - uses pico dimensions

include <../../dimensions_pico.scad>
include <../../../util/dovetail/dimensions.scad>
use <top.scad>  // For honeycomb_xy module
use <../../../util/dovetail/female_dovetail.scad>

module bottom_panel_pico(
    width = exterior_panel_width,
    depth = exterior_panel_depth,       // 173mm - extends to cover back panel
    ventilation = false,
    center_cutout = true,
    standoff_x_offset = wall_thickness,  // Offset standoffs to align with motherboard
    with_dovetails = true                // Female dovetails on back edge for base assembly
) {
    panel_width = width;
    panel_depth = depth;
    panel_thickness = wall_thickness;

    // Ventilation area
    vent_border = 20;
    vent_width = mobo_width - 2 * vent_border;
    vent_depth = mobo_depth - 2 * vent_border;
    vent_x_offset = vent_border + standoff_x_offset;  // Offset to center over motherboard
    vent_y_offset = vent_border;

    // Center cutout dimensions (sized to avoid standoffs)
    cutout_size = 125;  // Square cutout size
    cutout_x = (mobo_width - cutout_size) / 2 + standoff_x_offset;  // Offset to center over motherboard
    cutout_y = (mobo_depth - cutout_size) / 2;

    // Dovetail positions on back edge (2 dovetails at 25% and 75% of width)
    // Female channels face +Y, bosses extend +Z into case
    dovetail_positions = [width * 0.25, width * 0.75];
    // Offset Y to align boss back face with panel edge (accounting for asymmetric boss geometry)
    dovetail_y = depth - (dovetail_length / 2 + dovetail_clearance);

    union() {
        color("gray") {
            difference() {
                cube([panel_width, panel_depth, panel_thickness]);

                // Ventilation honeycomb
                if (ventilation) {
                    translate([vent_x_offset, vent_y_offset, 0]) {
                        honeycomb_xy(honeycomb_radius + 1, panel_thickness, vent_width, vent_depth);
                    }
                }

                // Center square cutout (reduces print time)
                if (center_cutout) {
                    translate([cutout_x, cutout_y, -0.1]) {
                        cube([cutout_size, cutout_size, panel_thickness + 0.2]);
                    }
                }

                // Standoff mounting holes (M3 screw clearance through panel and boss)
                for (loc = standoff_locations) {
                    translate([loc[0] + standoff_x_offset, loc[1], -0.1]) {
                        cylinder(h = panel_thickness + standoff_boss_height + 0.2, r = standoff_screw_clearance_hole / 2, $fn = 20);
                    }
                }
            }

            // Hexagonal bosses for standoff mounting (with hex pocket for standoff base)
            for (loc = standoff_locations) {
                translate([loc[0] + standoff_x_offset, loc[1], panel_thickness]) {
                    difference() {
                        // Outer boss
                        cylinder(h = standoff_boss_height, r = standoff_boss_diameter / 2, $fn = 6);
                        // Hex pocket for standoff base (5.5mm flat-to-flat)
                        translate([0, 0, standoff_boss_height - standoff_pocket_depth]) {
                            cylinder(h = standoff_pocket_depth + 0.1, r = standoff_hex_size_flat_to_flat / 2 / cos(30), $fn = 6);
                        }
                        // Screw clearance hole through boss
                        translate([0, 0, -0.1]) {
                            cylinder(h = standoff_boss_height + 0.2, r = standoff_screw_clearance_hole / 2, $fn = 20);
                        }
                    }
                }
            }
        }

        // Female dovetails on back edge (for base assembly connection to back panel)
        // Boss extends upward (+Z), channel faces +Y toward back panel
        if (with_dovetails) {
            for (x_pos = dovetail_positions) {
                translate([x_pos, dovetail_y, panel_thickness + dovetail_height])
                    rotate([180, 0, 0])  // Rotate so channel faces +Y (back panel slides in from +Y)
                        female_dovetail();
            }
        }
    }
}

// Preview
bottom_panel_pico();
