// GPU Configuration Assembly
// VERTICAL orientation - case stands TALL
// All I/O faces DOWN (bottom of case)
// From SPEC: Width 171mm, Depth 190mm, Height 378mm (standing)

include <../modules/case/dimensions.scad>

// Case parts
use <../modules/case/base/motherboard_plate.scad>
use <../modules/case/gpu/bracket.scad>
use <../modules/case/gpu/io_bracket.scad>

// Components
use <../modules/components/motherboard.scad>
use <../modules/components/gpu.scad>
use <../modules/components/pcie_riser.scad>
use <../modules/components/power/psu_sfx.scad>
use <../modules/components/power/power_inlet_c14.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
show_gpu = true;
show_psu = true;
explode = 0;  // Set > 0 to explode view

module gpu_assembly() {
    // Case dimensions - STANDING TALL
    // From SPEC section 8.4, reoriented for vertical stance
    case_width = gpu_config_width;    // 171mm (X - narrow)
    case_depth = gpu_config_height;   // 190mm (Y - medium)
    case_height = gpu_config_depth;   // 378mm (Z - TALL)

    wall = wall_thickness;

    // Motherboard position - flat at bottom, I/O facing down (Z=0)
    // Motherboard rotated so I/O shield is at Z=0
    mobo_x = wall;
    mobo_y = wall;
    mobo_z = wall;  // Just above bottom panel

    // GPU position - standing vertical beside motherboard
    // GPU is tall (320mm length becomes height)
    gpu_standoff = 20;  // Clearance from bottom
    gpu_x = wall + 10;
    gpu_y = mobo_depth + wall * 2 + 10;
    gpu_z = gpu_standoff;

    // PSU position - at top of case
    psu_z = case_height - sfx_height - wall - 10;
    psu_x = wall + 5;
    psu_y = wall + 5;

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

                    // GPU I/O slots (3 slots)
                    translate([wall + 5, mobo_depth + wall * 2, -1]) {
                        cube([gpu_width, 20, wall + 2]);
                    }

                    // Power inlet cutout (front bottom)
                    translate([case_width/2 - c14_width/2, case_depth - wall - 1, -1]) {
                        cube([c14_width, wall + 2, c14_height + wall + 1]);
                    }

                    // Side ventilation (honeycomb pattern simplified as slots)
                    for (z = [50 : 30 : case_height - 100]) {
                        // Left side vents
                        translate([-1, 20, z]) {
                            cube([wall + 2, case_depth - 40, 15]);
                        }
                        // Right side vents
                        translate([case_width - wall - 1, 20, z]) {
                            cube([wall + 2, case_depth - 40, 15]);
                        }
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
            // Motherboard - laid flat, I/O shield pointing down (toward Z=0)
            // Rotated so I/O faces the bottom panel
            translate([mobo_x, mobo_y + mobo_depth, mobo_z + standoff_height]) {
                rotate([90, 0, 0]) {
                    motherboard();
                }
            }

            // GPU - standing vertical (card length is now height)
            if (show_gpu) {
                translate([gpu_x, gpu_y, gpu_z]) {
                    // Rotate GPU: length (320mm) points up
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

            // Power inlet - at bottom rear
            translate([case_width/2, case_depth - wall, c14_height/2 + wall]) {
                rotate([90, 0, 0]) {
                    rotate([0, 0, 180]) {
                        power_inlet_c14();
                    }
                }
            }

            // PCIe riser cable
            translate([mobo_x + 50, mobo_y + mobo_depth + 10, mobo_z + 20]) {
                rotate([0, 0, 0]) {
                    pcie_riser(60);
                }
            }
        }
    }
}

// Render the assembly
gpu_assembly();
