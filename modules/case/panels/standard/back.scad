// Back panel (I/O backplate) for minimal/barebones configuration
// Features I/O shield cutout, ventilation, and PSU mounting holes
// Mounts at rear of case behind motherboard and PSU

include <../../dimensions.scad>
use <../../../util/honeycomb.scad>

module back_panel() {
    // Panel dimensions (interior, fits between side walls)
    extended_width = front_back_panel_width;   // ~220mm
    panel_height = front_back_panel_height;    // ~100mm

    // Honeycomb area calculations (motherboard section only)
    honeycomb_area_z_start = io_shield_z_offset + io_shield_height + vent_padding;
    honeycomb_area_width = mobo_width - 2 * vent_padding;
    honeycomb_area_height = panel_height - honeycomb_area_z_start - vent_padding;

    // PSU section calculations
    psu_section_x = mobo_width;  // PSU section starts at motherboard edge
    psu_section_width = extended_width - mobo_width;  // Interior PSU compartment width

    // PSU exhaust cutout - smaller than PSU face to leave material for mounting holes
    // Inset calculation: 5mm (hole center) + 2.1mm (hole radius) + 3mm (material) ≈ 10mm
    psu_exhaust_inset = 10;  // Material border for mounting holes
    psu_cutout_width = flex_atx_width - 2 * psu_exhaust_inset;    // 40 - 20 = 20mm
    psu_cutout_height = flex_atx_height - 2 * psu_exhaust_inset;  // 80 - 20 = 60mm

    // Position PSU area (where PSU face aligns) - centered in compartment
    psu_area_x = psu_section_x + (psu_section_width - flex_atx_width) / 2;
    psu_area_z = (panel_height - flex_atx_height) / 2;  // Centered vertically

    // Exhaust cutout centered within PSU area
    psu_cutout_x = psu_area_x + psu_exhaust_inset;
    psu_cutout_z = psu_area_z + psu_exhaust_inset;

    color("red") {
        difference() {
            // Extended backplate spanning mobo + PSU
            cube([extended_width, wall_thickness, panel_height]);

            // === MOTHERBOARD SECTION ===
            // I/O shield cutout
            translate([io_shield_x_offset, -0.1, io_shield_z_offset]) {
                cube([io_shield_width, wall_thickness + 0.2, io_shield_height]);
            }

            // Honeycomb ventilation pattern (motherboard section)
            translate([vent_padding, 0, honeycomb_area_z_start]) {
                honeycomb_xz(honeycomb_radius, wall_thickness, honeycomb_area_width, honeycomb_area_height);
            }

            // === PSU SECTION ===
            // PSU exhaust cutout (20mm x 60mm)
            translate([psu_cutout_x, -0.1, psu_cutout_z]) {
                cube([psu_cutout_width, wall_thickness + 0.2, psu_cutout_height]);
            }

            // PSU mounting holes (4 holes matching Flex ATX pattern from dimensions.scad)
            // Holes are positioned relative to PSU area, not the smaller exhaust cutout
            for (hole = flex_atx_mount_holes) {
                translate([psu_area_x + hole[0], -0.1, psu_area_z + hole[1]]) {
                    rotate([-90, 0, 0]) {
                        cylinder(h = wall_thickness + 0.2, r = flex_atx_mount_hole_radius, $fn = 20);
                    }
                }
            }

            // === PANEL MOUNTING HOLES (to attach backplate to case frame) ===
            corner_offset = panel_screw_inset;  // 8mm from edge
            panel_mount_positions = [
                [corner_offset, corner_offset],
                [extended_width - corner_offset, corner_offset],
                [corner_offset, panel_height - corner_offset],
                [extended_width - corner_offset, panel_height - corner_offset]
            ];

            for (pos = panel_mount_positions) {
                translate([pos[0], -0.1, pos[1]]) {
                    rotate([-90, 0, 0]) {
                        cylinder(h = wall_thickness + 0.2, r = panel_screw_radius, $fn = 20);
                    }
                }
            }
        }
    }
}

// Preview
back_panel();
