// Shared dimensions for all case configurations
// This file defines common Mini-ITX parameters used across all configs
// Config-specific dimensions are in dimensions_minimal.scad and dimensions_pico.scad

// --- Wall and Material ---
wall_thickness = 3;

// --- Motherboard (Mini-ITX) ---
mobo_width = 170;
mobo_depth = 170;
mobo_pcb_thickness = 1.6;

// --- Standoffs ---
standoff_height = 6;  // Female thread portion of M3x10+6mm male-female standoff
standoff_hole_radius = 1.6;  // M3 clearance (deprecated - see integrated bottom panel design)
standoff_locations = [
    [6.35, 5],       // Front-left: 6.35mm from left, 5mm from front
    [163.65, 5],     // Front-right: 6.35mm from right, 5mm from front
    [6.35, 160],     // Back-left: 6.35mm from left, 10mm from back
    [163.65, 137]    // Back-right: 6.35mm from right, 33mm from back
];

// --- Standoff Hexagonal Receptacles (Integrated Bottom Panel Design) ---
standoff_boss_height = 2.5;              // Height of hex boss above panel interior surface
standoff_hex_size_flat_to_flat = 5;     // Hex size for standoff base (flat-to-flat)
standoff_hex_size_point_to_point = 6.35; // Hex size point-to-point (calculated from F-F)
standoff_pocket_depth = 2.2;             // Depth of hex recess for screw head
standoff_boss_diameter = 6.85;           // Overall boss diameter (hex point + FDM tolerance)
standoff_mounting_screw_length = 8;      // M3 x 8mm cap screw (recommended)
standoff_screw_clearance_hole = 3.3;     // M3 clearance hole + FDM tolerance

// --- I/O Shield ---
io_shield_width = 158.75;   // 6.25 inches (standard ATX)
io_shield_height = 44.45;   // 1.75 inches (standard ATX)
io_shield_x_offset = (mobo_width - io_shield_width) / 2;
io_shield_z_offset = 5;     // 5mm from bottom of plate

// --- Backplate ---
backplate_height = 88.9;    // 3.5 inches
backplate_thickness = wall_thickness;

// --- Ventilation ---
honeycomb_radius = 3;
vent_padding = 5;

// --- Screw Holes for Panel Assembly ---
panel_screw_radius = 1.6;  // M3
panel_screw_inset = 8;     // Distance from edge
