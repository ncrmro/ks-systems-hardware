// Mini-ITX Motherboard Base
// Contains: PCB + I/O shield + 24-pin ATX connector + mounting holes
// This is the foundation for all motherboard assemblies
//
// Coordinate System:
// X-axis: 0 = left side, increases toward right
// Y-axis: 0 = front, increases toward back (I/O shield at back)
// Z-axis: 0 = bottom of motherboard PCB, increases upward
//
// Note: Standoffs are now part of base_assembly, not the motherboard module

include <../../case/dimensions.scad>
use <atx_24pin_connector.scad>

module motherboard() {
    mobo_width = 170;
    mobo_depth = 170;
    mobo_thickness = 1.6;

    io_shield_width = 152.4;
    io_shield_height = 33.87;
    io_shield_thickness = 2;
    io_shield_x_offset = (mobo_width - io_shield_width) / 2;

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
                }
                // Mounting holes at Mini-ITX standoff locations
                for (pos = standoff_locations) {
                    translate([pos[0], pos[1], -0.1]) {
                        cylinder(h = mobo_thickness + 0.2, r = standoff_hole_radius, $fn = 32);
                    }
                }
            }
        }

        // 24-pin ATX Connector (right edge, 25mm from front)
        // Rotated 90° so longest side runs along Y axis
        translate([mobo_width, 25, mobo_thickness]) {
            rotate([0, 0, 90]) {
                atx_24pin_connector();
            }
        }

        // Note: Standoffs removed from motherboard module (legacy code)
        // Standoffs are now part of base_assembly (integrated bottom panel design)
        // See modules/case/base/base_assembly.scad
    }
}

// Preview
motherboard();
