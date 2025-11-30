// Motherboard Assembly
// Combines motherboard with RAM and CPU cooler

use <../motherboard.scad>
use <../ram.scad>
use <../cpu_cooler.scad>

module motherboard_assembly() {
    mobo_thickness = 1.6;

    // DDR4 RAM positioning
    ram_t = 1.2;
    ram_spacing = 10;

    union() {
        // Bare motherboard
        motherboard();

        // RAM Sticks (2x DDR4)
        translate([10, 20, mobo_thickness]) {
            ram_stick();
            translate([0, ram_t + ram_spacing, 0]) {
                ram_stick();
            }
        }

        // CPU Cooler (Noctua NH-L12S)
        // Rotated 90° CCW, repositioned to stay over CPU area
        translate([158, 21, mobo_thickness]) {
            rotate([0, 0, 90]) {
                noctua_nh_l12s();
            }
        }
    }
}

// Preview
motherboard_assembly();
