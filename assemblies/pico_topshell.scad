// Pico Top Shell Assembly - Inspection View
// Shows top shell components (top + front + sides) with top panel inverted
// Top panel inside faces UP for inspection of dovetails and retention features
//
// TOP SHELL COMPONENTS:
// - Top panel (inverted - inside faces up)
// - Front panel
// - Left side panel
// - Right side panel
//
// This assembly allows inspection of:
// - Top panel female dovetail receptacles
// - Front panel male dovetails (top and bottom edges)
// - Side panel male dovetails (top edge)
// - Retention lip geometry
// - Panel-to-panel alignment features

include <../modules/case/dimensions_pico.scad>

// Panel modules
use <../modules/case/panels/standard/top_pico.scad>
use <../modules/case/panels/standard/front_pico.scad>
use <../modules/case/panels/standard/side_pico.scad>
include <../modules/components/storage/ssd_2_5.scad> // include to access dimension vars

// Default values for standalone preview
explode = 0;
show_ssd = true;
ssd_margin = 0;  // Clearance from interior walls

module pico_topshell(
    explode_distance = 0,
    with_ssd = true,
    with_front = true,
    with_left_side = true,
    with_right_side = true,
    with_top = true,
    mode = "inspection"  // "inspection" (default) or "assembly" (for pico.scad)
) {
    // Mode-dependent positioning:
    // - inspection: coordinates for inverted view (interior faces up)
    // - assembly: coordinates matching pico.scad (for full case assembly)
    is_assembly = (mode == "assembly");

    union() {
        // === TOP PANEL ===
        if (with_top) {
            top_z = is_assembly
                ? pico_exterior_height - wall_thickness + explode_distance
                : front_back_panel_height - wall_thickness + explode_distance;
            top_y = is_assembly ? wall_thickness : 0;
            translate([0, top_y, top_z])
                top_panel_pico(with_ssd_divider = with_ssd);
        }

        // === FRONT PANEL ===
        if (with_front) {
            front_panel_width = front_back_panel_width + 2 * wall_thickness;
            front_y = is_assembly ? -explode_distance : -wall_thickness - explode_distance;
            translate([
                (exterior_panel_width - front_panel_width) / 2,
                front_y,
                0
            ]) front_panel_pico(with_ssd_harness = with_ssd);
        }

        // === LEFT SIDE PANEL ===
        if (with_left_side) {
            side_y = is_assembly ? wall_thickness : 0;
            side_z = is_assembly ? wall_thickness : front_back_panel_height - side_panel_height - explode_distance;
            side_height = is_assembly ? side_panel_height : side_panel_height - wall_thickness;
            translate([
                0 - explode_distance,
                side_y,
                side_z
            ]) side_panel_pico(side = "left", height = side_height, with_ssd_harness = with_ssd);
        }

        // === RIGHT SIDE PANEL ===
        if (with_right_side) {
            side_y = is_assembly ? wall_thickness : 0;
            side_z = is_assembly ? wall_thickness : front_back_panel_height - side_panel_height - explode_distance;
            side_height = is_assembly ? side_panel_height : side_panel_height - wall_thickness;
            translate([
                exterior_panel_width - wall_thickness + explode_distance,
                side_y,
                side_z
            ]) side_panel_pico(side = "right", height = side_height, with_ssd_harness = with_ssd);
        }

        // === SSDs in top-panel slots (visualization) ===
        if (with_ssd) {
            // Z position adjusted for mode
            ssd_z_base = is_assembly
                ? pico_exterior_height - wall_thickness - ssd_2_5_height
                : front_back_panel_height - wall_thickness - ssd_2_5_height;
            ssd_y_offset = is_assembly ? wall_thickness : 0;

            // SSD 1: Back-left corner, lengthwise along X (left-right)
            ssd1_x = wall_thickness;
            ssd1_y = exterior_panel_depth + wall_thickness - ssd_margin - 2 * wall_thickness + ssd_y_offset;
            translate([ssd1_x, ssd1_y, ssd_z_base])
                rotate([0, 0, -90])
                ssd_2_5(body_color = "green");

            // SSD 2: Front-right corner, lengthwise along Y (front-back)
            // Positioned against left lip (divider_x + wall_thickness)
            ssd2_x = ssd_2_5_length + wall_thickness + 3;  // 100mm + 3mm + 3mm offset
            ssd2_y = ssd_margin + ssd_y_offset;
            translate([ssd2_x, ssd2_y, ssd_z_base])
                ssd_2_5(body_color = "lightgray");
        }
    }
}

// Legacy module for inspection view (inverted)
module pico_topshell_inspection() {
    pico_topshell(explode_distance = explode, with_ssd = show_ssd);
}

// Render the inspection assembly
translate([exterior_panel_width, 0, front_back_panel_height]) {
    rotate([180, 0, 180]) {
        pico_topshell_inspection();
    }
}
