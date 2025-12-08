// Bottom panel for minimal/barebones configuration
//
// INTEGRATED STANDOFF MOUNTING DESIGN:
// - Hexagonal receptacles at Mini-ITX standoff positions (12.7, 165.1 pattern)
// - Hexagonal bosses (2.5mm height) accept M3x10+6mm male-female standoffs
// - M3 x 8mm socket head cap screws secure standoffs from underneath (bottom-up mounting)
// - Eliminates separate motherboard plate component
//
// ADDITIONAL FEATURES:
// - 4x #6-32 threaded holes at corners for NAS mounting or rubber feet
// - Honeycomb ventilation in motherboard area
// - Optional feet mounts (disabled when NAS enclosure provides feet)
//
// See SPEC.md Section 2.1 for complete mounting specifications
// Parametric: accepts width and depth for different configurations

include <../../dimensions.scad>
use <top.scad>  // For honeycomb_xy module

module bottom_panel(
    width = interior_panel_width,
    depth = interior_panel_depth
) {
    // Panel dimensions (interior, fits between side walls)
    panel_width = width;
    panel_depth = depth;
    panel_thickness = wall_thickness;      // 3mm

    // Ventilation area (smaller than top, for bottom intake)
    vent_border = 20;
    vent_width = mobo_width - 2 * vent_border;
    vent_depth = mobo_depth - 2 * vent_border;
    vent_x_offset = vent_border;
    vent_y_offset = vent_border;

    union() {
        // Main panel
        color("gray") {
            difference() {
                cube([panel_width, panel_depth, panel_thickness]);

                // Ventilation honeycomb (less dense than top)
                translate([vent_x_offset, vent_y_offset, 0]) {
                    honeycomb_xy(honeycomb_radius + 1, panel_thickness, vent_width, vent_depth);
                }

                // Standoff mounting holes (M3 screw clearance at Mini-ITX positions)
                for (loc = standoff_locations) {
                    translate([loc[0], loc[1], -0.1]) {
                        cylinder(h = panel_thickness + 0.2, r = standoff_screw_clearance_hole / 2, $fn = 20);
                    }
                }
            }

            // Hexagonal bosses for standoff mounting (on top of panel)
            // Bosses provide mechanical registration and screw head retention
            for (loc = standoff_locations) {
                translate([loc[0], loc[1], panel_thickness]) {
                    cylinder(h = standoff_boss_height, r = standoff_boss_diameter / 2, $fn = 6);
                }
            }
        }

    }
}

// Preview
bottom_panel();
