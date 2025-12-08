// Extended Standoff - M3x6+6mm Male-Female
// Used for Open Air Frame mounting system
// 6mm female thread below (accepts motherboard mounting screw)
// 6mm male stud above (frame cylinders screw onto this)

include <../dimensions_minimal.scad>

// --- Extended Standoff Dimensions ---
extended_standoff_female_height = 6;      // Female portion height (below mobo)
extended_standoff_male_height = 6;        // Male stud height (above mobo)
extended_standoff_outer_diameter = 5;     // Outer diameter of standoff body
extended_standoff_thread_diameter = 3;    // M3 thread diameter
extended_standoff_thread_clearance = 3.2; // M3 clearance hole

// Brass color
brass_color = [0.71, 0.65, 0.26];

// --- Module: Extended Standoff ---
// Creates a single M3x10+6mm male-female standoff
module extended_standoff() {
    color(brass_color) {
        // Female portion (below motherboard)
        difference() {
            cylinder(h=extended_standoff_female_height, d=extended_standoff_outer_diameter, $fn=6);
            // Female thread hole (for screw from below)
            translate([0, 0, -0.1])
                cylinder(h=extended_standoff_female_height + 0.2, d=extended_standoff_thread_clearance, $fn=32);
        }

        // Male stud (above motherboard)
        translate([0, 0, extended_standoff_female_height])
            cylinder(h=extended_standoff_male_height, d=extended_standoff_thread_diameter, $fn=32);
    }
}

// --- Module: Extended Standoffs at Mini-ITX locations ---
// Places extended standoffs at all 4 Mini-ITX mounting positions
module extended_standoffs() {
    for (pos = standoff_locations) {
        translate([pos[0], pos[1], 0])
            extended_standoff();
    }
}

// Preview
extended_standoff();
