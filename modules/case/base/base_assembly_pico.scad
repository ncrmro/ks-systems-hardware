// Base assembly for Pico configuration
// Bottom panel + standoffs
//
// Standalone file using pico dimensions

include <../dimensions_pico.scad>
use <../panels/standard/bottom_pico.scad>
use <../frame/standoff_extended.scad>

module base_assembly_pico(
    panel_width = exterior_panel_width,
    panel_depth = exterior_panel_depth,  // 173mm - extends to cover back panel
    standoff_x_offset = wall_thickness   // Offset standoffs to align with motherboard
) {
    union() {
        // Bottom panel with integrated standoff receptacles
        bottom_panel_pico(width = panel_width, depth = panel_depth);

        // Extended standoffs positioned on top of bottom panel
        // X offset added to align with motherboard (which is at X=wall_thickness in assembly)
        for (loc = standoff_locations) {
            translate([loc[0] + standoff_x_offset, loc[1], wall_thickness]) {
                extended_standoff();
            }
        }
    }
}

// Preview
base_assembly_pico();
