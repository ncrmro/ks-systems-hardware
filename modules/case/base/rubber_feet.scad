// Rubber feet for case - screw into #6-32 threaded inserts on bottom panel corners
// Initial 3D-printable version
//
// These feet provide:
// - Vibration dampening
// - Airflow clearance underneath case
// - Stability on desk surface
//
// Mounting: Screws into #6-32 threaded inserts at bottom panel corners
// Compatible with standard PC case feet thread size

include <../dimensions.scad>

module rubber_foot() {
    // #6-32 UNC thread specifications
    thread_diameter = 3.5;  // ~3.5mm for #6-32 (slightly undersized for clearance)
    thread_length = 8;      // Length of threaded stud

    // Foot body dimensions
    foot_diameter = 15;     // Matches bottom.scad foot_diameter
    foot_height = 8;        // Height below panel (provides airflow clearance)

    // Taper for easy insertion
    taper_height = 1;

    color("darkgray") {
        union() {
            // Threaded stud (simplified - actual threading would need thread library)
            // Tapered tip for easier insertion
            cylinder(h = thread_length - taper_height, d = thread_diameter, $fn = 20);
            translate([0, 0, thread_length - taper_height]) {
                cylinder(h = taper_height, d1 = thread_diameter, d2 = thread_diameter - 0.5, $fn = 20);
            }

            // Foot body (truncated cone for better stability)
            translate([0, 0, -foot_height]) {
                cylinder(h = foot_height, d1 = foot_diameter + 2, d2 = foot_diameter, $fn = 30);
            }
        }
    }
}

// Preview
rubber_foot();
