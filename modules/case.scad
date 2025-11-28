use <util/honeycomb.scad>
include <case/dimensions.scad>

module mini_itx_case() {
    // --- Case Dimensions ---
    // Width controlled by NAS 2-disk HDD layout (see SPEC.md Section 3.3)
    case_width = nas_2disk_width;        // ~226mm total
    mobo_area_width = mobo_width;        // 170mm for motherboard
    psu_area_width = psu_compartment_width;  // ~56mm for PSU (40mm PSU on side + clearance)

    plate_y = mobo_depth;                // 170mm
    plate_z = wall_thickness;            // 3mm

    // Standoff mounting hole locations in mm
    standoff_locs = standoff_locations;
    standoff_hole_r = standoff_hole_radius;

    // --- Backplate ---
    bp_height = backplate_height;        // 88.9mm (3.5 inches)
    bp_thickness = backplate_thickness;  // 3mm

    // --- IO Shield Hole ---
    io_hole_width = io_shield_width;     // 152.4mm (6 inches)
    io_hole_height = io_shield_height;   // 33.87mm
    io_hole_x_offset = io_shield_x_offset;  // Centered in mobo area
    io_hole_z_offset = io_shield_z_offset;  // 5mm from bottom

    // --- Honeycomb pattern ---
    hc_radius = honeycomb_radius;        // 3mm
    padding = vent_padding;              // 5mm
    honeycomb_area_z_start = io_hole_z_offset + io_hole_height + padding;
    honeycomb_area_width = mobo_area_width - 2 * padding;  // Honeycomb in mobo area only
    honeycomb_area_height = bp_height - honeycomb_area_z_start - padding;

    // --- PSU Mounting Holes ---
    // Flex ATX on side: 8-32 UNC thread holes
    psu_hole_radius = flex_atx_mount_hole_radius;  // 2.1mm
    psu_hole_h_spacing = flex_atx_mount_h_spacing; // 63.5mm - but PSU is on side, so this becomes vertical
    psu_hole_v_offset = flex_atx_mount_v_spacing;  // 12.5mm from edges
    // PSU center X position in the PSU compartment
    psu_center_x = mobo_area_width + psu_area_width / 2;

    // --- Separation between parts (for visualization) ---
    separation = 10;

    union() {
        // Motherboard plate with standoff holes
        color("blue") {
            difference() {
                cube([case_width, plate_y, plate_z]);
                // Standoff holes (in motherboard area)
                for (loc = standoff_locs) {
                    translate([loc[0], loc[1], -0.1]) {
                        cylinder(h = plate_z + 0.2, r = standoff_hole_r);
                    }
                }
            }
        }

        // Backplate with IO shield hole, honeycomb, and PSU mounting holes
        color("red") {
            translate([0, plate_y + separation, 0]) {
                difference() {
                    cube([case_width, bp_thickness, bp_height]);

                    // IO shield hole (in motherboard area)
                    translate([io_hole_x_offset, -0.1, io_hole_z_offset]) {
                        cube([io_hole_width, bp_thickness + 0.2, io_hole_height]);
                    }

                    // Honeycomb pattern (in motherboard area)
                    translate([padding, 0, honeycomb_area_z_start]) {
                        honeycomb_xz(hc_radius, bp_thickness, honeycomb_area_width, honeycomb_area_height);
                    }

                    // PSU mounting holes (in PSU compartment)
                    // Flex ATX on side: vertical hole spacing becomes Z, horizontal offset from PSU edges
                    // 4 holes in a rectangle pattern
                    psu_hole_z_bottom = psu_hole_v_offset;
                    psu_hole_z_top = bp_height - psu_hole_v_offset;
                    psu_hole_x_left = psu_center_x - psu_hole_h_spacing / 2;
                    psu_hole_x_right = psu_center_x + psu_hole_h_spacing / 2;

                    // Bottom-left
                    translate([psu_hole_x_left, -0.1, psu_hole_z_bottom]) {
                        rotate([-90, 0, 0]) cylinder(h = bp_thickness + 0.2, r = psu_hole_radius);
                    }
                    // Bottom-right
                    translate([psu_hole_x_right, -0.1, psu_hole_z_bottom]) {
                        rotate([-90, 0, 0]) cylinder(h = bp_thickness + 0.2, r = psu_hole_radius);
                    }
                    // Top-left
                    translate([psu_hole_x_left, -0.1, psu_hole_z_top]) {
                        rotate([-90, 0, 0]) cylinder(h = bp_thickness + 0.2, r = psu_hole_radius);
                    }
                    // Top-right
                    translate([psu_hole_x_right, -0.1, psu_hole_z_top]) {
                        rotate([-90, 0, 0]) cylinder(h = bp_thickness + 0.2, r = psu_hole_radius);
                    }
                }
            }
        }
    }
}
