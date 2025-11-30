// Noctua NH-L12S Heatpipes
// 4x 6mm diameter copper heatpipes on one side of the heatsink

module nh_l12s_heatpipes() {
    pipe_diameter = 6;
    pipe_radius = pipe_diameter / 2;
    pipe_count = 4;
    pipe_height = 30;

    // Heatsink dimensions for reference
    heatsink_w = 128;
    heatsink_d = 146;

    // Pipes are positioned on front side (low Y), spread across width
    // Centered within the heatsink width
    pipe_spacing = 20;  // Space between pipe centers
    total_pipe_span = (pipe_count - 1) * pipe_spacing;
    start_x = (heatsink_w - total_pipe_span) / 2;

    // Y position - near front edge
    pipe_y = 20;  // Distance from front edge

    color([0.72, 0.45, 0.2]) {  // Copper color
        for (i = [0 : pipe_count - 1]) {
            translate([start_x + i * pipe_spacing, pipe_y, 0]) {
                cylinder(h = pipe_height, r = pipe_radius, $fn = 32);
            }
        }
    }
}

// Preview
nh_l12s_heatpipes();
