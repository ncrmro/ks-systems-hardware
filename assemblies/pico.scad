// Pico Configuration Assembly
// Ultra-compact case with Pico ATX PSU and NH-L9 cooler
// Dimensions: 176mm x 176mm x ~52mm
// No PSU compartment - Pico ATX mounts on motherboard

include <../modules/case/dimensions_pico.scad>

// Case parts
use <../modules/case/base/base_assembly_pico.scad>
use <../modules/case/panels/standard/back_pico.scad>
use <../modules/case/panels/standard/side_left.scad>
use <../modules/case/panels/standard/side_right.scad>
use <../modules/case/panels/standard/top.scad>
use <../modules/case/panels/standard/front.scad>

// Motherboard assembly (includes motherboard, RAM, NH-L9 cooler, Pico PSU)
use <../modules/components/motherboard/motherboard_full_pico.scad>

// Power connector
use <../modules/components/power/barrel_jack_5_5x2_5.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
explode = 0;  // Set > 0 to explode view (e.g., 20)

// === COORDINATE SYSTEM ===
// X-axis: 0 = left side (front panel left edge), increases toward right
// Y-axis: 0 = front (front panel), increases toward back (along side panels)
// Z-axis: 0 = bottom, increases upward

module pico_assembly() {
    // Base offsets
    base_x = wall_thickness;
    base_y = wall_thickness;
    base_z = wall_thickness;

    union() {
        // === BASE ASSEMBLY (always visible - bottom panel + standoffs) ===
        // Positioned at X=0, Y=wall_thickness (behind front panel, extends to cover back)
        translate([0, wall_thickness, -explode]) {
            base_assembly_pico();
        }

        // === CASE PANELS ===
        if (show_panels) {
            // Back panel (shortened height, raised to sit on bottom panel)
            // Y position at exterior_panel_depth (173mm), Z raised by wall_thickness
            translate([wall_thickness, exterior_panel_depth + explode, wall_thickness]) {
                back_panel_pico();
            }

            // Front panel (extended width, pico height)
            translate([0, -explode, 0]) {
                front_panel(
                    width = front_back_panel_width + 2 * wall_thickness,
                    height = front_back_panel_height
                );
            }

            // Left side panel (shortened height, raised to sit on bottom panel)
            // Y=wall_thickness (behind front panel)
            translate([-explode, wall_thickness, wall_thickness]) {
                side_panel_left(
                    depth = side_panel_depth,
                    height = side_panel_height
                );
            }

            // Right side panel (shortened height, raised to sit on bottom panel)
            // Y=wall_thickness (behind front panel)
            translate([pico_case_width - wall_thickness + explode, wall_thickness, wall_thickness]) {
                side_panel_right(
                    depth = side_panel_depth,
                    height = side_panel_height
                );
            }

            // Top panel (full exterior width/depth, covers side panels from above)
            // Positioned at X=0, Y=wall_thickness (behind front panel)
            translate([0, wall_thickness, pico_exterior_height - wall_thickness + explode]) {
                top_panel(
                    width = exterior_panel_width,
                    depth = exterior_panel_depth
                );
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard assembly (on standoffs)
            // Includes: motherboard PCB, RAM, NH-L9 cooler, Pico PSU
            // X offset: wall_thickness (to clear left side panel)
            // Y offset: wall_thickness (behind front panel, matches bottom panel positioning)
            // Z offset: wall_thickness (panel) + standoff_height (standoff)
            translate([wall_thickness, wall_thickness, wall_thickness + standoff_height]) {
                motherboard_full_pico();
            }

            // Barrel jack power connector (mounted in back panel)
            // Position matches the hole in back_panel_pico
            // Rotated 180° around X so barrel socket faces exterior (+Y direction)
            translate([
                wall_thickness + pico_barrel_jack_x,
                exterior_panel_depth + wall_thickness + explode,
                wall_thickness + pico_barrel_jack_z
            ]) {
                rotate([180, 0, 0]) {
                    barrel_jack_5_5x2_5();
                }
            }
        }
    }
}

// Render the assembly
pico_assembly();
