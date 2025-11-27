// IEC C14 Power Inlet Connector
// Standard PC power inlet for external power cord

module power_inlet_c14() {
    // C14 connector dimensions
    body_width = 27;
    body_height = 19.5;
    body_depth = 28;

    // Flange/mounting dimensions
    flange_width = 50;
    flange_height = 27;
    flange_thickness = 2;

    // Mount hole spacing
    mount_hole_spacing = 40;
    mount_hole_radius = 1.6;  // M3

    // Socket opening
    socket_width = 22;
    socket_height = 16;

    union() {
        // Mounting flange
        color("black") {
            difference() {
                translate([-flange_width/2 + body_width/2, 0, -flange_height/2 + body_height/2]) {
                    cube([flange_width, flange_thickness, flange_height]);
                }

                // Mount holes
                translate([body_width/2, -0.1, body_height/2]) {
                    translate([-mount_hole_spacing/2, 0, 0])
                        rotate([-90, 0, 0])
                            cylinder(h = flange_thickness + 0.2, r = mount_hole_radius, $fn = 20);
                    translate([mount_hole_spacing/2, 0, 0])
                        rotate([-90, 0, 0])
                            cylinder(h = flange_thickness + 0.2, r = mount_hole_radius, $fn = 20);
                }
            }
        }

        // Main body (behind panel)
        color("black") {
            translate([0, flange_thickness, 0]) {
                cube([body_width, body_depth, body_height]);
            }
        }

        // Socket opening indication
        color("dimgray") {
            translate([(body_width - socket_width)/2, -1, (body_height - socket_height)/2]) {
                cube([socket_width, 2, socket_height]);
            }
        }
    }
}

// Preview
power_inlet_c14();
