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
use <../modules/case/panels/standard/side_pico.scad>
use <../modules/case/panels/standard/top_pico.scad>
use <../modules/case/panels/standard/front_pico.scad>

// Motherboard assembly (includes motherboard, RAM, NH-L9 cooler, Pico PSU)
use <../modules/components/motherboard/motherboard_full_pico.scad>

// Power connector
use <../modules/components/power/barrel_jack_5_5x2_5.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
explode = 0;  // Set > 0 to explode view (e.g., 20)

// Individual panel visibility toggles
show_bottom_panel = true;
show_back_panel = true;
show_front_panel = true;
show_left_side_panel = false;
show_right_side_panel = true;
show_top_panel = true;

// Individual component visibility toggles
show_motherboard = false;
show_barrel_jack = false;

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

            // Front panel (extended width, pico height, with dovetails)
            if (show_front_panel) {
                translate([0, -explode, 0]) {
                    front_panel_pico();
                }
            }

            // Left side panel (flush with bottom panel, with dovetails)
            // Y=wall_thickness (behind front panel)
            if (show_left_side_panel) {
                translate([-explode, wall_thickness, wall_thickness]) {
                    side_panel_pico(side = "left");
                }
            }

            // Right side panel (flush with bottom panel, with dovetails)
            // Y=wall_thickness (behind front panel)
            if (show_right_side_panel) {
                translate([pico_case_width - wall_thickness + explode, wall_thickness, wall_thickness]) {
                    side_panel_pico(side = "right");
                }
            }

            // Top panel (full exterior width/depth, covers side panels from above, with dovetails)
            // Positioned at X=0, Y=wall_thickness (behind front panel)
            if (show_top_panel) {
                translate([0, wall_thickness, pico_exterior_height - wall_thickness + explode]) {
                    top_panel_pico();
                }
            }
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
        }
    }
}

// Render the assembly
pico_assembly();
