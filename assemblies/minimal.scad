// Minimal/Barebones Configuration Assembly
// Complete case with motherboard, CPU cooler, and Flex ATX PSU

include <../modules/case/dimensions_minimal.scad>

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
explode = 0;  // Set > 0 to explode view (e.g., 20)

module minimal_assembly() {
    // Base offsets
    base_x = wall_thickness;
    base_y = wall_thickness;
    base_z = wall_thickness;

    union() {
        // === BASE ASSEMBLY (always visible - bottom panel + standoffs) ===
        // Positioned at X=0, Y=wall_thickness (behind front panel, extends to cover back)
        translate([0, wall_thickness, -explode]) {
            base_assembly();
        }

        // === CASE PANELS ===
        if (show_panels) {
            // Back panel (shortened height, raised to sit on bottom panel)
            // Y position at exterior_panel_depth (173mm), Z raised by wall_thickness
            translate([wall_thickness, exterior_panel_depth + explode, wall_thickness]) {
                back_panel();
            }

            // Front panel (full height, extended to cover sides, starts at Z=0)
            translate([0, -explode, 0]) {
                front_panel();
            }

            // Left side panel (shortened height, raised to sit on bottom panel)
            // Y=wall_thickness (behind front panel)
            translate([-explode, wall_thickness, wall_thickness]) {
                side_panel_left();
            }

            // Right side panel (shortened height, raised to sit on bottom panel)
            // Y=wall_thickness (behind front panel)
            translate([minimal_with_psu_width - wall_thickness + explode, wall_thickness, wall_thickness]) {
                side_panel_right();
            }

            // Top panel (full exterior width/depth, covers side panels from above)
            // Positioned at X=0, Y=wall_thickness (behind front panel)
            translate([0, wall_thickness, minimal_exterior_height - wall_thickness + explode]) {
                top_panel();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard assembly (motherboard + RAM + CPU cooler, placed on standoffs)
            // X offset: wall_thickness (to clear left side panel)
            // Y offset: wall_thickness (behind front panel, matches bottom panel positioning)
            // Z offset: wall_thickness (panel) + standoff_height (standoff) = 9mm
            translate([wall_thickness, wall_thickness, wall_thickness + standoff_height]) {
                motherboard_full_minitx();
            }

            // Flex ATX PSU (next to motherboard, rear face against backplate, centered vertically)
            // X: mobo_width + 2*wall_thickness (after motherboard and interior wall)
            // Y: exterior_panel_depth - flex_atx_length (rear against back panel)
            // Z: centered vertically in case
            translate([mobo_width + wall_thickness * 2, exterior_panel_depth - flex_atx_length, (minimal_exterior_height - flex_atx_height) / 2]) {
                power_supply_flex_atx();
            }
        }
    }
}

// Render the assembly
minimal_assembly();
