// 240mm AIO Radiator Model
// 2x 120mm fan mount radiator for liquid cooling

module aio_radiator_240() {
    // Radiator dimensions
    rad_length = 275;      // Length (slightly longer than 2x 120mm)
    rad_width = 120;       // Width (matches 120mm fan)
    rad_thickness = 27;    // Standard thin radiator

    // Fan mount hole spacing (120mm fans)
    fan_mount_inset = 7.5;
    fan_spacing = 120;     // Center to center
    mount_hole_radius = 2.2;

    // Fitting positions
    fitting_radius = 6;
    fitting_height = 15;

    union() {
        // Main radiator body
        color("black") {
            difference() {
                cube([rad_length, rad_width, rad_thickness]);

                // Fan mount holes (2x 120mm pattern)
                for (fan = [0:1]) {
                    fan_offset = 15 + fan * fan_spacing;
                    mount_positions = [
                        [fan_offset + fan_mount_inset, fan_mount_inset],
                        [fan_offset + fan_spacing - fan_mount_inset, fan_mount_inset],
                        [fan_offset + fan_mount_inset, rad_width - fan_mount_inset],
                        [fan_offset + fan_spacing - fan_mount_inset, rad_width - fan_mount_inset]
                    ];
                    for (pos = mount_positions) {
                        translate([pos[0], pos[1], -0.1]) {
                            cylinder(h = rad_thickness + 0.2, r = mount_hole_radius, $fn = 20);
                        }
                    }
                }
            }
        }

        // Fins indication (visual only)
        color("dimgray") {
            translate([10, 10, rad_thickness]) {
                cube([rad_length - 20, rad_width - 20, 2]);
            }
        }

        // Inlet/outlet fittings
        color("silver") {
            // Inlet
            translate([rad_length - 20, rad_width/2 - 15, rad_thickness]) {
                cylinder(h = fitting_height, r = fitting_radius, $fn = 20);
            }
            // Outlet
            translate([rad_length - 20, rad_width/2 + 15, rad_thickness]) {
                cylinder(h = fitting_height, r = fitting_radius, $fn = 20);
            }
        }
    }
}

// Preview
aio_radiator_240();
