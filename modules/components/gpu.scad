// Graphics Card (GPU) Model
// Reference dimensions for full-sized GPU
// Max: 320mm length, 3-slot (60mm) width

module gpu() {
    // GPU Dimensions (high-end 3-slot card)
    gpu_length = 320;      // X - card length
    gpu_height = 140;      // Y - PCB + cooler height
    gpu_width = 60;        // Z - 3 slots (~20mm each)

    // PCIe bracket dimensions
    bracket_width = 20;
    bracket_height = 120;
    bracket_thickness = 2;

    // I/O ports area
    io_height = 40;
    io_depth = 50;

    union() {
        // Main GPU body (shroud/cooler)
        color("dimgray") {
            cube([gpu_length, gpu_height, gpu_width]);
        }

        // PCIe bracket (at rear)
        color("silver") {
            translate([gpu_length - bracket_thickness, 0, 0]) {
                cube([bracket_thickness, bracket_height, gpu_width]);
            }
        }

        // Display I/O ports indication
        color("black") {
            translate([gpu_length - 5, 10, 5]) {
                cube([5, io_height, io_depth]);
            }
        }

        // PCIe connector (gold fingers)
        color("gold") {
            translate([50, -5, gpu_width/2 - 40]) {
                cube([90, 5, 20]);
            }
        }
    }
}

// Preview
gpu();
