// Noctua NH-L12S Complete Heatsink Assembly
// Combines: CPU base + heatpipes + fan + fins
// Total height: 70mm

use <cpu_base.scad>
use <heatpipes.scad>
use <heatsink_fins.scad>
use <../cooling/fan_120mm_15mm.scad>

module noctua_nh_l12s() {
    // Overall dimensions
    cooler_w = 128;
    cooler_d = 146;

    // Component heights (bottom to top)
    cpu_base_h = 5;
    heatpipes_h = 30;
    fan_h = 15;
    fins_h = 20;
    // Total: 5 + 30 + 15 + 20 = 70mm

    // CPU base dimensions for centering
    cpu_base_w = 38;
    cpu_base_d = 40;
    cpu_base_x = (cooler_w - cpu_base_w) / 2;
    cpu_base_y = (cooler_d - cpu_base_d) / 2;

    // Fan dimensions for centering
    fan_size = 120;
    fan_x = (cooler_w - fan_size) / 2;
    fan_y = (cooler_d - fan_size) / 2;

    union() {
        // CPU base (at bottom, centered)
        translate([cpu_base_x, cpu_base_y, 0]) {
            nh_l12s_cpu_base();
        }

        // Heatpipes (above CPU base)
        translate([0, 0, cpu_base_h]) {
            nh_l12s_heatpipes();
        }

        // Fan (on inside face of fins, centered)
        translate([fan_x, fan_y, cpu_base_h + heatpipes_h]) {
            fan_120mm_15mm();
        }

        // Fins (at top)
        translate([0, 0, cpu_base_h + heatpipes_h + fan_h]) {
            nh_l12s_fins();
        }
    }
}

// Preview
noctua_nh_l12s();
