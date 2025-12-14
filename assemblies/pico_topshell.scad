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

// Explode distance for viewing clearance
explode = 0;
show_ssd = true;
ssd_margin = 0;  // Clearance from interior walls

module pico_topshell_inspection() {
    union() {
        // === TOP PANEL (INTERIOR FACE UP) ===
        translate([0, 0, front_back_panel_height - wall_thickness]) top_panel_pico(with_ssd_divider = show_ssd);

        // === FRONT PANEL ===
        front_panel_width = front_back_panel_width + 2 * wall_thickness;
        translate([
            (exterior_panel_width - front_panel_width) / 2,
            -wall_thickness - explode,
            0
        ]) rotate([0,  0, 0]) front_panel_pico();

        // === LEFT SIDE PANEL ===
        translate([
            0 - explode,
            0,
            front_back_panel_height - (side_panel_height +explode)
        ]) side_panel_pico(side = "left", height = side_panel_height - wall_thickness);

        // === RIGHT SIDE PANEL ===
        translate([
            exterior_panel_width - wall_thickness + explode,
            0,
            front_back_panel_height - (side_panel_height + explode)
        ]) side_panel_pico(side = "right", height = side_panel_height - wall_thickness);

        // === SSDs in top-panel slots (visualization) ===
        // Positioned in pre-rotation coordinates; final transform flips view for inspection
        if (show_ssd) {
            ssd_z = front_back_panel_height - wall_thickness - ssd_2_5_height;  // Drives sit below top panel interior face

            // SSD 1: Back-left corner, lengthwise along X (left-right)
            // After rotate -90°: length along +X, width along -Y (extends backward from origin)
            ssd1_x = wall_thickness;  // Inset from left edge
            ssd1_y = exterior_panel_depth + wall_thickness - ssd_margin - 3 * wall_thickness;  // Origin at back edge, inset 3 wall thicknesses
            translate([ssd1_x, ssd1_y, ssd_z])
                rotate([0, 0, -90])
                ssd_2_5(body_color = "green");

            // SSD 2: Front-right corner, lengthwise along Y (front-back)
            // Default orientation: extends in +Y, so origin is at front edge
            ssd2_x = exterior_panel_width - ssd_margin - ssd_2_5_width;  // Near right edge
            ssd2_y = ssd_margin;  // Near front edge
            translate([ssd2_x, ssd2_y, ssd_z])
                ssd_2_5(body_color = "lightgray");  // Default orientation: length along +Y
        }
    }
}

// Render the inspection assembly
translate([exterior_panel_width, 0, front_back_panel_height]) rotate([180, 0, 180]) pico_topshell_inspection();
