// 120mm Case Fan Model
// Standard 120x120x25mm fan

module fan_120() {
    fan_size = 120;
    fan_thickness = 25;
    hub_diameter = 40;
    corner_radius = 5;
    mount_hole_inset = 7.5;  // Distance from edge to mount hole center
    mount_hole_radius = 2.2; // ~M4 clearance

    union() {
        color("dimgray") {
            difference() {
                // Outer frame (rounded corners approximated)
                cube([fan_size, fan_size, fan_thickness]);

                // Center opening for airflow
                translate([fan_size/2, fan_size/2, -0.1]) {
                    cylinder(h = fan_thickness + 0.2, r = (fan_size - 15) / 2, $fn = 60);
                }

                // Corner mount holes
                mount_positions = [
                    [mount_hole_inset, mount_hole_inset],
                    [fan_size - mount_hole_inset, mount_hole_inset],
                    [mount_hole_inset, fan_size - mount_hole_inset],
                    [fan_size - mount_hole_inset, fan_size - mount_hole_inset]
                ];
                for (pos = mount_positions) {
                    translate([pos[0], pos[1], -0.1]) {
                        cylinder(h = fan_thickness + 0.2, r = mount_hole_radius, $fn = 20);
                    }
                }
            }
        }

        // Hub
        color("black") {
            translate([fan_size/2, fan_size/2, fan_thickness/2]) {
                cylinder(h = fan_thickness - 4, r = hub_diameter/2, center = true, $fn = 40);
            }
        }

        // Blades (simplified)
        color("gray") {
            translate([fan_size/2, fan_size/2, fan_thickness/2]) {
                for (i = [0:6]) {
                    rotate([0, 0, i * 360/7]) {
                        translate([0, 30, 0]) {
                            cube([8, 40, 3], center = true);
                        }
                    }
                }
            }
        }
    }
}

// Preview
fan_120();
