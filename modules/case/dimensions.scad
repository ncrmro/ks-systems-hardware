// Shared dimensions for all case components
// This file defines common parameters used across multiple case parts

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
    [12.7, 12.7],
    [165.1, 12.7],
    [12.7, 165.1],
    [165.1, 165.1]
];

// --- Standoff Hexagonal Receptacles (Integrated Bottom Panel Design) ---
standoff_boss_height = 2.5;              // Height of hex boss above panel interior surface
standoff_hex_size_flat_to_flat = 5.5;   // Hex size for M3 screw head (flat-to-flat)
standoff_hex_size_point_to_point = 6.35; // Hex size point-to-point (calculated from F-F)
standoff_pocket_depth = 2.2;             // Depth of hex recess for screw head
standoff_boss_diameter = 6.85;           // Overall boss diameter (hex point + FDM tolerance)
standoff_mounting_screw_length = 8;      // M3 x 8mm cap screw (recommended)
standoff_screw_clearance_hole = 3.3;     // M3 clearance hole + FDM tolerance

// --- I/O Shield ---
// Standard ATX I/O shield dimensions
io_shield_width = 158.75;   // 6.25 inches (standard ATX)
io_shield_height = 44.45;   // 1.75 inches (standard ATX)
io_shield_x_offset = (mobo_width - io_shield_width) / 2;
io_shield_z_offset = 5;     // 5mm from bottom of plate

// --- Backplate ---
backplate_height = 88.9;    // 3.5 inches
backplate_thickness = wall_thickness;

// --- CPU Cooler (Noctua NH-L12S) - Minimal/NAS configurations ---
cooler_width = 128;
cooler_depth = 146;
cooler_base_height = 35;      // Base plate and heatpipes
cooler_fan_height = 15;       // 120mm x 15mm fan (NF-A12x15)
cooler_fins_height = 20;      // Heatsink fins on top
cooler_total_height = cooler_base_height + cooler_fan_height + cooler_fins_height;  // 70mm

// --- CPU Cooler (Noctua NH-L9) - Pico configuration ---
cooler_nh_l9_width = 95;
cooler_nh_l9_depth = 95;
cooler_nh_l9_base_height = 5;       // CPU contact base
cooler_nh_l9_heatsink_height = 18;  // Aluminum fins
cooler_nh_l9_fan_height = 14;       // 92mm x 14mm fan
cooler_nh_l9_total_height = cooler_nh_l9_base_height + cooler_nh_l9_heatsink_height + cooler_nh_l9_fan_height;  // 37mm

// --- Power Supplies ---
// Flex ATX (from technical drawing)
// Standing orientation: 40mm wide (X), 150mm deep (Y), 80mm tall (Z)
flex_atx_width = 40.0;      // A: Width (X - thin side, standing)
flex_atx_length = 150.0;    // B: Length (Y - depth)
flex_atx_height = 80.0;     // G: Height (Z - tall side, standing)

// Flex ATX Mounting holes - 8-32 UNC thread (4 places on rear 40x80mm face)
flex_atx_mount_hole_radius = 2.1;   // 8-32 clearance (~4.2mm dia)
flex_atx_mount_x_inset = 5;         // Distance from left/right edges (corrected from 12.5)
flex_atx_mount_z_inset = 5;         // Distance from top/bottom edges (corrected from 8.25)

// Calculated mounting hole positions (X, Z pairs relative to PSU origin)
// Note: Only 3 holes - top-right (coords) removed where C14 inlet is located
// When viewing from back: top-right (coords) = top-left (view)
flex_atx_mount_holes = [
    [flex_atx_mount_x_inset, flex_atx_mount_z_inset],                                    // Bottom-left (coords) = Bottom-right (view)
    [flex_atx_width - flex_atx_mount_x_inset, flex_atx_mount_z_inset],                   // Bottom-right (coords) = Bottom-left (view)
    [flex_atx_mount_x_inset, flex_atx_height - flex_atx_mount_z_inset]                   // Top-left (coords) = Top-right (view)
    // Top-right (coords) removed - C14 power inlet is here = Top-left (view)
];

// SFX
sfx_length = 125;
sfx_width = 100;
sfx_height = 63.5;

// --- HDD 3.5" Dimensions ---
hdd_width = 101.6;
hdd_length = 147;
hdd_height = 26.1;

