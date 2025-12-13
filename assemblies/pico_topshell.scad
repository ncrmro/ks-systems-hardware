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

// Explode distance for viewing clearance
explode = 0;

module pico_topshell_inspection() {
    union() {
        // === TOP PANEL (INVERTED - inside faces UP) ===
        // Positioned at center of assembly, flipped 180° around Y axis
        // This shows the interior face with female dovetail receptacles
        translate([exterior_panel_width / 2, exterior_panel_depth / 2 + wall_thickness, -wall_thickness]) {
            rotate([0, 0, 0]) {
                translate([-exterior_panel_width / 2, -exterior_panel_depth / 2, 0]) {
                    top_panel_pico();
                }
            }
        }

        // === FRONT PANEL ===
        // Positioned at front edge (Y=0), below top panel
        // Shows male dovetails on top edge that connect to top panel
        translate([0, 0, -(front_back_panel_height + explode)]) {
            front_panel_pico();
        }

        // === LEFT SIDE PANEL ===
        // Positioned at left edge, below top panel
        // Shows male dovetails on top edge
        translate([-explode, wall_thickness, -(side_panel_height + 2 * wall_thickness + explode)]) {
            side_panel_pico(side = "left", height = side_panel_height - wall_thickness);
        }

        // === RIGHT SIDE PANEL ===
        // Positioned at right edge, below top panel
        // Shows male dovetails on top edge
        translate([exterior_panel_width - wall_thickness + explode, wall_thickness, -(side_panel_height + 2 * wall_thickness + explode)]) {
            side_panel_pico(side = "right", height = side_panel_height - wall_thickness);
        }
    }
}

// Render the inspection assembly
pico_topshell_inspection();
