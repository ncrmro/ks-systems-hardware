// Bottom panel for Pico configuration
//
// INTEGRATED STANDOFF MOUNTING DESIGN:
// - Hexagonal receptacles at Mini-ITX standoff positions
// - Hexagonal bosses (2.5mm height) accept M3x10+6mm male-female standoffs
// - M3 x 8mm socket head cap screws secure standoffs from underneath
//
// Standalone file for 3D printing - uses pico dimensions

include <../../dimensions_pico.scad>
use <top.scad>  // For honeycomb_xy module

module bottom_panel_pico(
    width = interior_panel_width,
    depth = interior_panel_depth
) {
    panel_width = width;
    panel_depth = depth;
    panel_thickness = wall_thickness;

    // Ventilation area
    vent_border = 20;
    vent_width = mobo_width - 2 * vent_border;
    vent_depth = mobo_depth - 2 * vent_border;
    vent_x_offset = vent_border;
    vent_y_offset = vent_border;

    union() {
        color("gray") {
            difference() {
                cube([panel_width, panel_depth, panel_thickness]);

                // Ventilation honeycomb
                translate([vent_x_offset, vent_y_offset, 0]) {
                    honeycomb_xy(honeycomb_radius + 1, panel_thickness, vent_width, vent_depth);
                }

                // Standoff mounting holes (M3 screw clearance through panel and boss)
                for (loc = standoff_locations) {
                    translate([loc[0], loc[1], -0.1]) {
                        cylinder(h = panel_thickness + standoff_boss_height + 0.2, r = standoff_screw_clearance_hole / 2, $fn = 20);
                    }
                }
            }

            // Hexagonal bosses for standoff mounting (with hex pocket for standoff base)
            for (loc = standoff_locations) {
                translate([loc[0], loc[1], panel_thickness]) {
                    difference() {
                        // Outer boss
                        cylinder(h = standoff_boss_height, r = standoff_boss_diameter / 2, $fn = 6);
                        // Hex pocket for standoff base (5.5mm flat-to-flat)
                        translate([0, 0, standoff_boss_height - standoff_pocket_depth]) {
                            cylinder(h = standoff_pocket_depth + 0.1, r = standoff_hex_size_flat_to_flat / 2 / cos(30), $fn = 6);
                        }
                    }
                }
            }
        }
    }
}

// Preview
bottom_panel_pico();
