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

include <../../dimensions_minimal.scad>
use <top.scad>  // For honeycomb_xy module

module bottom_panel(
    width = exterior_panel_width,
    depth = exterior_panel_depth,       // 173mm - extends to cover back panel
    ventilation = true,
    center_cutout = false,
    standoff_x_offset = wall_thickness  // Offset standoffs to align with motherboard
) {
    // Panel dimensions (interior, fits between side walls)
    panel_width = width;
    panel_depth = depth;
    panel_thickness = wall_thickness;      // 3mm

    // Ventilation area (smaller than top, for bottom intake)
    vent_border = 20;
    vent_width = mobo_width - 2 * vent_border;
    vent_depth = mobo_depth - 2 * vent_border;
    vent_x_offset = vent_border + standoff_x_offset;  // Offset to center over motherboard area
    vent_y_offset = vent_border;

    // Center cutout dimensions (sized to avoid standoffs)
    cutout_size = 100;  // Square cutout size
    cutout_x = (mobo_width - cutout_size) / 2 + standoff_x_offset;  // Offset to center over motherboard
    cutout_y = (mobo_depth - cutout_size) / 2;

    union() {
        // Main panel
        color("gray") {
            difference() {
                cube([panel_width, panel_depth, panel_thickness]);

                // Ventilation honeycomb (less dense than top)
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

    }
}

// Preview
bottom_panel();
