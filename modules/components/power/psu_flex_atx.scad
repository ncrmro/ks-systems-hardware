// Use shared dimensions from dimensions.scad
include <../../case/dimensions.scad>

module power_supply_flex_atx() {
    // Flex ATX Power Supply - uses shared dimensions from dimensions.scad
    // Standing orientation: 40mm wide (X), 150mm deep (Y), 80mm tall (Z)
    // See dimensions.scad for: flex_atx_width, flex_atx_length, flex_atx_height
    // Mounting holes: flex_atx_mount_holes array with [X, Z] positions

    color("green") {
        difference() {
            // Main body
            cube([flex_atx_width, flex_atx_length, flex_atx_height]);

            // 4 mounting holes on rear face (8-32 UNC)
            for (hole = flex_atx_mount_holes)
                translate([hole[0], flex_atx_length - 2.5, hole[1]])
                    rotate([-90, 0, 0])
                        cylinder(r=flex_atx_mount_hole_radius, h=5, $fn=16);
        }
    }
}
