// DC Barrel Jack 5.5x2.5mm
// Panel mount DC power connector
// 5.5mm outer diameter, 2.5mm center pin

module barrel_jack_5_5x2_5() {
    // Barrel dimensions (external connection)
    barrel_outer_diameter = 5.5;
    barrel_inner_diameter = 2.5;
    barrel_depth = 9.5;

    // Body dimensions (behind panel)
    body_diameter = 8;
    body_length = 11;

    // Panel mount nut area
    nut_diameter = 10;
    nut_thickness = 2;

    // Solder terminals extend behind body
    terminal_length = 3;

    $fn = 32;

    union() {
        // Main cylindrical body (behind panel)
        color("black") {
            translate([0, nut_thickness, 0])
                rotate([-90, 0, 0])
                    cylinder(h = body_length, d = body_diameter);
        }

        // Mounting nut/flange (at panel surface)
        color("silver") {
            rotate([-90, 0, 0])
                cylinder(h = nut_thickness, d = nut_diameter);
        }

        // Barrel socket opening (front, external side)
        color("dimgray") {
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(h = barrel_depth, d = barrel_outer_diameter);
                    translate([0, 0, -0.1])
                        cylinder(h = barrel_depth + 0.2, d = barrel_inner_diameter);
                }
            }
        }

        // Center pin (inside barrel)
        color("gold") {
            rotate([90, 0, 0])
                cylinder(h = barrel_depth - 2, d = barrel_inner_diameter * 0.8);
        }

        // Solder terminals (behind body)
        color("silver") {
            translate([0, nut_thickness + body_length, 0]) {
                // Positive terminal
                translate([2, 0, 0])
                    rotate([-90, 0, 0])
                        cylinder(h = terminal_length, d = 1);
                // Negative terminal
                translate([-2, 0, 0])
                    rotate([-90, 0, 0])
                        cylinder(h = terminal_length, d = 1);
            }
        }
    }
}

// Panel cutout dimensions for reference
function barrel_jack_panel_cutout_diameter() = 7;

// Preview
barrel_jack_5_5x2_5();
