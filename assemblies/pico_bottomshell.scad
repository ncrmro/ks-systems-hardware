// Pico Bottom Shell Assembly - Inspection View
// Shows bottom shell components (bottom + back + sides) with bottom panel inverted
// Bottom panel inside faces UP for inspection of dovetails and standoff receptacles
//
// BOTTOM SHELL COMPONENTS:
// - Bottom panel (inverted - inside faces up)
// - Back panel
// - Left side panel
// - Right side panel
//
// This assembly allows inspection of:
// - Bottom panel female dovetail receptacles
// - Standoff mounting receptacles (hexagonal bosses)
// - Back panel male dovetails (bottom and side edges)
// - Side panel connections
// - Retention lip system geometry

include <../modules/case/dimensions_pico.scad>

// Panel modules
use <../modules/case/panels/standard/bottom_pico.scad>
use <../modules/case/panels/standard/back_pico.scad>
use <../modules/case/panels/standard/side_pico.scad>

// Explode distance for viewing clearance
explode = 0;

module pico_bottomshell_inspection() {
    union() {
        // === BOTTOM PANEL ===
        // Positioned at center of assembly, normal orientation
        // This shows the exterior face
        translate([exterior_panel_width / 2, exterior_panel_depth / 2 + wall_thickness, -wall_thickness]) {
            translate([-exterior_panel_width / 2, -exterior_panel_depth / 2, 0]) {
                bottom_panel_pico();
            }
        }

        // === BACK PANEL ===
        // Positioned at back edge (Y=exterior_panel_depth), flush with bottom panel
        // Shows male dovetails on bottom edge that connect to bottom panel
        translate([0, exterior_panel_depth + explode, 0]) {
            back_panel_pico();
        }

        // === LEFT SIDE PANEL ===
        // Positioned at left edge, flush with bottom panel
        // Shows female dovetails on back edge
        translate([-explode, wall_thickness, 0]) {
            side_panel_pico(side = "left", height = side_panel_height - wall_thickness);
        }

        // === RIGHT SIDE PANEL ===
        // Positioned at right edge, flush with bottom panel
        // Shows female dovetails on back edge
        translate([exterior_panel_width - wall_thickness + explode, wall_thickness, 0]) {
            side_panel_pico(side = "right", height = side_panel_height - wall_thickness);
        }
    }
}

// Render the inspection assembly
pico_bottomshell_inspection();
