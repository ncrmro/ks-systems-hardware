// Pico Configuration Assembly
// Ultra-compact case with Pico ATX PSU and NH-L9 cooler
// Dimensions: 176mm x 176mm x ~52mm
// No PSU compartment - Pico ATX mounts on motherboard

include <../modules/case/dimensions_pico.scad>

// Case parts
use <../modules/case/base/base_assembly.scad>
use <../modules/case/panels/standard/back_pico.scad>
use <../modules/case/panels/standard/side_left.scad>
use <../modules/case/panels/standard/side_right.scad>
use <../modules/case/panels/standard/top.scad>
use <../modules/case/panels/standard/front.scad>

// Components
use <../modules/components/motherboard.scad>
use <../modules/components/cpu_cooler_nh_l9.scad>
use <../modules/components/power/psu_pico.scad>
use <../modules/components/ram.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
explode = 0;  // Set > 0 to explode view (e.g., 20)

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
                base_assembly(
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
            // Motherboard (on standoffs)
            translate([base_x, base_y, wall_thickness + standoff_height]) {
                color("purple") {
                    difference() {
                        union() {
                            // Motherboard PCB
                            cube([mobo_width, mobo_depth, mobo_pcb_thickness]);
                            // I/O Shield
                            translate([io_shield_x_offset, mobo_depth - 2, mobo_pcb_thickness]) {
                                cube([io_shield_width, 2, io_shield_height]);
                            }
                        }
                        // Mounting holes
                        for (pos = standoff_locations) {
                            translate([pos[0], pos[1], -0.1]) {
                                cylinder(h = mobo_pcb_thickness + 0.2, r = standoff_hole_radius, $fn = 32);
                            }
                        }
                    }
                }
            }

            // RAM (2 sticks)
            translate([base_x + 10, base_y + 20, wall_thickness + standoff_height + mobo_pcb_thickness]) {
                ram_stick();
                translate([0, 11.2, 0]) {
                    ram_stick();
                }
            }

            // NH-L9 CPU Cooler (centered over CPU socket area)
            translate([base_x + 158, base_y + 21, wall_thickness + standoff_height + mobo_pcb_thickness]) {
                rotate([0, 0, 90]) {
                    noctua_nh_l9();
                }
            }

            // Pico PSU (on motherboard, near back panel)
            translate([base_x + mobo_width - 65, base_y + mobo_depth - 55, wall_thickness + standoff_height + mobo_pcb_thickness]) {
                psu_pico();
            }
        }
    }
}

// Render the assembly
pico_assembly();
