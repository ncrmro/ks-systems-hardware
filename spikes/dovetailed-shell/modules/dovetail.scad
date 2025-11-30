// Dovetail Joint Primitives
// Chamfered dovetail joints for support-free 3D printing

include <../dimensions.scad>

// Calculate top width from base width, height, and angle
function dovetail_top_width(base_width, height, angle) =
    base_width + 2 * height * tan(angle);

// Male dovetail rail - trapezoidal extrusion
// Origin at center of the rail base
// Cross-section in YZ plane: width in Y, height in +Z
// Extrudes along +X (length direction)
// Rail widens in +Z direction (trapezoid shape)
module male_dovetail(
    length = scaled_dovetail_length,
    height = scaled_dovetail_height,
    base_width = scaled_dovetail_base_width,
    angle = dovetail_angle
) {
    top_width = dovetail_top_width(base_width, height, angle);

    // Trapezoidal cross-section rotated 90° CW on Z then 90° CW on X
    rotate([-90, 180, 0])
    linear_extrude(height = length, center = true)
        polygon([
            [-base_width/2, 0],      // bottom left
            [base_width/2, 0],       // bottom right
            [top_width/2, height],   // top right
            [-top_width/2, height]   // top left
        ]);
}

// Female dovetail channel - trapezoidal cutout
// Same profile as male but with clearance added
// Origin at center of the channel base
// Cross-section in YZ plane: width in Y, height in +Z
// Extrudes along +X (length direction)
// Channel widens in +Z direction (trapezoid shape)
module female_dovetail(
    length = scaled_dovetail_length,
    height = scaled_dovetail_height,
    base_width = scaled_dovetail_base_width,
    angle = dovetail_angle,
    clearance = scaled_clearance
) {
    // Add clearance to all dimensions
    adj_base_width = base_width + 2 * clearance;
    adj_height = height + clearance;
    top_width = dovetail_top_width(adj_base_width, adj_height, angle);
    adj_length = length + 2 * clearance;

    rotate([-90, 180, 0])
    linear_extrude(height = adj_length, center = true)
        polygon([
            [-adj_base_width/2, -clearance],  // bottom left (extra height for clearance)
            [adj_base_width/2, -clearance],   // bottom right
            [top_width/2, adj_height],        // top right
            [-top_width/2, adj_height]        // top left
        ]);
}

// Test visualization
module dovetail_test() {
    // Show male (red) and female (blue, transparent) overlapping
    color("red") male_dovetail();
    color("blue", 0.3) female_dovetail();
}

// Uncomment to test
dovetail_test();
