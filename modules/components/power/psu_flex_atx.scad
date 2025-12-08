// Use dimensions from dimensions_minimal.scad
include <../../case/dimensions_minimal.scad>

// C14 inlet dimensions (for power plug on rear of PSU)
flex_c14_body_width = 27;
flex_c14_body_height = 19.5;
flex_c14_body_depth = 5;  // How far it protrudes from PSU body
flex_c14_socket_width = 22;
flex_c14_socket_height = 16;

module power_supply_flex_atx() {
    // Flex ATX Power Supply - uses shared dimensions from dimensions.scad
    // Standing orientation: 40mm wide (X), 150mm deep (Y), 80mm tall (Z)
    // See dimensions.scad for: flex_atx_width, flex_atx_length, flex_atx_height
    // Mounting holes: flex_atx_mount_holes array with [X, Z] positions

    // C14 inlet position (start is 3.4mm from right edge in coords = top-left when viewed from back)
    c14_x = flex_atx_width - 3.4 - flex_c14_body_width;
    c14_z = flex_atx_height - 5 - flex_c14_body_height;  // Near top

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

    // C14 Power Inlet on rear face
    translate([c14_x, flex_atx_length, c14_z]) {
        // Black housing
        color("black") {
            cube([flex_c14_body_width, flex_c14_body_depth, flex_c14_body_height]);
        }
        // Socket opening (dark gray inset)
        color("dimgray") {
            socket_x = (flex_c14_body_width - flex_c14_socket_width) / 2;
            socket_z = (flex_c14_body_height - flex_c14_socket_height) / 2;
            translate([socket_x, flex_c14_body_depth - 1, socket_z])
                cube([flex_c14_socket_width, 1.5, flex_c14_socket_height]);
        }
    }
}

// Preview
power_supply_flex_atx();
