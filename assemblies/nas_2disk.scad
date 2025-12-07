// NAS 2-Disk Configuration Assembly
// Base frame stacked on top of 2-disk NAS enclosure
// Uses passive chimney airflow: Intake -> HDDs -> Motherboard -> Heatsink -> Exhaust

include <../modules/case/dimensions.scad>

// Case parts
use <../modules/case/base/base_assembly.scad>
use <../modules/case/panels/standard/back.scad>
use <../modules/case/panels/standard/side_left.scad>
use <../modules/case/panels/standard/side_right.scad>
use <../modules/case/panels/standard/top.scad>
use <../modules/case/panels/standard/front.scad>
use <../modules/case/nas_2disk/frame.scad>
use <../modules/case/frame/frame_cylinder.scad>
use <../modules/case/frame/upper_frame.scad>

// Components
use <../modules/components/assemblies/motherboard.scad>
use <../modules/components/power/psu_flex_atx.scad>

// Toggle visibility for debugging
show_panels = true;
show_components = true;
show_nas_enclosure = true;
show_frame_cylinders = true;
show_upper_frame = true;
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
            // Base assembly (bottom panel + standoffs + feet)
            // Feet disabled - NAS enclosure provides feet at ground level
            translate([base_x, base_y, nas_top]) {
                base_assembly(show_feet = false);
            }

            // Frame cylinders (at standoff locations, on motherboard surface)
            if (show_frame_cylinders) {
                translate([base_x, base_y, nas_top + wall_thickness + standoff_height]) {
                    frame_cylinders();
                }
            }

            // Upper frame (holds frame cylinders, on motherboard surface)
            if (show_upper_frame) {
                translate([base_x, base_y, nas_top + wall_thickness + standoff_height]) {
                    upper_frame();
                }
            }

            // Back panel (at rear, full height starts at nas_top)
            translate([wall_thickness, mobo_depth + wall_thickness + explode, nas_top]) {
                back_panel();
            }

            // Front panel (full height, extended to cover sides, starts at nas_top)
            translate([0, -explode, nas_top]) {
                front_panel();
            }

            // Left side panel (full height, offset 3mm from front, starts at nas_top)
            translate([-explode, wall_thickness, nas_top]) {
                side_panel_left();
            }

            // Right side panel (full height, offset 3mm from front, starts at nas_top)
            translate([minimal_with_psu_width - wall_thickness + explode, wall_thickness, nas_top]) {
                side_panel_right();
            }

            // Top panel (interior dimensions, fits between walls)
            translate([wall_thickness, wall_thickness, nas_top + minimal_exterior_height + explode]) {
                top_panel();
            }
        }

        // === COMPONENTS ===
        if (show_components) {
            // Motherboard assembly (motherboard + RAM + CPU cooler, placed on standoffs)
            // Positioned at: nas_top + wall_thickness (panel) + standoff_height = ~40mm
            translate([base_x, base_y, nas_top + wall_thickness + standoff_height]) {
                motherboard_assembly();
            }

            // Flex ATX PSU (next to motherboard, rear face against backplate, centered vertically)
            translate([mobo_width + wall_thickness * 2, mobo_depth + wall_thickness - flex_atx_length, nas_top + (minimal_exterior_height - flex_atx_height) / 2]) {
                power_supply_flex_atx();
            }
        }
    }
}

// Render the assembly
nas_2disk_assembly();