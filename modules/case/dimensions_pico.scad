// Pico Configuration Dimensions
// Ultra-compact case using Pico ATX PSU and NH-L9 cooler
// Case dimensions: 176mm x 176mm x ~63mm
// No PSU compartment (Pico ATX is on-board with external AC adapter)

include <dimensions.scad>

// --- Pico Case Dimensions ---
pico_case_width = mobo_width + 2 * wall_thickness;   // 176mm (minimal, no PSU compartment)
pico_case_depth = mobo_depth + 2 * wall_thickness;   // 176mm

// --- CPU Cooler (Noctua NH-L9i/NH-L9a) ---
cooler_nh_l9_width = 95;
cooler_nh_l9_depth = 95;
cooler_nh_l9_base_height = 5;
cooler_nh_l9_heatsink_height = 18;
cooler_nh_l9_fan_height = 14;
cooler_nh_l9_total_height = cooler_nh_l9_base_height + cooler_nh_l9_heatsink_height + cooler_nh_l9_fan_height;  // 37mm

// --- Pico Interior Chamber Height ---
// Must accommodate the TALLER of: CPU cooler or I/O shield
pico_min_height_for_cooler = standoff_height + mobo_pcb_thickness + cooler_nh_l9_total_height;  // ~45.6mm
pico_min_height_for_io = standoff_height + mobo_pcb_thickness + io_shield_z_offset + io_shield_height;  // ~57mm
pico_interior_chamber_height = pico_min_height_for_io;  // Use I/O shield as controlling dimension (~57mm)
pico_exterior_height = pico_interior_chamber_height + 2 * wall_thickness;  // ~63mm

// --- Panel Dimensions (standard variable names for panels to use) ---
// Exterior panels (bottom/top span full width and cover back)
exterior_panel_width = pico_case_width;                          // 176mm - full case width
exterior_panel_depth = pico_case_depth - wall_thickness;         // 173mm - extends to cover back panel

// Interior panels (for reference)
interior_panel_width = pico_case_width - 2 * wall_thickness;    // 170mm
interior_panel_depth = pico_case_depth - 2 * wall_thickness;    // 170mm

// Front/back panels (between side walls, full height)
front_back_panel_width = interior_panel_width;   // 170mm
front_back_panel_height = pico_exterior_height;  // ~63mm (unchanged)

// Side panels (sit between top/bottom panels)
side_panel_height = pico_exterior_height - 2 * wall_thickness;  // ~57mm (shortened)
side_panel_depth = exterior_panel_depth + wall_thickness;       // 176mm - extends to cover back panel

// Back panel height (shortened, sits between top/bottom)
back_panel_height = side_panel_height;                          // ~57mm (same as side panels)

// --- Pico PSU (Barrel Jack on Back Panel) ---
// Barrel jack position is relative to the shortened back panel (which is raised by wall_thickness)
pico_barrel_jack_x = interior_panel_width - 40;  // 130mm from left (right side)
pico_barrel_jack_z = (pico_exterior_height / 2) - wall_thickness;  // ~28mm (centered in case, adjusted for raised panel)
pico_barrel_jack_diameter = 8;                   // 8mm hole for 5.5x2.5mm barrel jack
