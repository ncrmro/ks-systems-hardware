// Noctua NH-L12S CPU Contact Base
// Copper contact plate that sits on the CPU

module nh_l12s_cpu_base() {
    base_w = 38;
    base_d = 40;
    base_h = 5;

    // Copper colored contact plate
    color([0.72, 0.45, 0.2]) {
        cube([base_w, base_d, base_h]);
    }
}

// Preview
nh_l12s_cpu_base();
