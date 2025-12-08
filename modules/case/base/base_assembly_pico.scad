// Base assembly for Pico configuration
// Bottom panel + standoffs
//
// Standalone file using pico dimensions

include <../dimensions_pico.scad>
use <../panels/standard/bottom_pico.scad>
use <../frame/standoff_extended.scad>

module base_assembly_pico(
    panel_width = interior_panel_width,
    panel_depth = interior_panel_depth
) {
    union() {
        // Bottom panel with integrated standoff receptacles
        bottom_panel_pico(width = panel_width, depth = panel_depth);

        // Extended standoffs positioned on top of bottom panel
        for (loc = standoff_locations) {
            translate([loc[0], loc[1], wall_thickness]) {
                extended_standoff();
            }
        }
    }
}

// Preview
base_assembly_pico();
