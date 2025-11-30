// NAS 2-Disk Component Inspection View
// Displays NAS configuration components for inspection
// See assemblies/nas_2disk.scad for the complete assembled case

include <modules/case/dimensions.scad>

// Case parts
use <modules/case/base/motherboard_plate.scad>
use <modules/case/panels/standard/back.scad>
use <modules/case/nas_2disk/frame.scad>

// Components
use <modules/components/assemblies/motherboard.scad>
use <modules/components/power/psu_flex_atx.scad>

// Spacing between components
spacing = 30;

// NAS enclosure height
nas_enclosure_height = 31;  // Approx from frame.scad

// Rotate all to view from front
rotate([-90, 0, 0]) {
    // Base case plate + backplate
    translate([0, 0, 0]) {
        motherboard_plate();
        translate([0, mobo_depth + 10, 0]) {
            back_panel();
        }
    }

    // Motherboard assembly (raised above NAS enclosure)
    translate([0, -(mobo_depth + spacing), nas_enclosure_height + standoff_height]) {
        motherboard_assembly();
    }

    // Flex ATX PSU (next to motherboard area)
    translate([mobo_width + spacing, -(mobo_depth + spacing), nas_enclosure_height]) {
        power_supply_flex_atx();
    }

    // NAS 2-disk enclosure (underneath motherboard)
    translate([0, -(mobo_depth + spacing), 0]) {
        case_nas_2x();
    }
}
