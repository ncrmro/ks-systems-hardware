use <../../components/storage/hdd_3_5.scad>
use <hotswap_rails.scad>
include <../dimensions.scad>

module case_nas_2x() {
    // Use shared dimensions from dimensions.scad
    // Width calculation defines the controlling dimension for case width
    // See SPEC.md Section 3.3
    hdd_w = hdd_width;           // 101.6mm
    hdd_l = hdd_length;          // 147mm
    hdd_h = hdd_height;          // 26.1mm

    rail_w = nas_2disk_rail_width;  // 2mm
    gap = nas_2disk_gap;            // 5mm
    wall = wall_thickness;          // 3mm
    padding = nas_2disk_padding;    // 2mm

    // Width of one "bay" (Rail + HDD + Rail)
    bay_w = nas_2disk_bay_width;    // ~105.6mm

    inner_w = nas_2disk_inner_width;  // ~216.2mm
    inner_l = hdd_l;
    inner_h = hdd_h;

    outer_w = nas_2disk_width;      // ~226mm (matches base case width)
    outer_l = inner_l + 2 * (wall + padding);
    outer_h = inner_h + wall + padding; // Open top (roofless design)

    // Offset to center/place items
    content_x = wall + padding;
    content_y = wall + padding;
    content_z = wall;

    // Feet dimensions (matching base case feet)
    foot_diameter = 15;
    foot_height = 8;
    foot_inset = 15;

    union() {
        // Feet (rubber bumper mounts at bottom of NAS enclosure)
        color("darkgray") {
            foot_positions = [
                [foot_inset, foot_inset],
                [outer_w - foot_inset, foot_inset],
                [foot_inset, outer_l - foot_inset],
                [outer_w - foot_inset, outer_l - foot_inset]
            ];

            for (pos = foot_positions) {
                translate([pos[0], pos[1], -foot_height]) {
                    cylinder(h = foot_height, d = foot_diameter, $fn = 30);
                }
            }
        }

        // The Enclosure Shell
        color("silver") {
            difference() {
                cube([outer_w, outer_l, outer_h]);
                
                // Cavity
                translate([wall, wall, wall]) {
                    cube([outer_w - 2*wall, outer_l - 2*wall, outer_h]);
                }

                // Front Openings for HDD insertion
                // Bay 1 Opening
                translate([content_x, -1, content_z]) {
                    cube([bay_w, wall + 2, inner_h]);
                }
                // Bay 2 Opening
                translate([content_x + bay_w + gap, -1, content_z]) {
                    cube([bay_w, wall + 2, inner_h]);
                }
            }
        }

        // The HDDs and Rails
        translate([content_x, content_y, content_z]) {
            // Bay 1
            union() {
                translate([0, 0, 5]) hdd_hotswap_rail_35();
                translate([rail_w, 0, 0]) hdd_3_5();
                translate([rail_w + hdd_w, 0, 5]) hdd_hotswap_rail_35();
            }
            
            // Bay 2
            translate([bay_w + gap, 0, 0]) {
                translate([0, 0, 5]) hdd_hotswap_rail_35();
                translate([rail_w, 0, 0]) hdd_3_5();
                translate([rail_w + hdd_w, 0, 5]) hdd_hotswap_rail_35();
            }
        }
    }
}
