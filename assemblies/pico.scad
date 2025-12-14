// Pico Configuration Assembly
// Ultra-compact case with Pico ATX PSU and NH-L9 cooler
// Dimensions: 176mm x 176mm x ~63mm
// No PSU compartment - Pico ATX mounts on motherboard
//
// TWO-SHELL ASSEMBLY DESIGN:
// - Bottom Shell: bottom panel + back panel (semi-permanent connection via dovetails)
// - Top Shell: top + front + left side + right side panels (connected via internal clips)
// - User opens case by pinching back panel clips and sliding top shell forward
// - Per SPEC.md Section 9

include <../modules/case/dimensions_pico.scad>

// Case parts - all with dovetail joints for two-shell assembly
use <../modules/case/base/base_assembly_pico.scad>
use <../modules/case/panels/standard/back_pico.scad>
use <pico_topshell.scad>  // Top shell sub-assembly (top + front + sides)

// Motherboard assembly (includes motherboard, RAM, NH-L9 cooler, Pico PSU)
use <../modules/components/motherboard/motherboard_full_pico.scad>

// Power connector
use <../modules/components/power/barrel_jack_5_5x2_5.scad>
// Note: SSDs rendered via pico_topshell sub-assembly

// Toggle visibility for debugging
show_panels = true;
show_components = true;
explode = 5;  // Set > 0 to explode view (e.g., 20)

// Individual panel visibility toggles
show_bottom_panel = true;
show_back_panel = true;
show_front_panel = true;
show_left_side_panel = true;
show_right_side_panel = true;
show_top_panel = true;

// Individual component visibility toggles
show_motherboard = true;
show_barrel_jack = false;
show_ssd = true;

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
        // === CASE PANELS ===
        if (show_panels) {
            // Back panel (full width, raised to sit on bottom panel)
            // X=0 (full exterior width), Y at exterior_panel_depth (173mm), Z raised by wall_thickness
            if (show_back_panel) {
                translate([0, exterior_panel_depth + explode, wall_thickness]) {
                    back_panel_pico();
                }
            }

            // === TOP SHELL (front + sides + top panels + SSDs) ===
            // Uses pico_topshell sub-assembly in "assembly" mode
            pico_topshell(
                explode_distance = explode,
                with_ssd = show_ssd,
                with_front = show_front_panel,
                with_left_side = show_left_side_panel,
                with_right_side = show_right_side_panel,
                with_top = show_top_panel,
                mode = "assembly"
            );
        }

        // Bottom panel (with standoffs)
        // Positioned at X=0, Y=wall_thickness (behind front panel, extends to cover back)
        if (show_bottom_panel) {
            translate([0, wall_thickness, 0]) {
                base_assembly_pico();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard assembly (on standoffs)
            // Includes: motherboard PCB, RAM, NH-L9 cooler, Pico PSU
            // X offset: wall_thickness (to clear left side panel)
            // Y offset: wall_thickness (behind front panel, matches bottom panel positioning)
            // Z offset: wall_thickness (panel) + standoff_height (standoff)
            if (show_motherboard) {
                translate([wall_thickness, wall_thickness, wall_thickness + standoff_height]) {
                    motherboard_full_pico();
                }
            }

            // Barrel jack power connector (mounted in back panel)
            // Position matches the hole in back_panel_pico
            // Rotated 180° around X so barrel socket faces exterior (+Y direction)
            if (show_barrel_jack) {
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

            // SSDs are now rendered by pico_topshell (mounted to top panel interior)
        }
    }
}

// Render the assembly
pico_assembly();
