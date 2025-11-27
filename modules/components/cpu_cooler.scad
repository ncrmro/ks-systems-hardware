// A module for the Noctua NH-L12S CPU cooler
// Fan mounted UNDER heatsink (closest to motherboard)
module noctua_nh_l12s() {
    heatsink_w = 128;
    heatsink_d = 146;
    heatsink_h = 70;

    fan_w = 128;
    fan_d = 146;
    fan_h = 16;

    // RAM cutout dimensions (in heatsink)
    ram_cutout_w = 134;
    ram_cutout_d = 13;
    ram_cutout_h = 32;

    union() {
        // Fan (at bottom, closest to motherboard)
        color("tan") {
            cube([fan_w, fan_d, fan_h]);
        }

        // Heatsink (on top of fan)
        color("silver") {
            translate([0, 0, fan_h]) {
                difference() {
                    cube([heatsink_w, heatsink_d, heatsink_h]);
                    // RAM Cutout (from bottom of heatsink)
                    translate([(heatsink_w - ram_cutout_w)/2, -0.1, 0]) {
                        cube([ram_cutout_w, ram_cutout_d, ram_cutout_h]);
                    }
                }
            }
        }
    }
}

// Preview
noctua_nh_l12s();
