// Motherboard Full Pico Assembly
// Contains: motherboard_with_ram + NH-L9 cooler + Pico PSU
// For ultra-compact builds with external AC adapter
//
// Coordinate System:
// X-axis: 0 = left side, increases toward right
// Y-axis: 0 = front, increases toward back
// Z-axis: 0 = bottom of motherboard PCB, increases upward

use <motherboard_with_ram.scad>
use <../cpu_cooler_nh_l9.scad>
use <../power/psu_pico.scad>

// Motherboard dimensions
mobo_width = 170;
mobo_depth = 170;
mobo_pcb_thickness = 1.6;

module motherboard_full_pico() {
    union() {
        // Base motherboard + RAM
        motherboard_with_ram();

        // NH-L9 CPU Cooler (20mm from front and left edges of motherboard)
        // Cooler is 95x95mm, rotated 90° CCW
        // With rotation, cooler occupies X[20, 115] Y[20, 115]
        translate([115, 20, mobo_pcb_thickness]) {
            rotate([0, 0, 90]) {
                noctua_nh_l9();
            }
        }

        // Pico PSU (near back-right of motherboard)
        // Positioned to plug into ATX header area
        translate([mobo_width - 65, mobo_depth - 55, mobo_pcb_thickness]) {
            psu_pico();
        }
    }
}

// Preview
motherboard_full_pico();
