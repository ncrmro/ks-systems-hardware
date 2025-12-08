// Motherboard mounting plate for Mini-ITX
// 170x170mm plate with standoff mounting holes

include <../dimensions_minimal.scad>

module motherboard_plate() {
    color("blue") {
        difference() {
            cube([mobo_width, mobo_depth, wall_thickness]);

            // Standoff mounting holes
            for (loc = standoff_locations) {
                translate([loc[0], loc[1], -0.1]) {
                    cylinder(h = wall_thickness + 0.2, r = standoff_hole_radius, $fn = 20);
                }
            }
        }
    }
}

// Preview
motherboard_plate();
