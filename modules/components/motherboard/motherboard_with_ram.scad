// Motherboard with RAM Assembly
// Contains: Mini-ITX motherboard + 2x RAM sticks
// Use this as foundation for cooler-specific assemblies
//
// Coordinate System:
// X-axis: 0 = left side, increases toward right
// Y-axis: 0 = front, increases toward back
// Z-axis: 0 = bottom of motherboard PCB, increases upward

use <motherboard.scad>
use <../ram.scad>

// Motherboard PCB thickness (needed for component positioning)
mobo_pcb_thickness = 1.6;

module motherboard_with_ram() {
    union() {
        // Motherboard PCB with I/O shield
        motherboard();

        // RAM (2 sticks, 5mm from front, 17mm from left of motherboard)
        // Stick spacing: 8mm between sticks
        translate([17, 5, mobo_pcb_thickness]) {
            ram_stick();
            translate([0, 8, 0]) {
                ram_stick();
            }
        }
    }
}

// Preview
motherboard_with_ram();
