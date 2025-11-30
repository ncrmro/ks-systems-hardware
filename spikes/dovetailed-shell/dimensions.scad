// Shared Dimensions for Dovetailed Shell
// Include this file to access all dimension variables

// Panel dimensions
panel_width = 100;           // X dimension
panel_depth = 100;           // Y dimension
panel_height = 100;          // Z dimension (for vertical panels)
top_panel_thickness = 6;     // Top/bottom panel thickness
wall_panel_thickness = 3;    // Side/front/back panel thickness

// Dovetail parameters
dovetail_angle = 50;         // Angle from vertical (degrees)
dovetail_height = 3;         // Trapezoid height (mm)
dovetail_length = 30;        // Length along edge (mm)
dovetail_base_width = 8;     // Width at narrow end (mm)
dovetail_clearance = 0.3;    // Clearance per side (mm)
dovetail_edge_inset = 3;     // Inset from panel edge (mm)

// Scale factor for prototyping
scale_factor = 1.0;

// Scaled dimensions (computed)
scaled_width = panel_width * scale_factor;
scaled_depth = panel_depth * scale_factor;
scaled_height = panel_height * scale_factor;
scaled_top_thickness = top_panel_thickness * scale_factor;
scaled_wall_thickness = wall_panel_thickness * scale_factor;
scaled_dovetail_height = dovetail_height * scale_factor;
scaled_dovetail_length = dovetail_length * scale_factor;
scaled_dovetail_base_width = dovetail_base_width * scale_factor;
scaled_clearance = dovetail_clearance * scale_factor;
