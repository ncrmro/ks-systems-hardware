// Simplified 2.5" SSD model for layout/visualization.
// Dimensions based on SFF-8201 specification for 2.5" drives.

// --- Drive Dimensions ---
ssd_2_5_width = 69.85;   // A4: 69.85mm standard width
ssd_2_5_length = 100;    // A6: up to 100.45mm max
ssd_2_5_height = 9.5;    // A1: 9.5mm (also 7mm, 15mm variants)

// --- Side Mounting Hole Positions (SFF-8201) ---
// Holes are M3 threaded, measured from front edge along length
ssd_2_5_hole_front = 14.0;    // A50: 14mm from front edge
ssd_2_5_hole_rear = 90.6;     // A51: 90.6mm from front edge
ssd_2_5_hole_from_bottom = 4.07;  // A28: 4.07mm from bottom surface
ssd_2_5_hole_from_side = 3.5;     // A7: ~3.5mm from side edge
ssd_2_5_hole_diameter = 3.0;      // M3 screw holes

module ssd_2_5(
    width = ssd_2_5_width,
    length = ssd_2_5_length,
    height = ssd_2_5_height,
    body_color = "silver"
) {
    color(body_color) {
        cube([width, length, height]);
    }
}
