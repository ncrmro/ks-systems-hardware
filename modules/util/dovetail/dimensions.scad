// Dovetail Joint Dimensions
// Shared parameters for male and female dovetail modules
// Per SPEC.md Section 9.3-9.5

// Dovetail geometry parameters
dovetail_angle = 15;              // Angle from vertical (degrees)
dovetail_height = 3;              // Trapezoid height / engagement depth (mm)
dovetail_length = 20;             // Length along panel edge (mm)
dovetail_base_width = 8;          // Width at narrow end (mm)
dovetail_clearance = 0.15;        // Clearance per side (mm) - FDM tuned

// Boss parameters (raised sections for female dovetails)
dovetail_boss_margin = 3;         // Extra wall around dovetail channel

// Center-slot latch parameters (integrated snap-fit retention)
center_slot_width = 3;            // Flex gap width (mm)
center_slot_end_margin = 6;       // Solid material at base end of slot (mm)

// Catch bump parameters (ramped profile on outer dovetail faces)
catch_bump_height = 0.8;          // Protrusion from dovetail surface (mm)
catch_bump_length = 3;            // Plateau length along insertion direction (mm)
catch_ramp_length = 2;            // Entry/exit ramp length (mm)

// Female window parameters
window_clearance = 0.10;          // Clearance around catch in recess (mm) - tightened for less play

// Scale factor for prototyping (1.0 = actual size)
dovetail_scale_factor = 1.0;

// Scaled dimensions (computed)
scaled_dovetail_height = dovetail_height * dovetail_scale_factor;
scaled_dovetail_length = dovetail_length * dovetail_scale_factor;
scaled_dovetail_base_width = dovetail_base_width * dovetail_scale_factor;
scaled_clearance = dovetail_clearance * dovetail_scale_factor;
scaled_boss_margin = dovetail_boss_margin * dovetail_scale_factor;
scaled_slot_width = center_slot_width * dovetail_scale_factor;
scaled_slot_end_margin = center_slot_end_margin * dovetail_scale_factor;
scaled_catch_height = catch_bump_height * dovetail_scale_factor;
scaled_catch_length = catch_bump_length * dovetail_scale_factor;
scaled_catch_ramp_length = catch_ramp_length * dovetail_scale_factor;
scaled_window_clearance = window_clearance * dovetail_scale_factor;
