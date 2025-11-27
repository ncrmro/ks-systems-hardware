// NAS 2-Disk Configuration Assembly
// Base frame stacked on top of 2-disk NAS enclosure
// Uses passive chimney airflow: Intake -> HDDs -> Motherboard -> Heatsink -> Exhaust

include <../modules/case/dimensions.scad>

// Case parts
use <../modules/case/base/motherboard_plate.scad>
use <../modules/case/base/backplate_io.scad>
use <../modules/case/panels/standard/side_left.scad>
use <../modules/case/panels/standard/side_right.scad>
use <../modules/case/panels/standard/top.scad>
use <../modules/case/panels/standard/bottom.scad>
use <../modules/case/panels/standard/front.scad>
use <../modules/case/nas_2disk/frame.scad>

// Components
use <../modules/components/motherboard.scad>
use <../modules/components/power/psu_flex_atx.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
show_nas_enclosure = true;
explode = 0;  // Set > 0 to explode view (e.g., 30)

// NAS enclosure dimensions (from frame.scad)
nas_hdd_height = 26.1;
nas_wall = 3;
nas_padding = 2;
nas_enclosure_height = nas_hdd_height + nas_wall + nas_padding;  // ~31mm

module nas_2disk_assembly() {
    // Base offsets - motherboard chamber sits above NAS enclosure
    base_x = wall_thickness;
    base_y = wall_thickness;
    nas_top = nas_enclosure_height;  // Z where base frame starts
    base_z = nas_top + wall_thickness;

    union() {
        // === NAS ENCLOSURE (bottom) ===
        if (show_nas_enclosure) {
            translate([0, 0, -explode]) {
                case_nas_2x();
            }
        }

        // === CASE PANELS (base frame above NAS) ===
        if (show_panels) {
            // Bottom panel of base frame (sits on top of NAS enclosure)
            translate([0, 0, nas_top]) {
                bottom_panel();
            }

            // Motherboard plate (raised by standoff height)
            translate([base_x, base_y, base_z + standoff_height]) {
                motherboard_plate();
            }

            // I/O Backplate (at rear)
            translate([base_x, mobo_depth + wall_thickness + explode, base_z]) {
                backplate_io();
            }

            // Front panel
            translate([0, -explode, base_z]) {
                front_panel();
            }

            // Left side panel
            translate([-explode, 0, base_z]) {
                side_panel_left();
            }

            // Right side panel
            translate([minimal_with_psu_width - wall_thickness + explode, 0, base_z]) {
                side_panel_right();
            }

            // Top panel
            translate([0, 0, nas_top + minimal_exterior_height - wall_thickness + explode]) {
                top_panel();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard with CPU cooler (placed on standoffs)
            translate([base_x, base_y, base_z + standoff_height + wall_thickness]) {
                motherboard();
            }

            // Flex ATX PSU (next to motherboard)
            translate([mobo_width + wall_thickness * 2, base_y, base_z + standoff_height]) {
                power_supply_flex_atx();
            }
        }
    }
}

// Render the assembly
nas_2disk_assembly();
