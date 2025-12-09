// Minimal/NAS Configuration Dimensions
// Includes shared base dimensions and adds minimal/NAS-specific parameters

include <dimensions.scad>

// --- CPU Cooler (Noctua NH-L12S) - Minimal/NAS configurations ---
cooler_width = 128;
cooler_depth = 146;
cooler_base_height = 35;      // Base plate and heatpipes
cooler_fan_height = 15;       // 120mm x 15mm fan (NF-A12x15)
cooler_fins_height = 20;      // Heatsink fins on top
cooler_total_height = cooler_base_height + cooler_fan_height + cooler_fins_height;  // 70mm

// --- Power Supplies ---
// Flex ATX (from technical drawing)
// Standing orientation: 40mm wide (X), 150mm deep (Y), 80mm tall (Z)
flex_atx_width = 40.0;      // A: Width (X - thin side, standing)
flex_atx_length = 150.0;    // B: Length (Y - depth)
flex_atx_height = 80.0;     // G: Height (Z - tall side, standing)

// Flex ATX Mounting holes - 8-32 UNC thread (4 places on rear 40x80mm face)
flex_atx_mount_hole_radius = 2.1;   // 8-32 clearance (~4.2mm dia)
flex_atx_mount_x_inset = 5;         // Distance from left/right edges
flex_atx_mount_z_inset = 5;         // Distance from top/bottom edges

// Calculated mounting hole positions (X, Z pairs relative to PSU origin)
// Note: Only 3 holes - top-right (coords) removed where C14 inlet is located
flex_atx_mount_holes = [
    [flex_atx_mount_x_inset, flex_atx_mount_z_inset],
    [flex_atx_width - flex_atx_mount_x_inset, flex_atx_mount_z_inset],
    [flex_atx_mount_x_inset, flex_atx_height - flex_atx_mount_z_inset]
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
nas_2disk_rail_width = 2;
nas_2disk_gap = 5;
nas_2disk_padding = 2;
nas_2disk_bay_width = hdd_width + 2 * nas_2disk_rail_width;
nas_2disk_inner_width = 2 * nas_2disk_bay_width + nas_2disk_gap;
nas_2disk_width = nas_2disk_inner_width + 2 * (wall_thickness + nas_2disk_padding);

// --- PSU Compartment ---
flex_atx_standing_width = flex_atx_width;
psu_compartment_width = nas_2disk_width - mobo_width;

// --- Interior Chamber Height (standoffs + motherboard + cooler) ---
interior_chamber_height = standoff_height + mobo_pcb_thickness + cooler_total_height;

// --- Minimal Config External Dimensions ---
minimal_mobo_exterior_width = mobo_width + 2 * wall_thickness;
minimal_mobo_exterior_depth = mobo_depth + 2 * wall_thickness;
minimal_exterior_height = interior_chamber_height + 2 * wall_thickness;

// With Flex ATX PSU next to motherboard
minimal_with_psu_width = nas_2disk_width;

// --- Exterior Panel Dimensions (bottom/top panels span full width and cover back) ---
exterior_panel_width = minimal_with_psu_width;           // 226mm - full case width
exterior_panel_depth = mobo_depth + wall_thickness;      // 173mm - extends to cover back panel

// --- Interior Panel Dimensions (for reference) ---
interior_panel_width = minimal_with_psu_width - 2 * wall_thickness;  // 220mm
interior_panel_depth = mobo_depth;

// --- Side Panel Dimensions (left/right panels sit between top/bottom) ---
side_panel_height = minimal_exterior_height - 2 * wall_thickness;  // 94mm (shortened)
side_panel_depth = exterior_panel_depth + wall_thickness;          // 176mm - extends to cover back panel

// --- Back Panel Dimensions (sits between top/bottom, shortened height) ---
back_panel_height = side_panel_height;                   // 94mm (same as side panels)

// --- Front/Back Panel Dimensions ---
front_back_panel_width = interior_panel_width;
front_back_panel_height = minimal_exterior_height;  // Full height (unchanged)

// --- GPU ---
gpu_length = 320;
gpu_height = 140;
gpu_width = 60;

// --- GPU Config External Dimensions ---
gpu_config_width = 171;
gpu_config_depth = 378;
gpu_config_height = 190;

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
nas_many_drive_count = 6;
nas_many_drive_spacing = 5;
nas_many_enclosure_height = hdd_width + wall_thickness + 5;

// --- Power Inlet C14 ---
c14_width = 50;
c14_height = 27;
c14_depth = 30;

// --- Open Air Frame ---
frame_cylinder_height = interior_chamber_height - standoff_height - mobo_pcb_thickness;
frame_cylinder_outer_diameter = 8;
frame_cylinder_inner_diameter = 3.2;
frame_cylinder_thread_depth = 6;
