// Pico Configuration Dimensions
// Ultra-compact case using Pico ATX PSU and NH-L9 cooler
// This is a STANDALONE dimension file - does not include base dimensions.scad
//
// Case dimensions: 176mm x 176mm x ~52mm (1.6L volume)
// No PSU compartment (Pico ATX is on-board with external AC adapter)

// === COPIED FROM BASE dimensions.scad ===

// --- Wall and Material ---
wall_thickness = 3;

// --- Motherboard (Mini-ITX) ---
mobo_width = 170;
mobo_depth = 170;
mobo_pcb_thickness = 1.6;

// --- Standoffs ---
standoff_height = 6;  // Female thread portion of M3x10+6mm male-female standoff
standoff_hole_radius = 1.6;  // M3 clearance
standoff_locations = [
    [12.7, 12.7],
    [165.1, 12.7],
    [12.7, 165.1],
    [165.1, 165.1]
];

// --- Standoff Hexagonal Receptacles (Integrated Bottom Panel Design) ---
standoff_boss_height = 2.5;
standoff_hex_size_flat_to_flat = 5.5;
standoff_hex_size_point_to_point = 6.35;
standoff_pocket_depth = 2.2;
standoff_boss_diameter = 6.85;
standoff_mounting_screw_length = 8;
standoff_screw_clearance_hole = 3.3;

// --- I/O Shield ---
io_shield_width = 158.75;
io_shield_height = 44.45;
io_shield_x_offset = (mobo_width - io_shield_width) / 2;
io_shield_z_offset = 5;

// --- Ventilation ---
honeycomb_radius = 3;
vent_padding = 5;

// --- Screw Holes for Panel Assembly ---
panel_screw_radius = 1.6;  // M3
panel_screw_inset = 8;

// === PICO-SPECIFIC DIMENSIONS ===

// --- Pico Case Dimensions ---
pico_case_width = mobo_width + 2 * wall_thickness;   // 176mm (minimal, no PSU compartment)
pico_case_depth = mobo_depth + 2 * wall_thickness;   // 176mm

// --- NH-L9 CPU Cooler (Noctua NH-L9i/NH-L9a) ---
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
// Interior panels (fit between walls)
interior_panel_width = pico_case_width - 2 * wall_thickness;    // 170mm
interior_panel_depth = pico_case_depth - 2 * wall_thickness;    // 170mm

// Front/back panels (between side walls)
front_back_panel_width = interior_panel_width;   // 170mm
front_back_panel_height = pico_exterior_height;  // ~52mm

// Side panels (exterior walls)
side_panel_height = pico_exterior_height;        // ~52mm
side_panel_depth = pico_case_depth;              // 176mm

// --- Pico PSU (Barrel Jack on Back Panel) ---
pico_barrel_jack_x = interior_panel_width - 40;  // 130mm from left (right side)
pico_barrel_jack_z = pico_exterior_height / 2;   // ~26mm (centered vertically)
pico_barrel_jack_diameter = 8;                   // 8mm hole for 5.5x2.5mm barrel jack
