// Component Inspection View - Minimal Configuration
// Displays individual components spread out for inspection
// See assemblies/minimal.scad for the complete assembled case

include <modules/case/dimensions_minimal.scad>

// Case parts
use <modules/case/base/motherboard_plate.scad>
use <modules/case/panels/standard/back.scad>

// Components
use <modules/components/assemblies/motherboard.scad>
use <modules/components/power/psu_sfx.scad>
use <modules/components/power/psu_flex_atx.scad>
use <modules/components/storage/hdd_3_5.scad>

// Spacing between components
spacing = 50;

// Rotate all to view from front
rotate([-90, 0, 0]) {
    // Row 1: Case parts
    translate([0, 0, 0]) {
        motherboard_plate();
    }

    translate([mobo_width + spacing, 0, 0]) {
        back_panel();
    }

    // Row 2: Motherboard assembly (with RAM and cooler)
    translate([0, -(mobo_depth + spacing), 0]) {
        motherboard_assembly();
    }

    // Row 3: Power supplies
    translate([0, -(mobo_depth + spacing) * 2, 0]) {
        power_supply_sfx();
    }

    translate([sfx_width + spacing, -(mobo_depth + spacing) * 2, 0]) {
        power_supply_flex_atx();
    }

    // Row 4: Storage
    translate([0, -(mobo_depth + spacing) * 3, 0]) {
        hdd_3_5();
    }

    translate([120, -(mobo_depth + spacing) * 3, 0]) {
        hdd_3_5();
    }
}
