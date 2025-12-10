// Base Assembly Dovetail Test - Pico Configuration
// Verifies dovetail fit between bottom panel and back panel for Pico config
// Per SPEC.md Section 9.6 - Base Assembly (Back + Bottom)

include <../modules/case/dimensions_pico.scad>
use <../modules/case/panels/standard/bottom_pico.scad>
use <../modules/case/panels/standard/back_pico.scad>

// Toggle to show exploded view
explode = false;
explode_distance = 20;  // Distance to separate panels in exploded view

// Bottom panel at origin
// Female dovetails on back edge, bosses extend +Z
bottom_panel_pico();

// Back panel positioned on top of bottom panel
// Male dovetails on bottom edge engage with female channels
// Back panel sits at Y = exterior_panel_depth, Z = wall_thickness
translate([
    wall_thickness,                              // X: inset by wall_thickness
    exterior_panel_depth + (explode ? explode_distance : 0),  // Y: at back edge of bottom panel
    wall_thickness                               // Z: sits on top of bottom panel
])
    back_panel_pico();
