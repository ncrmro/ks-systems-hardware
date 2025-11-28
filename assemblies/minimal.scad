// Minimal/Barebones Configuration Assembly
// Complete case with motherboard, CPU cooler, and Flex ATX PSU

include <../modules/case/dimensions.scad>

// Case parts
use <../modules/case/base/motherboard_plate.scad>
use <../modules/case/base/backplate_io.scad>
use <../modules/case/panels/standard/side_left.scad>
use <../modules/case/panels/standard/side_right.scad>
use <../modules/case/panels/standard/top.scad>
use <../modules/case/panels/standard/bottom.scad>
use <../modules/case/panels/standard/front.scad>

// Components
use <../modules/components/motherboard.scad>
use <../modules/components/power/psu_flex_atx.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
explode = 0;  // Set > 0 to explode view (e.g., 20)

module minimal_assembly() {
    // Base offsets
    base_x = wall_thickness;
    base_y = wall_thickness;
    base_z = wall_thickness;

    union() {
        // === CASE PANELS ===
        if (show_panels) {
            // Bottom panel (interior dimensions, fits between walls)
            translate([wall_thickness, wall_thickness, -explode]) {
                bottom_panel();
            }

            // Motherboard plate (raised by standoff height)
            translate([base_x, base_y, base_z + standoff_height]) {
                motherboard_plate();
            }

            // I/O Backplate (at rear, full height starts at Z=0)
            translate([wall_thickness, mobo_depth + wall_thickness + explode, 0]) {
                backplate_io();
            }

            // Front panel (full height, starts at Z=0)
            translate([wall_thickness, -explode, 0]) {
                front_panel();
            }

            // Left side panel (full height, starts at Z=0)
            translate([-explode, 0, 0]) {
                side_panel_left();
            }

            // Right side panel (full height, starts at Z=0)
            translate([minimal_with_psu_width - wall_thickness + explode, 0, 0]) {
                side_panel_right();
            }

            // Top panel (interior dimensions, fits between walls)
            translate([wall_thickness, wall_thickness, minimal_exterior_height - wall_thickness + explode]) {
                top_panel();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard with CPU cooler (placed on standoffs)
            translate([base_x, base_y, base_z + standoff_height + wall_thickness]) {
                motherboard();
            }

            // Flex ATX PSU (next to motherboard, rear face against backplate)
            translate([mobo_width + wall_thickness * 2, mobo_depth + wall_thickness - flex_atx_length, base_z + standoff_height]) {
                power_supply_flex_atx();
            }
        }
    }
}

// Render the assembly
minimal_assembly();
