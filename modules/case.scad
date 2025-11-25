use <honeycomb.scad>;

module mini_itx_case() {
    // --- Motherboard Plate ---
    plate_x = 170;
    plate_y = 170;
    plate_z = 3; // 1/8 inch converted to nearest whole mm

    // Standoff mounting hole locations in mm
    standoff_locations = [
        [12.7, 12.7],
        [165.1, 12.7],
        [12.7, 165.1],
        [165.1, 165.1]
    ];
    standoff_hole_radius = 1.6;

    // --- Backplate ---
    backplate_height = 88.9; // 3.5 inches
    backplate_thickness = 3;

    // --- IO Shield Hole ---
    io_hole_width = 152.4; // 6 inches
    io_hole_height = 33.87; // 1 1/3 inches
    io_hole_x_offset = (plate_x - io_hole_width) / 2;
    io_hole_z_offset = 5; // 5mm from the bottom of the plate

    // --- Honeycomb pattern ---
    honeycomb_radius = 3; // Changed from 5 to 3
    padding = 5; // Padding around the honeycomb
    honeycomb_area_z_start = io_hole_z_offset + io_hole_height + padding;
    honeycomb_area_width = plate_x - 2 * padding;
    honeycomb_area_height = backplate_height - honeycomb_area_z_start - padding;
    
    // --- Separation between parts ---
    separation = 10; // 10mm separation

    // --- SFX Power Supply Dimensions ---
    sfx_psu_width = 125;
    sfx_psu_depth = 100;
    sfx_psu_height = 63.5;
    psu_x_offset = plate_x + 300; // Offset for the power supply block

    union() {
        // Motherboard plate with holes
        color("blue") {
            difference() {
                cube([plate_x, plate_y, plate_z]);
                for (loc = standoff_locations) {
                    translate([loc[0], loc[1], -0.1]) {
                        cylinder(h = plate_z + 0.2, r = standoff_hole_radius);
                    }
                }
            }
        }

        // Backplate with IO shield hole and honeycomb
        color("red") {
            translate([0, plate_y + separation, 0]) { // Added separation here
                difference() {
                    cube([plate_x, backplate_thickness, backplate_height]);
                    
                    // IO shield hole
                    translate([io_hole_x_offset, -0.1, io_hole_z_offset]) {
                        cube([io_hole_width, backplate_thickness + 0.2, io_hole_height]);
                    }

                    // Honeycomb pattern
                    translate([padding, 0, honeycomb_area_z_start]) {
                        honeycomb_xz(honeycomb_radius, backplate_thickness, honeycomb_area_width, honeycomb_area_height);
                    }
                }
            }
        }

        // SFX Power Supply Block
        color("green") {
            translate([psu_x_offset, 0, -50]) {
                cube([sfx_psu_width, sfx_psu_depth, sfx_psu_height]);
            }
        }
    }
}