// --- NAS 2-Disk Config ---
// 2 HDDs side-by-side (controlling dimension for case width)
// See SPEC.md Section 3.3 for design rationale
nas_2disk_rail_width = 2;
nas_2disk_gap = 5;           // Gap between bays
nas_2disk_padding = 2;       // Clearance around HDDs
nas_2disk_bay_width = hdd_width + 2 * nas_2disk_rail_width;  // ~105.6mm per bay
nas_2disk_inner_width = 2 * nas_2disk_bay_width + nas_2disk_gap;  // ~216.2mm
nas_2disk_width = nas_2disk_inner_width + 2 * (wall_thickness + nas_2disk_padding);  // ~226mm

// --- PSU Compartment ---
// Flex ATX PSU in standing orientation (40mm width)
flex_atx_standing_width = flex_atx_width;  // 40mm (already in standing orientation)
psu_compartment_width = nas_2disk_width - mobo_width;  // ~56mm (40mm PSU + 16mm clearance)

// --- Interior Chamber Height (standoffs + motherboard + cooler) ---
interior_chamber_height = standoff_height + mobo_pcb_thickness + cooler_total_height;  // ~94mm

// --- Minimal Config External Dimensions ---
// Motherboard area only (without PSU)
minimal_mobo_exterior_width = mobo_width + 2 * wall_thickness;   // 176mm
minimal_mobo_exterior_depth = mobo_depth + 2 * wall_thickness;   // 176mm
minimal_exterior_height = interior_chamber_height + 2 * wall_thickness;   // ~100mm

// With Flex ATX PSU next to motherboard
// Width controlled by NAS 2-disk HDD layout (see SPEC.md Section 3.3)
minimal_with_psu_width = nas_2disk_width;  // ~226mm (PSU compartment = 56mm, PSU on side = 40mm)

// --- Interior Panel Dimensions (top/bottom panels fit between walls) ---
interior_panel_width = minimal_with_psu_width - 2 * wall_thickness;  // ~220mm
interior_panel_depth = mobo_depth;                                    // 170mm

// --- Side Panel Dimensions (left/right panels form exterior walls) ---
side_panel_height = minimal_exterior_height;                          // ~100mm
side_panel_depth = mobo_depth + 2 * wall_thickness;                   // 176mm

// --- Front/Back Panel Dimensions (fit between side walls, full exterior height) ---
front_back_panel_width = interior_panel_width;                        // ~220mm
front_back_panel_height = side_panel_height;                          // ~100mm (full exterior)

// --- Ventilation ---
honeycomb_radius = 3;
vent_padding = 5;

// --- Screw Holes for Panel Assembly ---
panel_screw_radius = 1.6;  // M3
panel_screw_inset = 8;     // Distance from edge

// --- GPU ---
gpu_length = 320;          // Max GPU length
gpu_height = 140;          // GPU PCB + cooler height
gpu_width = 60;            // 3 slots

// --- GPU Config External Dimensions ---
// From SPEC.md Section 8.4
gpu_config_width = 171;    // mm
gpu_config_depth = 378;    // mm
gpu_config_height = 190;   // mm

// --- Fans ---
fan_120_size = 120;
fan_120_thickness = 25;
fan_140_size = 140;
fan_140_thickness = 25;

// --- AIO Radiator ---
radiator_240_length = 275;
radiator_240_width = 120;
radiator_240_thickness = 27;

// --- NAS Many-Disk Config ---
// 5-8 drives mounted vertically (on narrowest side)
nas_many_drive_count = 6;  // Default 6 drives
nas_many_drive_spacing = 5;
nas_many_enclosure_height = hdd_width + wall_thickness + 5;  // ~110mm (drives on side)

// --- Power Inlet C14 ---
c14_width = 50;
c14_height = 27;
c14_depth = 30;

// --- Open Air Frame ---
// Frame cylinder height (from motherboard surface to inside panel face)
// Derived: interior_chamber_height - standoff_height - mobo_pcb_thickness
frame_cylinder_height = interior_chamber_height - standoff_height - mobo_pcb_thickness;  // ~86mm
frame_cylinder_outer_diameter = 8;     // Outer diameter
frame_cylinder_inner_diameter = 3.2;   // M3 clearance for standoff stud
frame_cylinder_thread_depth = 6;       // Matches extended_standoff_male_height (M3x6+6mm)
