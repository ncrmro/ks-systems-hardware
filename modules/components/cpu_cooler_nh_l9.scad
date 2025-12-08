// Noctua NH-L9 Low-Profile CPU Cooler
// Total height: 37mm (vs 70mm for NH-L12S)
// Footprint: 95mm x 95mm
// Fan: 92mm x 14mm
// Ideal for ultra-compact builds with Pico PSU

module noctua_nh_l9() {
    // Overall dimensions
    cooler_width = 95;
    cooler_depth = 95;
    cooler_total_height = 37;

    // Component heights (simplified model)
    base_height = 5;        // CPU contact plate
    heatsink_height = 18;   // Aluminum fins
    fan_height = 14;        // 92mm x 14mm fan
    // Total: 5 + 18 + 14 = 37mm

    // Fan dimensions
    fan_size = 92;
    fan_x = (cooler_width - fan_size) / 2;
    fan_y = (cooler_depth - fan_size) / 2;

    union() {
        // CPU base plate (copper/nickel plated)
        color([0.72, 0.45, 0.20]) {  // Copper color
            translate([cooler_width/2 - 19, cooler_depth/2 - 20, 0]) {
                cube([38, 40, base_height]);
            }
        }

        // Heatsink fins (aluminum)
        color([0.75, 0.75, 0.75]) {  // Aluminum
            translate([0, 0, base_height]) {
                cube([cooler_width, cooler_depth, heatsink_height]);
            }
        }

        // 92mm Fan (brown/beige Noctua colors)
        color([0.59, 0.29, 0.0]) {  // Brown frame
            translate([fan_x, fan_y, base_height + heatsink_height]) {
                difference() {
                    cube([fan_size, fan_size, fan_height]);

                    // Fan blade cutout (circular)
                    translate([fan_size/2, fan_size/2, -0.1]) {
                        cylinder(h = fan_height + 0.2, d = fan_size - 8, $fn = 60);
                    }
                }
            }
        }

        // Fan hub (center)
        color([0.82, 0.71, 0.55]) {  // Beige
            translate([cooler_width/2, cooler_depth/2, base_height + heatsink_height + fan_height/2 - 2]) {
                cylinder(h = 4, d = 20, $fn = 30);
            }
        }
    }
}

// Preview
noctua_nh_l9();
