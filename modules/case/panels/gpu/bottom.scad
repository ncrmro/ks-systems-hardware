// GPU Configuration Bottom Panel
// Contains cutouts for: Motherboard I/O, GPU outputs, Power inlet
// All I/O faces down in vertical GPU config

include <../../dimensions.scad>

module gpu_bottom_panel() {
    panel_width = gpu_config_width;
    panel_depth = gpu_config_depth;
    panel_thickness = wall_thickness;

    // Motherboard I/O cutout (rear of mobo)
    mobo_io_width = io_shield_width;
    mobo_io_height = io_shield_height;
    mobo_io_x = (mobo_width - mobo_io_width) / 2 + wall_thickness;
    mobo_io_y = mobo_depth + wall_thickness;

    // GPU I/O cutout (3 slots)
    gpu_io_width = gpu_width;
    gpu_io_height = 90;
    gpu_io_x = mobo_width + wall_thickness + 10;  // Next to motherboard area
    gpu_io_y = mobo_depth + wall_thickness;

    // Power inlet cutout
    power_x = panel_width / 2 - c14_width / 2;
    power_y = 20;

    color("gray") {
        difference() {
            cube([panel_width, panel_depth, panel_thickness]);

            // Motherboard I/O shield cutout
            translate([mobo_io_x, mobo_io_y, -0.1]) {
                cube([mobo_io_width, mobo_io_height + 0.2, panel_thickness + 0.2]);
            }

            // GPU I/O slots cutout
            translate([gpu_io_x, gpu_io_y, -0.1]) {
                cube([gpu_io_width, gpu_io_height + 0.2, panel_thickness + 0.2]);
            }

            // Power inlet cutout
            translate([power_x, power_y, -0.1]) {
                cube([c14_width, c14_height, panel_thickness + 0.2]);
            }

            // Ventilation holes (grid pattern)
            vent_start_x = 10;
            vent_start_y = power_y + c14_height + 20;
            vent_end_y = mobo_io_y - 20;
            for (x = [vent_start_x : 15 : panel_width - 10]) {
                for (y = [vent_start_y : 15 : vent_end_y]) {
                    translate([x, y, -0.1]) {
                        cylinder(h = panel_thickness + 0.2, r = 3, $fn = 20);
                    }
                }
            }
        }
    }
}

// Preview
gpu_bottom_panel();
