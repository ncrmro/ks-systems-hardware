// Back panel (I/O backplate) for minimal/barebones configuration
// Features I/O shield cutout, ventilation, and PSU mounting holes
// Mounts at rear of case behind motherboard and PSU
//
// DOVETAIL JOINTS (Base Assembly):
// - Male dovetails on bottom edge connect to bottom panel female dovetails
// - Rails extend downward (-Z) from panel bottom edge
// - Per SPEC.md Section 9.6

include <../../dimensions_minimal.scad>
include <../../../util/dovetail/dimensions.scad>
use <../../../util/honeycomb.scad>
use <../../../util/dovetail/male_dovetail.scad>

module back_panel(
    height = back_panel_height,  // 94mm - shortened to sit between top/bottom panels
    with_dovetails = true        // Male dovetails on bottom edge for base assembly
) {
    // Panel dimensions (interior, fits between side walls)
    extended_width = front_back_panel_width;   // ~220mm
    panel_height = height;                     // Uses parameter (94mm default)

    // Dovetail positions on bottom edge (match bottom panel positions)
    // Male rails extend downward (-Z), positioned to align with female channels
    // Back panel width is 220mm (front_back_panel_width), sits inset by wall_thickness from bottom panel
    // Bottom panel positions: width * 0.25 and width * 0.75 (at 226mm: 56.5mm and 169.5mm)
    // Back panel offset: wall_thickness (3mm) from bottom panel edge
    // So back panel X positions = (bottom_panel_position - wall_thickness)
    dovetail_positions = [exterior_panel_width * 0.25 - wall_thickness, exterior_panel_width * 0.75 - wall_thickness];

    // Honeycomb area calculations (motherboard section only)
    honeycomb_area_z_start = io_shield_z_offset + io_shield_height + vent_padding;
    honeycomb_area_width = mobo_width - 2 * vent_padding;
    honeycomb_area_height = panel_height - honeycomb_area_z_start - vent_padding;

    // PSU section calculations
    psu_section_x = mobo_width;  // PSU section starts at motherboard edge
    psu_section_width = extended_width - mobo_width;  // Interior PSU compartment width

    // PSU exhaust cutout - asymmetric to maximize airflow while avoiding mounting holes
    // Left/bottom inset: 10mm (material for bottom-left, bottom-right, top-left holes)
    // Right inset: reduced since top-right hole (coords) is removed for C14
    // Top inset: reduced since top-right hole (coords) is removed
    psu_exhaust_inset_left = 10;   // Material for top-left hole (coords)
    psu_exhaust_inset_right = 3;   // Extended - no top-right hole, bottom-right hole at Z=5 is below cutout
    psu_exhaust_inset_bottom = 10; // Material for bottom-left and bottom-right holes
    psu_exhaust_inset_top = 3;     // Extended - no top-right hole (coords)
    psu_cutout_width = flex_atx_width - psu_exhaust_inset_left - psu_exhaust_inset_right;   // 40 - 10 - 3 = 27mm
    psu_cutout_height = flex_atx_height - psu_exhaust_inset_bottom - psu_exhaust_inset_top; // 80 - 10 - 3 = 67mm

    // C14 power inlet cutout dimensions (from psu_flex_atx.scad)
    c14_body_width = 27;
    c14_body_height = 19.5;
    c14_clearance = 1;  // Extra clearance around C14
    c14_cutout_width = c14_body_width + 2 * c14_clearance;
    c14_cutout_height = c14_body_height + 2 * c14_clearance;
    // C14 position relative to PSU origin (top-right coords = top-left view from back)
    c14_x = flex_atx_width - 3.4 - c14_body_width;  // 9.6mm from left edge
    c14_z = flex_atx_height - 5 - c14_body_height;   // 55.5mm from bottom

    // Position PSU area (where PSU face aligns) - centered in compartment
    psu_area_x = psu_section_x + (psu_section_width - flex_atx_width) / 2;
    psu_area_z = (panel_height - flex_atx_height) / 2;  // Centered vertically

    // Exhaust cutout positioned with asymmetric insets
    psu_cutout_x = psu_area_x + psu_exhaust_inset_left;
    psu_cutout_z = psu_area_z + psu_exhaust_inset_bottom;

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
            // PSU exhaust cutout (27mm x 67mm) - asymmetric, extended toward top-right (coords)
            // where mounting hole was removed for C14
            translate([psu_cutout_x, -0.1, psu_cutout_z]) {
                cube([psu_cutout_width, wall_thickness + 0.2, psu_cutout_height]);
            }

            // C14 power inlet cutout (top-right coords = top-left view from back)
            // Positioned to allow C14 connector to pass through panel
            translate([psu_area_x + c14_x - c14_clearance, -0.1, psu_area_z + c14_z - c14_clearance]) {
                cube([c14_cutout_width, wall_thickness + 0.2, c14_cutout_height]);
            }

            // PSU mounting holes (3 holes - Flex ATX pattern from dimensions.scad)
            // Top-right (coords) removed - C14 power inlet is there = Top-left (view from back)
            // Remaining holes:
            //   Bottom-left (coords) = Bottom-right (view)
            //   Bottom-right (coords) = Bottom-left (view)
            //   Top-left (coords) = Top-right (view)
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

    // Male dovetails on bottom edge (for base assembly connection to bottom panel)
    // Rails extend outward from inside face (-Y direction) to engage with female channels
    if (with_dovetails) {
        color("red")
        for (x_pos = dovetail_positions) {
            // Offset Y by half dovetail length so rail base attaches to inside face (Y=0)
            translate([x_pos, dovetail_length/2, dovetail_height])
                rotate([180, 0, 0])  // Rail extends -Y (toward female channel on bottom panel)
                    male_dovetail();
        }
    }
}

// Preview
back_panel();
