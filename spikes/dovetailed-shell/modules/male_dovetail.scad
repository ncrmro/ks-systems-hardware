// Male Dovetail Rail
// Trapezoidal rail that slots into female dovetail channel

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

// Test visualization
color("red") male_dovetail();
