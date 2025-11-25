// A module for the Noctua NH-L12S CPU cooler
module noctua_nh_l12s() {
    heatsink_w = 128;
    heatsink_d = 146;
    heatsink_h = 70;

    fan_w = 128;
    fan_d = 146;
    fan_h = 16;

    // RAM cutout dimensions
    ram_cutout_w = 134;
    ram_cutout_d = 13;
    ram_cutout_h = 32;

    union() {
        // Heatsink
        color("silver") {
            difference() {
                cube([heatsink_w, heatsink_d, heatsink_h]);
                // RAM Cutout
                translate([(heatsink_w - ram_cutout_w)/2, -0.1, 0]) {
                    cube([ram_cutout_w, ram_cutout_d, ram_cutout_h]);
                }
            }
        }
        // Fan
        color("tan") {
            translate([0, 0, heatsink_h]) {
                cube([fan_w, fan_d, fan_h]);
            }
        }
    }
}
