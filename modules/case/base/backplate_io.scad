// I/O Backplate with I/O shield cutout, ventilation, and PSU mounting
// Mounts at rear of case behind motherboard and PSU
// Extended to full case width to allow PSU screwing into backplate

include <../dimensions.scad>
use <../../util/honeycomb.scad>

module backplate_io() {
    // Extended backplate width (motherboard + gap + PSU)
    extended_width = mobo_width + wall_thickness + flex_atx_width;  // ~253mm

    // Honeycomb area calculations (motherboard section only)
    honeycomb_area_z_start = io_shield_z_offset + io_shield_height + vent_padding;
    honeycomb_area_width = mobo_width - 2 * vent_padding;
    honeycomb_area_height = backplate_height - honeycomb_area_z_start - vent_padding;

    // PSU section calculations
    psu_section_x = mobo_width + wall_thickness;

    // PSU exhaust cutout (40mm fan opening, centered in PSU section)
    psu_cutout_size = 40;
    psu_cutout_x = psu_section_x + (flex_atx_width - psu_cutout_size) / 2;
    psu_cutout_z = standoff_height + (flex_atx_height - psu_cutout_size) / 2;  // Centered on PSU height

    // PSU mounting holes (M3, around the cutout)
    psu_mount_inset = 5;
    psu_mount_hole_radius = panel_screw_radius;  // 1.6mm for M3

    color("red") {
        difference() {
            // Extended backplate spanning mobo + PSU
            cube([extended_width, backplate_thickness, backplate_height]);

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
            // PSU exhaust cutout
            translate([psu_cutout_x, -0.1, psu_cutout_z]) {
                cube([psu_cutout_size, backplate_thickness + 0.2, psu_cutout_size]);
            }

            // PSU mounting holes (4 corners around cutout)
            psu_mount_positions = [
                [psu_cutout_x - psu_mount_inset, psu_cutout_z - psu_mount_inset],
                [psu_section_x + flex_atx_width - psu_mount_inset, psu_cutout_z - psu_mount_inset],
                [psu_cutout_x - psu_mount_inset, psu_cutout_z + psu_cutout_size + psu_mount_inset],
                [psu_section_x + flex_atx_width - psu_mount_inset, psu_cutout_z + psu_cutout_size + psu_mount_inset]
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
