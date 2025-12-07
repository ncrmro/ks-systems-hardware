// Base assembly: bottom panel + standoffs + feet
// This is the foundation that all case configurations build upon
//
// Components:
// - Bottom panel with integrated standoff receptacles (hexagonal recesses)
// - Extended standoffs (M3x10+6mm male-female) positioned in receptacles
// - Rubber feet (optional, screw into #6-32 corner holes)
//
// The integrated bottom panel design eliminates the need for a separate
// motherboard plate. Standoffs mount directly into hexagonal recesses
// and are secured by M3 screws from underneath.
//
// Usage in assemblies:
//   translate([wall_thickness, wall_thickness, wall_thickness]) {
//       base_assembly(show_feet = true);
//   }

include <../dimensions.scad>
use <../panels/standard/bottom.scad>
use <../frame/standoff_extended.scad>
use <rubber_feet.scad>

module base_assembly(show_feet = true) {
    // Corner positions for feet (matches bottom panel #6-32 holes)
    foot_inset = 15;  // From bottom.scad
    foot_positions = [
        [foot_inset, foot_inset],
        [interior_panel_width - foot_inset, foot_inset],
        [foot_inset, interior_panel_depth - foot_inset],
        [interior_panel_width - foot_inset, interior_panel_depth - foot_inset]
    ];

    union() {
        // Bottom panel with integrated standoff receptacles
        // Note: show_feet = false since feet are now separate screw-in components
        bottom_panel(show_feet = false);

        // Extended standoffs positioned on top of bottom panel
        // The hexagonal boss is a structural feature on the panel for screw retention
        // Standoffs sit on the panel top surface at Z = wall_thickness (3mm)
        echo("=== BASE ASSEMBLY DEBUG ===");
        echo("Rendering", len(standoff_locations), "standoffs at Z=", wall_thickness);
        for (loc = standoff_locations) {
            echo("Standoff at X=", loc[0], "Y=", loc[1], "Z=", wall_thickness);
            translate([loc[0], loc[1], wall_thickness]) {
                extended_standoff();  // Correct module name from standoff_extended.scad
            }
        }

        // Rubber feet (optional, screw into #6-32 corner holes)
        // Disabled when NAS enclosure is attached (NAS frame provides feet)
        if (show_feet) {
            for (pos = foot_positions) {
                translate([pos[0], pos[1], 0]) {
                    rubber_foot();
                }
            }
        }
    }
}

// Preview
base_assembly();
