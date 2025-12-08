// Pico ATX Power Supply
// Ultra-compact DC-DC converter that plugs directly into motherboard ATX header
// Models only the male connector and PSU PCB (no cable or barrel jack)
// Requires external AC-DC adapter with separate barrel jack cable

module psu_pico() {
    // Male ATX 24-pin connector dimensions (plugs into motherboard)
    atx_male_width = 50;      // Width of 24-pin connector (X axis, left-right)
    atx_male_depth = 7;    // Depth of connector (Y axis, front-back)
    atx_male_height = 13;     // Height of connector (Z axis, up-down)

    // Pico PSU PCB dimensions (extends upward from connector)
    pico_pcb_length = 50;      // Length along X axis (longest side, left-right)
    pico_pcb_height = 19;      // Height along Z axis (extends upward)
    pico_pcb_thickness = 1.6;  // Thickness along Y axis
    pico_component_depth = 4;  // Component protrusion from PCB face

    // Center PCB on connector
    pcb_x_offset = (atx_male_width - pico_pcb_length) / 2;

    union() {
        // Male ATX 24-pin connector (yellow/gold) - faces down
        color("yellow") {
            cube([atx_male_width, atx_male_depth, atx_male_height]);
        }

        // PCB Assembly (PCB + components grouped together)
        translate([pcb_x_offset, 0, atx_male_height]) {
            // Pico PSU PCB (extends upward, longest side along X)
            color("green") {
                cube([pico_pcb_length, pico_pcb_thickness, pico_pcb_height]);
            }

            // Components on PCB face (protrude in +Y direction)
            color([0.2, 0.2, 0.2]) {
                translate([5, pico_pcb_thickness, 5]) {
                    cube([pico_pcb_length - 10, pico_component_depth, pico_pcb_height - 10]);
                }
            }
        }
    }
}

// Preview
psu_pico();
