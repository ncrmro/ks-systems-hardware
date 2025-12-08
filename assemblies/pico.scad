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

// Toggle visibility for debugging
show_panels = true;
show_components = true;
explode = 20;  // Set > 0 to explode view (e.g., 20)

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
            // Base assembly (bottom panel + standoffs)
            translate([base_x, base_y, -explode]) {
                base_assembly_pico(
                    panel_width = interior_panel_width,
                    panel_depth = interior_panel_depth
                );
            }

            // Back panel (at rear, with barrel jack hole)
            translate([wall_thickness, mobo_depth + wall_thickness + explode, 0]) {
                back_panel_pico(
                    width = front_back_panel_width,
                    height = front_back_panel_height,
                    barrel_x = pico_barrel_jack_x,
                    barrel_z = pico_barrel_jack_z,
                    barrel_diameter = pico_barrel_jack_diameter
                );
            }

            // Front panel (extended width, pico height)
            translate([0, -explode, 0]) {
                front_panel(
                    width = front_back_panel_width + 2 * wall_thickness,
                    height = front_back_panel_height
                );
            }

            // Left side panel
            translate([-explode, wall_thickness, 0]) {
                side_panel_left(
                    depth = pico_case_depth,
                    height = side_panel_height
                );
            }

            // Right side panel
            translate([pico_case_width - wall_thickness + explode, wall_thickness, 0]) {
                side_panel_right(
                    depth = pico_case_depth,
                    height = side_panel_height
                );
            }

            // Top panel
            translate([wall_thickness, wall_thickness, pico_exterior_height + explode]) {
                top_panel(
                    width = interior_panel_width,
                    depth = interior_panel_depth
                );
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard assembly (on standoffs)
            // Includes: motherboard PCB, RAM, NH-L9 cooler, Pico PSU
            translate([base_x, base_y, wall_thickness + standoff_height]) {
                motherboard_full_pico();
            }
        }
    }
}

// Render the assembly
pico_assembly();
