// Vertical GPU Mounting Bracket
// Holds GPU in vertical orientation with PCIe slot facing down

include <../dimensions_minimal.scad>

module gpu_bracket() {
    // Bracket dimensions
    bracket_width = gpu_width + 10;      // GPU width + clearance
    bracket_depth = 100;                  // Support depth
    bracket_height = gpu_height + 20;     // GPU height + margin
    bracket_thickness = 3;

    // GPU slot dimensions
    slot_width = gpu_width + 2;
    slot_depth = bracket_depth - 20;

    // Mount hole positions
    mount_hole_radius = panel_screw_radius;

    color("silver") {
        difference() {
            union() {
                // Back plate (mounts to case)
                cube([bracket_width, bracket_thickness, bracket_height]);

                // Bottom support rail
                translate([0, 0, 0]) {
                    cube([bracket_width, bracket_depth, bracket_thickness]);
                }

                // Side supports
                translate([0, 0, 0]) {
                    cube([bracket_thickness, bracket_depth, bracket_height / 2]);
                }
                translate([bracket_width - bracket_thickness, 0, 0]) {
                    cube([bracket_thickness, bracket_depth, bracket_height / 2]);
                }
            }

            // GPU slot in bottom rail
            translate([(bracket_width - slot_width) / 2, 10, -0.1]) {
                cube([slot_width, slot_depth, bracket_thickness + 0.2]);
            }

            // Mount holes in back plate
            hole_positions = [
                [bracket_width / 4, bracket_height / 4],
                [bracket_width * 3/4, bracket_height / 4],
                [bracket_width / 4, bracket_height * 3/4],
                [bracket_width * 3/4, bracket_height * 3/4]
            ];
            for (pos = hole_positions) {
                translate([pos[0], -0.1, pos[1]]) {
                    rotate([-90, 0, 0]) {
                        cylinder(h = bracket_thickness + 0.2, r = mount_hole_radius, $fn = 20);
                    }
                }
            }
        }
    }
}

// Preview
gpu_bracket();
