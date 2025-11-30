// Frame Cylinder - Open Air Frame Component
// Free-floating cylinder that screws onto extended standoff male studs
// Provides mounting point for upper frame and panels

include <../dimensions.scad>

// Color for 3D printed parts
cylinder_color = [0.3, 0.3, 0.3];  // Dark gray

// --- Module: Frame Cylinder ---
// Creates a single frame cylinder
// - Bottom has internal threads (thread_depth) to screw onto standoff stud
// - Total height = frame_cylinder_height (derived from interior_chamber_height)
// - Top surface provides panel attachment point
module frame_cylinder() {
    color(cylinder_color) {
        difference() {
            // Outer cylinder body
            cylinder(h=frame_cylinder_height, d=frame_cylinder_outer_diameter, $fn=32);

            // Internal thread hole (full depth for standoff stud engagement)
            translate([0, 0, -0.1])
                cylinder(h=frame_cylinder_thread_depth + 0.1, d=frame_cylinder_inner_diameter, $fn=32);
        }
    }
}

// --- Module: Frame Cylinders at Mini-ITX locations ---
// Places frame cylinders at all 4 Mini-ITX standoff positions
// Positioned at motherboard surface height (on top of extended standoff studs)
module frame_cylinders() {
    for (pos = standoff_locations) {
        translate([pos[0], pos[1], 0])
            frame_cylinder();
    }
}

// Preview
frame_cylinder();
