use <../../components/storage/hdd_3_5.scad>
use <hotswap_rails.scad>

module case_nas_2x() {
    hdd_w = 101.6;
    hdd_l = 147;
    hdd_h = 26.1;
    
    rail_w = 5;
    
    gap = 5;
    wall = 3;
    padding = 2; // Clearance around HDDs

    // Width of one "bay" (Rail + HDD + Rail)
    bay_w = hdd_w + 2 * rail_w;

    inner_w = 2 * bay_w + gap;
    inner_l = hdd_l;
    inner_h = hdd_h;

    outer_w = inner_w + 2 * (wall + padding);
    outer_l = inner_l + 2 * (wall + padding);
    outer_h = inner_h + wall + padding; // Open top

    // Offset to center/place items
    content_x = wall + padding;
    content_y = wall + padding;
    content_z = wall;

    union() {
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
