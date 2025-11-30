// A module to create a rudimentary Mini-ITX motherboard model
// Includes mounting holes and standoffs at standard Mini-ITX positions

include <../case/dimensions.scad>
use <../case/frame/standoff_extended.scad>

module motherboard() {
    mobo_width = 170;
    mobo_depth = 170;
    mobo_thickness = 1.6;

    io_shield_width = 152.4;
    io_shield_height = 33.87;
    io_shield_thickness = 2;
    io_shield_x_offset = (mobo_width - io_shield_width) / 2;

    // ATX 24-pin connector dimensions
    atx_conn_l = 51.6;
    atx_conn_w = 15.1;
    atx_conn_h = 19.6;

    // Standoff positioning
    // Female portion sits below PCB, male stud extends up through hole
    standoff_female_h = 6;  // Height of female portion below PCB

    union() {
        // Motherboard PCB with mounting holes
        color("purple") {
            difference() {
                union() {
                    // Motherboard PCB
                    cube([mobo_width, mobo_depth, mobo_thickness]);
                    // I/O Shield
                    translate([io_shield_x_offset, mobo_depth - io_shield_thickness, mobo_thickness]) {
                        cube([io_shield_width, io_shield_thickness, io_shield_height]);
                    }
                    // 24-pin ATX Connector
                    translate([mobo_width - atx_conn_l, 0, mobo_thickness]) {
                        cube([atx_conn_l, atx_conn_w, atx_conn_h]);
                    }
                }
                // Mounting holes at Mini-ITX standoff locations
                for (pos = standoff_locations) {
                    translate([pos[0], pos[1], -0.1]) {
                        cylinder(h = mobo_thickness + 0.2, r = standoff_hole_radius, $fn = 32);
                    }
                }
            }
        }

        // Standoffs - positioned so female portion is below PCB
        // Male stud extends upward through the mounting holes
        for (pos = standoff_locations) {
            translate([pos[0], pos[1], -standoff_female_h]) {
                extended_standoff();
            }
        }
    }
}

// Preview
motherboard();
