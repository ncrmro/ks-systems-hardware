// Pico ATX Power Supply
// Ultra-compact DC-DC converter that mounts directly on motherboard
// Requires external AC-DC adapter (brick)
// DC power input via 5.5mm x 2.5mm barrel jack

use <barrel_jack_5_5x2_5.scad>

module psu_pico() {
    // Pico PSU PCB dimensions (typical for picoPSU-160-XT and similar)
    pico_pcb_width = 60;
    pico_pcb_depth = 50;
    pico_pcb_thickness = 1.6;
    pico_pcb_height = 10;  // Including components on top

    // Barrel jack position (mounted on edge of PCB)
    barrel_jack_x = -10;  // Extends beyond PCB edge
    barrel_jack_y = pico_pcb_depth / 2;
    barrel_jack_z = pico_pcb_thickness;

    // 24-pin ATX connector (extends from opposite edge)
    atx_conn_width = 51.6;
    atx_conn_depth = 15.1;
    atx_conn_height = 19.6;
    atx_conn_x = pico_pcb_width;  // Extends from right edge
    atx_conn_y = (pico_pcb_depth - atx_conn_depth) / 2;

    union() {
        // PCB
        color("green") {
            cube([pico_pcb_width, pico_pcb_depth, pico_pcb_thickness]);
        }

        // Components on PCB (simplified as single block)
        color([0.2, 0.2, 0.2]) {
            translate([5, 5, pico_pcb_thickness]) {
                cube([pico_pcb_width - 10, pico_pcb_depth - 10, pico_pcb_height - pico_pcb_thickness]);
            }
        }

        // DC barrel jack input (extends from left edge)
        translate([barrel_jack_x, barrel_jack_y, barrel_jack_z]) {
            rotate([0, 90, 0]) {
                barrel_jack_5_5x2_5();
            }
        }

        // 24-pin ATX output connector (extends from right edge)
        color("yellow") {
            translate([atx_conn_x, atx_conn_y, pico_pcb_thickness]) {
                cube([atx_conn_width, atx_conn_depth, atx_conn_height]);
            }
        }
    }
}

// Preview
psu_pico();
