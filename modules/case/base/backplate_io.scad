// I/O Backplate with I/O shield cutout, ventilation, and PSU mounting
// Mounts at rear of case behind motherboard and PSU
// Extended to full case width to allow PSU screwing into backplate

include <../dimensions.scad>
use <../../util/honeycomb.scad>

module backplate_io() {
    // Panel dimensions (interior, fits between side walls)
    extended_width = front_back_panel_width;   // ~220mm
    panel_height = front_back_panel_height;    // ~94mm

    // Honeycomb area calculations (motherboard section only)
    honeycomb_area_z_start = io_shield_z_offset + io_shield_height + vent_padding;
    honeycomb_area_width = mobo_width - 2 * vent_padding;
    honeycomb_area_height = panel_height - honeycomb_area_z_start - vent_padding;

    // PSU section calculations
    psu_section_x = mobo_width;  // PSU section starts at motherboard edge
    psu_section_width = extended_width - mobo_width;  // Interior PSU compartment width

    // PSU exhaust cutout (40mm wide x 75mm tall, centered in PSU compartment)
    psu_cutout_width = 40;
    psu_cutout_height = 75;
    psu_cutout_x = psu_section_x + (psu_section_width - psu_cutout_width) / 2;
    psu_cutout_z = standoff_height;  // Start at standoff height

    // PSU mounting holes (2 holes, 32mm apart vertically, centered on cutout)
    psu_mount_spacing = 32;  // Flex ATX mounting hole spacing
    psu_mount_hole_radius = panel_screw_radius;  // 1.6mm for M3
    psu_mount_center_x = psu_cutout_x + psu_cutout_width / 2;
    psu_mount_center_z = psu_cutout_z + psu_cutout_height / 2;

    color("red") {
        difference() {
            // Extended backplate spanning mobo + PSU
            cube([extended_width, backplate_thickness, panel_height]);

            // === MOTHERBOARD SECTION ===
            // I/O shield cutout
            translate([io_shield_x_offset, -0.1, io_shield_z_offset]) {
                cube([io_shield_width, backplate_thickness + 0.2, io_shield_height]);
            }

            // Honeycomb ventilation pattern (motherboard section)
            translate([vent_padding, 0, honeycomb_area_z_start]) {
                honeycomb_xz(honeycomb_radius, backplate_thickness, honeycomb_area_width, honeycomb_area_height);
            }

            // === PSU SECTION ===
            // PSU exhaust cutout (40mm x 75mm)
            translate([psu_cutout_x, -0.1, psu_cutout_z]) {
                cube([psu_cutout_width, backplate_thickness + 0.2, psu_cutout_height]);
            }

            // PSU mounting holes (2 holes, 32mm apart, centered on cutout)
            psu_mount_positions = [
                [psu_mount_center_x, psu_mount_center_z - psu_mount_spacing / 2],
                [psu_mount_center_x, psu_mount_center_z + psu_mount_spacing / 2]
            ];

            for (pos = psu_mount_positions) {
                translate([pos[0], -0.1, pos[1]]) {
                    rotate([-90, 0, 0]) {
                        cylinder(h = backplate_thickness + 0.2, r = psu_mount_hole_radius, $fn = 20);
                    }
                }
            }
        }
    }
}

// Preview
backplate_io();
