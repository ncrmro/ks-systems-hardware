// Motherboard Full Mini-ITX Assembly
// Contains: motherboard_with_ram + NH-L12S cooler
// For minimal, NAS 2-disk, NAS many-disk configurations
//
// Coordinate System:
// X-axis: 0 = left side, increases toward right
// Y-axis: 0 = front, increases toward back
// Z-axis: 0 = bottom of motherboard PCB, increases upward

use <motherboard_with_ram.scad>
use <../cpu_cooler.scad>

// Motherboard PCB thickness (needed for cooler positioning)
mobo_pcb_thickness = 1.6;

module motherboard_full_minitx() {
    union() {
        // Base motherboard + RAM
        motherboard_with_ram();

        // CPU Cooler (Noctua NH-L12S)
        // Rotated 90° CCW, positioned over CPU socket area
        translate([158, 21, mobo_pcb_thickness]) {
            rotate([0, 0, 90]) {
                noctua_nh_l12s();
            }
        }
    }
}

// Preview
motherboard_full_minitx();
