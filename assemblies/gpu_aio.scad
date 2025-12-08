// GPU + AIO Liquid Cooling Configuration Assembly
// VERTICAL orientation - case stands TALL
// All I/O faces DOWN, 240mm radiator for cooling
// High-performance build with liquid cooling

include <../modules/case/dimensions.scad>

// Case parts
use <../modules/case/base/base_assembly.scad>
use <../modules/case/gpu/bracket.scad>
use <../modules/case/gpu/io_bracket.scad>

// Components
use <../modules/components/motherboard/motherboard.scad>
use <../modules/components/gpu.scad>
use <../modules/components/pcie_riser.scad>
use <../modules/components/power/psu_sfx.scad>
use <../modules/components/power/power_inlet_c14.scad>
use <../modules/components/cooling/aio_radiator_240.scad>
use <../modules/components/cooling/aio_pump.scad>
use <../modules/components/cooling/fan_120.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
show_gpu = true;
show_psu = true;
show_cooling = true;
explode = 0;  // Set > 0 to explode view

module gpu_aio_assembly() {
    // Case dimensions - STANDING TALL
    // Wider than standard GPU config to accommodate radiator
    case_width = gpu_config_width + radiator_240_thickness + fan_120_thickness + 20;  // ~250mm
    case_depth = gpu_config_height;   // 190mm (Y)
    case_height = gpu_config_depth;   // 378mm (Z - TALL)

    wall = wall_thickness;

    // Motherboard position
    mobo_x = wall;
    mobo_y = wall;
    mobo_z = wall;

    // GPU position
    gpu_standoff = 20;
    gpu_x = wall + 10;
    gpu_y = mobo_depth + wall * 2 + 10;
    gpu_z = gpu_standoff;

    // PSU position - at top
    psu_z = case_height - sfx_height - wall - 10;
    psu_x = wall + 5;
    psu_y = wall + 5;

    // Radiator position - side mounted, vertical
    rad_x = case_width - radiator_240_thickness - wall - 5;
    rad_y = (case_depth - radiator_240_width) / 2;
    rad_z = (case_height - radiator_240_length) / 2;

    union() {
        // === CASE SHELL ===
        if (show_panels) {
            color("gray", 0.3) {
                difference() {
                    // Outer shell
                    cube([case_width, case_depth, case_height]);

                    // Inner cavity
                    translate([wall, wall, wall]) {
                        cube([case_width - 2*wall, case_depth - 2*wall, case_height - 2*wall]);
                    }

                    // Bottom I/O cutouts
                    // Motherboard I/O shield opening
                    translate([mobo_x + io_shield_x_offset, -1, -1]) {
                        cube([io_shield_width, wall + 2, io_shield_height + wall + 1]);
                    }

                    // GPU I/O slots
                    translate([wall + 5, mobo_depth + wall * 2, -1]) {
                        cube([gpu_width, 20, wall + 2]);
                    }

                    // Power inlet cutout
                    translate([gpu_config_width/2 - c14_width/2, case_depth - wall - 1, -1]) {
                        cube([c14_width, wall + 2, c14_height + wall + 1]);
                    }

                    // Left side ventilation
                    for (z = [50 : 30 : case_height - 100]) {
                        translate([-1, 20, z]) {
                            cube([wall + 2, case_depth - 40, 15]);
                        }
                    }

                    // Right side - radiator intake (large opening)
                    translate([case_width - wall - 1, rad_y - 10, rad_z - 10]) {
                        cube([wall + 2, radiator_240_width + 20, radiator_240_length + 20]);
                    }

                    // Top ventilation
                    for (x = [20 : 25 : case_width - 20]) {
                        for (y = [20 : 25 : case_depth - 20]) {
                            translate([x, y, case_height - wall - 1]) {
                                cylinder(h = wall + 2, r = 5, $fn = 6);
                            }
                        }
                    }
                }
            }

            // GPU bracket
            translate([gpu_x, gpu_y - 30, gpu_z]) {
                gpu_bracket();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard - rotated so I/O faces down
            translate([mobo_x, mobo_y + mobo_depth, mobo_z + standoff_height]) {
                rotate([90, 0, 0]) {
                    motherboard();
                }
            }

            // GPU - standing vertical
            if (show_gpu) {
                translate([gpu_x, gpu_y, gpu_z]) {
                    rotate([0, -90, 0]) {
                        rotate([0, 0, -90]) {
                            gpu();
                        }
                    }
                }
            }

            // SFX PSU - at top
            if (show_psu) {
                translate([psu_x, psu_y, psu_z]) {
                    power_supply_sfx();
                }
            }

            // Power inlet
            translate([gpu_config_width/2, case_depth - wall, c14_height/2 + wall]) {
                rotate([90, 0, 0]) {
                    rotate([0, 0, 180]) {
                        power_inlet_c14();
                    }
                }
            }

            // PCIe riser cable
            translate([mobo_x + 50, mobo_y + mobo_depth + 10, mobo_z + 20]) {
                pcie_riser(60);
            }

            // === COOLING SYSTEM ===
            if (show_cooling) {
                // 240mm Radiator - vertical on side
                translate([rad_x, rad_y, rad_z]) {
                    rotate([0, 0, 90]) {
                        rotate([90, 0, 0]) {
                            aio_radiator_240();
                        }
                    }
                }

                // Radiator fans (2x 120mm) - pulling air through radiator
                translate([rad_x - fan_120_thickness - 2, rad_y, rad_z + 15]) {
                    rotate([0, 0, 90]) {
                        rotate([90, 0, 0]) {
                            fan_120();
                        }
                    }
                }
                translate([rad_x - fan_120_thickness - 2, rad_y, rad_z + 15 + fan_120_size + 5]) {
                    rotate([0, 0, 90]) {
                        rotate([90, 0, 0]) {
                            fan_120();
                        }
                    }
                }

                // AIO Pump block (on CPU area)
                translate([mobo_x + 40, mobo_y + 60, mobo_z + standoff_height + 30]) {
                    rotate([90, 0, 0]) {
                        aio_pump();
                    }
                }
            }
        }
    }
}

// Render the assembly
gpu_aio_assembly();
