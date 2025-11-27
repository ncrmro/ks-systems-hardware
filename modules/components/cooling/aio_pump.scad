// AIO Pump/Block Model
// CPU or GPU mount block with integrated pump

module aio_pump() {
    // Block dimensions (typical AIO pump block)
    block_size = 70;
    block_height = 30;
    block_corner_radius = 10;

    // Cold plate
    plate_size = 55;
    plate_thickness = 5;

    // Tubing fittings
    fitting_radius = 6;
    fitting_height = 10;
    fitting_spacing = 30;

    union() {
        // Main pump housing (simplified rounded block)
        color("black") {
            translate([0, 0, plate_thickness]) {
                cube([block_size, block_size, block_height]);
            }
        }

        // Cold plate (contacts CPU/GPU)
        color("silver") {
            translate([(block_size - plate_size)/2, (block_size - plate_size)/2, 0]) {
                cube([plate_size, plate_size, plate_thickness]);
            }
        }

        // Tubing fittings
        color("dimgray") {
            translate([block_size/2 - fitting_spacing/2, block_size + 1, plate_thickness + block_height/2]) {
                rotate([90, 0, 0]) {
                    cylinder(h = fitting_height, r = fitting_radius, $fn = 20);
                }
            }
            translate([block_size/2 + fitting_spacing/2, block_size + 1, plate_thickness + block_height/2]) {
                rotate([90, 0, 0]) {
                    cylinder(h = fitting_height, r = fitting_radius, $fn = 20);
                }
            }
        }

        // Top logo/branding area
        color("gray") {
            translate([10, 10, plate_thickness + block_height]) {
                cube([block_size - 20, block_size - 20, 2]);
            }
        }
    }
}

// Preview
aio_pump();
