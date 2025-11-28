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

    // PSU exhaust cutout - uses shared Flex ATX dimensions
    psu_cutout_width = flex_atx_width;    // 40mm (from dimensions.scad)
    psu_cutout_height = flex_atx_height;  // 80mm (from dimensions.scad)
    psu_cutout_x = psu_section_x + (psu_section_width - psu_cutout_width) / 2;
    psu_cutout_z = standoff_height;  // Start at standoff height

    // PSU mounting holes - 4 holes using shared positions from dimensions.scad
    // flex_atx_mount_holes contains [X, Z] positions relative to PSU origin
    // Translate to backplate coords by adding cutout origin offset

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

            // PSU mounting holes (4 holes matching Flex ATX pattern from dimensions.scad)
            for (hole = flex_atx_mount_holes) {
                translate([psu_cutout_x + hole[0], -0.1, psu_cutout_z + hole[1]]) {
                    rotate([-90, 0, 0]) {
                        cylinder(h = backplate_thickness + 0.2, r = flex_atx_mount_hole_radius, $fn = 20);
                    }
                }
            }
        }
    }
}

// Preview
backplate_io();
