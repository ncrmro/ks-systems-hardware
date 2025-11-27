// NAS Many-Disk Enclosure Frame (5-8 drives)
// Drives mounted vertically (on narrowest side - 26.1mm)
// Features dedicated fan cooling

include <../dimensions.scad>
use <../../components/storage/hdd_3_5.scad>
use <../../components/cooling/fan_120.scad>

module case_nas_many(drive_count = 6) {
    // Drive dimensions when vertical (on narrowest side)
    drive_width = hdd_height;      // 26.1mm - now horizontal
    drive_depth = hdd_length;      // 147mm
    drive_height = hdd_width;      // 101.6mm - now vertical

    spacing = nas_many_drive_spacing;
    wall = wall_thickness;
    padding = 3;

    // Calculate enclosure dimensions
    inner_width = drive_count * drive_width + (drive_count - 1) * spacing;
    inner_depth = drive_depth + fan_120_thickness + 10;  // Room for fan
    inner_height = drive_height;

    outer_width = inner_width + 2 * (wall + padding);
    outer_depth = inner_depth + 2 * wall;
    outer_height = inner_height + wall + padding;

    // Content positioning
    content_x = wall + padding;
    content_y = wall;
    content_z = wall;

    union() {
        // Enclosure shell
        color("silver") {
            difference() {
                cube([outer_width, outer_depth, outer_height]);

                // Main cavity
                translate([wall, wall, wall]) {
                    cube([outer_width - 2*wall, outer_depth - 2*wall, outer_height]);
                }

                // Front openings for each drive bay
                for (i = [0 : drive_count - 1]) {
                    bay_x = content_x + i * (drive_width + spacing);
                    translate([bay_x, -1, content_z]) {
                        cube([drive_width, wall + 2, inner_height]);
                    }
                }

                // Rear fan mount opening (120mm)
                fan_x = (outer_width - fan_120_size) / 2;
                fan_z = (outer_height - fan_120_size) / 2;
                translate([fan_x, outer_depth - wall - 1, fan_z]) {
                    cube([fan_120_size, wall + 2, fan_120_size]);
                }
            }
        }

        // HDDs (vertical orientation)
        translate([content_x, content_y + padding, content_z]) {
            for (i = [0 : drive_count - 1]) {
                translate([i * (drive_width + spacing), 0, 0]) {
                    // Rotate HDD to stand on its narrow side
                    rotate([0, -90, 0]) {
                        translate([-drive_height, 0, -drive_width]) {
                            hdd_3_5();
                        }
                    }
                }
            }
        }

        // Rear exhaust fan
        color("dimgray") {
            translate([(outer_width - fan_120_size) / 2, outer_depth - wall - fan_120_thickness, (outer_height - fan_120_size) / 2]) {
                rotate([90, 0, 0]) {
                    rotate([0, 0, 0]) {
                        // Simplified fan representation
                        cube([fan_120_size, fan_120_size, fan_120_thickness]);
                    }
                }
            }
        }
    }
}

// Preview with 6 drives
case_nas_many(6);
