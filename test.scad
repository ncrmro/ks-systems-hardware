module mini_itx_plate_with_holes() {
    // Dimensions of the Mini-ITX plate
    plate_x = 170;
    plate_y = 170;
    plate_z = 3; // 1/8 inch converted to nearest whole mm

    // Standoff locations in mm
    // Based on community-provided specifications for Mini-ITX
    locations = [
        [12.7, 12.7],
        [165.1, 12.7],
        [12.7, 165.1],
        [165.1, 165.1]
    ];

    // Radius for the mounting holes (slightly larger than 1.5mm radius for standoffs)
    hole_radius = 1.6;

    difference() {
        // The flat surface
        cube([plate_x, plate_y, plate_z]);

        // Holes for the standoffs
        for (loc = locations) {
            translate([loc[0], loc[1], -0.1]) { // -0.1 to ensure it cuts completely through
                cylinder(h = plate_z + 0.2, r = hole_radius);
            }
        }
    }
}

mini_itx_plate_with_holes();
