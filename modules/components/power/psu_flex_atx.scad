module power_supply_flex_atx() {
    // Flex ATX Power Supply Dimensions (from technical drawing)
    // Standing orientation: thin side (40mm) as width on X axis
    psu_width = 40.0;       // A: Width (X - thin side)
    psu_length = 150.0;     // B: Length (Y)
    psu_height = 80.0;      // G: Height (Z - standing tall)

    // Mounting holes - 8-32 UNC thread (4 places)
    // Holes on rear face (Y = length), arranged in the 80x40 face
    mount_hole_radius = 2.1;    // 8-32 clearance (~4.2mm dia)
    mount_h_spacing = 63.5;     // F: Horizontal hole spacing (within 80mm height when standing)
    mount_v_spacing = 12.5;     // K: Offset from edges

    // Calculated hole positions (on the 40x80 rear face)
    hole_x_low = mount_v_spacing;                        // 12.5mm from left
    hole_x_high = psu_width - mount_v_spacing;           // 27.5mm from left
    hole_z_offset = (psu_height - mount_h_spacing) / 2;  // 8.25mm from bottom/top

    color("green") {
        difference() {
            // Main body
            cube([psu_width, psu_length, psu_height]);

            // 4 mounting holes on rear face (8-32 UNC)
            for (x = [hole_x_low, hole_x_high])
                for (z = [hole_z_offset, psu_height - hole_z_offset])
                    translate([x, psu_length - 2.5, z])
                        rotate([-90, 0, 0])
                            cylinder(r=mount_hole_radius, h=5, $fn=16);
        }
    }
}
