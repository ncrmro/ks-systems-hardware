// Upper Frame - Open Air Frame "Halo"
// Rectangular frame that sits at the top of the frame cylinders
// Outside dimensions match Mini-ITX motherboard (170mm x 170mm)

include <../dimensions.scad>

// --- Frame Dimensions ---
// Rail width must be > standoff distance from edge (12.7mm) + hole radius + margin
upper_frame_rail_width = 16;          // Width of frame rails (covers standoff holes)
upper_frame_height = wall_thickness;  // Height/thickness of the halo

// Frame outside matches motherboard dimensions
upper_frame_width = mobo_width;   // 170mm
upper_frame_depth = mobo_depth;   // 170mm

// Color for 3D printed parts
frame_color = [0.4, 0.4, 0.4];  // Medium gray

// --- Module: Upper Frame ---
// Rectangular halo frame - outside dimensions match Mini-ITX motherboard
// Includes mounting holes at Mini-ITX standoff locations
module upper_frame() {
    color(frame_color) {
        // Position at top of frame cylinder height
        translate([0, 0, frame_cylinder_height - upper_frame_height]) {
            difference() {
                // Outer rectangle (matches motherboard footprint)
                cube([upper_frame_width, upper_frame_depth, upper_frame_height]);

                // Inner cutout (creates the halo)
                translate([upper_frame_rail_width, upper_frame_rail_width, -0.1])
                    cube([
                        upper_frame_width - 2 * upper_frame_rail_width,
                        upper_frame_depth - 2 * upper_frame_rail_width,
                        upper_frame_height + 0.2
                    ]);

                // Mounting holes at Mini-ITX standoff locations
                for (pos = standoff_locations) {
                    translate([pos[0], pos[1], -0.1])
                        cylinder(h=upper_frame_height + 0.2, r=standoff_hole_radius, $fn=20);
                }
            }
        }
    }
}

// Preview
upper_frame();
