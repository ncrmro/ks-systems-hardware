// GPU I/O Bracket
// Rear bracket for GPU display outputs (faces bottom in vertical config)

include <../dimensions.scad>

module gpu_io_bracket() {
    // Standard PCIe bracket dimensions
    bracket_height = 120;
    bracket_width = gpu_width;  // 3 slots
    bracket_thickness = 2;

    // Slot openings for GPU I/O
    slot_height = 80;
    slot_inset = 10;

    color("silver") {
        difference() {
            cube([bracket_width, bracket_thickness, bracket_height]);

            // I/O slot openings (3 slots)
            for (i = [0:2]) {
                translate([5 + i * 18, -0.1, slot_inset]) {
                    cube([14, bracket_thickness + 0.2, slot_height]);
                }
            }
        }
    }
}

// Preview
gpu_io_bracket();
