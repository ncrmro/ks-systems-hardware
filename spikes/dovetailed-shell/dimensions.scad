// Shared Dimensions for Dovetailed Shell
// Include this file to access all dimension variables

// Panel dimensions
panel_width = 100;           // X dimension
panel_depth = 20;           // Y dimension
panel_height = 20;          // Z dimension (for vertical panels)
top_panel_thickness = 3;     // Top/bottom panel thickness (same as wall)
wall_panel_thickness = 3;    // Side/front/back panel thickness

// Dovetail parameters
dovetail_angle = 15;         // Angle from vertical (degrees)
dovetail_height = 3;         // Trapezoid height (mm)
dovetail_length = 10;        // Length along edge (mm)
dovetail_base_width = 8;     // Width at narrow end (mm)
dovetail_clearance = 0.15;   // Clearance per side (mm) - reduced from 0.3 to fix loose fit
dovetail_edge_inset = 3;     // Inset from panel edge (mm)

// Boss parameters (raised sections for female dovetails)
dovetail_boss_height = dovetail_height;  // Boss height = channel depth
dovetail_boss_margin = 2;                // Extra wall around dovetail channel

// Center-slot latch parameters (integrated snap-fit retention)
// Slot runs through center of dovetail, allowing squeeze-to-insert/release
center_slot_width = 5;          // mm - flex gap width
center_slot_end_margin = 2;       // mm - solid material at each end of slot

// Catch bump parameters (ramped profile on outer dovetail faces)
catch_bump_height = 0.8;          // mm - protrusion from dovetail surface
catch_bump_length = 3;            // mm - length along insertion direction
catch_ramp_angle = 35;            // degrees - entry ramp angle
catch_ramp_length = 2;            // mm - length of entry ramp
catch_retention_length = 1;       // mm - vertical retention face length
catch_position_from_end = 2;      // mm - catch position from free end

// Female window parameters (external access for release)
window_clearance = 0.3;           // mm - clearance around catch
window_finger_depth = 5;          // mm - depth for finger access to squeeze

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
scaled_boss_height = dovetail_boss_height * scale_factor;
scaled_boss_margin = dovetail_boss_margin * scale_factor;

// Scaled center-slot latch parameters
scaled_slot_width = center_slot_width * scale_factor;
scaled_slot_end_margin = center_slot_end_margin * scale_factor;
scaled_catch_height = catch_bump_height * scale_factor;
scaled_catch_length = catch_bump_length * scale_factor;
scaled_catch_ramp_length = catch_ramp_length * scale_factor;
scaled_catch_retention_length = catch_retention_length * scale_factor;
scaled_catch_position = catch_position_from_end * scale_factor;
scaled_window_clearance = window_clearance * scale_factor;
scaled_window_depth = window_finger_depth * scale_factor;
