// Minimal/Barebones Configuration Assembly
// Complete case with motherboard, CPU cooler, and Flex ATX PSU

include <../modules/case/dimensions.scad>

// Case parts
use <../modules/case/base/base_assembly.scad>
use <../modules/case/panels/standard/back.scad>
use <../modules/case/panels/standard/side_left.scad>
use <../modules/case/panels/standard/side_right.scad>
use <../modules/case/panels/standard/top.scad>
use <../modules/case/panels/standard/front.scad>

// Components
use <../modules/components/motherboard/motherboard_full_minitx.scad>
use <../modules/components/power/psu_flex_atx.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
explode = 10;  // Set > 0 to explode view (e.g., 20)

module minimal_assembly() {
    // Base offsets
    base_x = wall_thickness;
    base_y = wall_thickness;
    base_z = wall_thickness;

    union() {
        // === CASE PANELS ===
        if (show_panels) {
            // Base assembly (bottom panel + standoffs)
            // Positioned at base offsets, includes integrated standoff mounting
            translate([base_x, base_y, -explode]) {
                base_assembly();
            }

            // Back panel (at rear, full height starts at Z=0)
            // DEBUG: Print positioning values
            echo("=== BACK PANEL DEBUG ===");
            echo("mobo_depth =", mobo_depth);
            echo("wall_thickness =", wall_thickness);
            echo("explode =", explode);
            echo("Back panel Y position =", mobo_depth + wall_thickness + explode);
            translate([wall_thickness, mobo_depth + wall_thickness + explode, 0]) {
                back_panel();
            }

            // Front panel (full height, extended to cover sides, starts at Z=0)
            translate([0, -explode, 0]) {
                front_panel();
            }

            // Left side panel (full height, offset 3mm from front, starts at Z=0)
            translate([-explode, wall_thickness, 0]) {
                side_panel_left();
            }

            // Right side panel (full height, offset 3mm from front, starts at Z=0)
            translate([minimal_with_psu_width - wall_thickness + explode, wall_thickness, 0]) {
                side_panel_right();
            }

            // Top panel (interior dimensions, fits between walls)
            translate([wall_thickness, wall_thickness, minimal_exterior_height + explode]) {
                top_panel();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard assembly (motherboard + RAM + CPU cooler, placed on standoffs)
            // Positioned at: wall_thickness (panel) + standoff_height (standoff) = 9mm
            // No extra wall_thickness needed (motherboard plate removed)
            translate([base_x, base_y, wall_thickness + standoff_height]) {
                motherboard_full_minitx();
            }

            // Flex ATX PSU (next to motherboard, rear face against backplate, centered vertically)
            translate([mobo_width + wall_thickness * 2, mobo_depth + wall_thickness - flex_atx_length, (minimal_exterior_height - flex_atx_height) / 2]) {
                power_supply_flex_atx();
            }
        }
    }
}

// Render the assembly
minimal_assembly();
