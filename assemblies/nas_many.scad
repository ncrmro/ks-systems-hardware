// NAS Many-Disk Configuration Assembly (5-8 drives)
// Base frame stacked on top of many-disk NAS enclosure
// Features active fan cooling for drives

include <../modules/case/dimensions.scad>

// Case parts
use <../modules/case/base/motherboard_plate.scad>
use <../modules/case/panels/standard/back.scad>
use <../modules/case/panels/standard/side_left.scad>
use <../modules/case/panels/standard/side_right.scad>
use <../modules/case/panels/standard/top.scad>
use <../modules/case/panels/standard/bottom.scad>
use <../modules/case/panels/standard/front.scad>
use <../modules/case/nas_many/frame.scad>

// Components
use <../modules/components/motherboard.scad>
use <../modules/components/power/psu_flex_atx.scad>

// Configuration
drive_count = 6;  // Number of drives (5-8)

// Toggle visibility for debugging
show_panels = true;
show_components = true;
show_nas_enclosure = true;
explode = 0;  // Set > 0 to explode view

module nas_many_assembly() {
    // NAS enclosure is much taller due to vertical drives
    // Height = HDD width (~102mm) + wall + padding
    nas_height = nas_many_enclosure_height;

    // Base offsets
    base_x = wall_thickness;
    base_y = wall_thickness;
    base_z = nas_height + wall_thickness;

    union() {
        // === NAS MANY-DISK ENCLOSURE (bottom) ===
        if (show_nas_enclosure) {
            translate([0, 0, -explode]) {
                case_nas_many(drive_count);
            }
        }

        // === CASE PANELS (base frame above NAS) ===
        if (show_panels) {
            // Bottom panel of base frame
            translate([0, 0, nas_height]) {
                bottom_panel();
            }

            // Motherboard plate
            translate([base_x, base_y, base_z + standoff_height]) {
                motherboard_plate();
            }

            // Back panel
            translate([base_x, mobo_depth + wall_thickness + explode, base_z]) {
                back_panel();
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
            translate([0, 0, nas_height + minimal_exterior_height - wall_thickness + explode]) {
                top_panel();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard with CPU cooler
            translate([base_x, base_y, base_z + standoff_height + wall_thickness]) {
                motherboard();
            }

            // Flex ATX PSU
            translate([mobo_width + wall_thickness * 2, base_y, base_z + standoff_height]) {
                power_supply_flex_atx();
            }
        }
    }
}

// Render the assembly
nas_many_assembly();
