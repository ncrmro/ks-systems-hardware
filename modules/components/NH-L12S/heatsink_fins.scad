// Noctua NH-L12S Heatsink Fins
// Aluminum fin stack at top of cooler

module nh_l12s_fins() {
    fins_w = 128;
    fins_d = 146;
    fins_h = 20;

    // RAM cutout dimensions
    ram_cutout_w = 134;
    ram_cutout_d = 13;
    ram_cutout_h = fins_h + 1;

    color("silver") {
        difference() {
            cube([fins_w, fins_d, fins_h]);
            // RAM Cutout (front edge, full height of fins)
            translate([(fins_w - ram_cutout_w)/2, -0.1, -0.1]) {
                cube([ram_cutout_w, ram_cutout_d, ram_cutout_h]);
            }
        }
    }
}

// Preview
nh_l12s_fins();
