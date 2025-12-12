// Dovetailed Shell Assembly
// Top panel + Front panel joined via dovetail

include <../dimensions.scad>
use <../modules/dovetail.scad>
use <../panels/top_panel.scad>
use <../panels/front_panel.scad>

// Assembly toggles
show_top_panel = true;
show_front_panel = true;
explode = 0;  // Set > 0 to separate panels for visualization (20-30 works well)

module assembly() {
    // Top panel positioned at top of assembly
    // Shifted back in Y so front panel sits in front of it
    // Panel bottom face at Z = scaled_height (front panel top)
    if (show_top_panel) {
        translate([0, 0, scaled_height + explode])
            color("LightGray")
            top_panel(
                width = scaled_width,
                depth = scaled_depth,
                thickness = scaled_top_thickness,
                dt_angle = dovetail_angle,
                dt_height = scaled_dovetail_height,
                dt_length = scaled_dovetail_length,
                dt_base_width = scaled_dovetail_base_width,
                dt_clearance = scaled_clearance
            );
    }

    // Front panel at Y=0 (front face of assembly at Y=0)
    // Height spans from Z=0 to Z=scaled_height
    // Male dovetail on top edge extends into top panel's front channel
    if (show_front_panel) {
        translate([0, -explode, 0])
            color("DarkGray")
            front_panel(
                width = scaled_width,
                panel_h = scaled_height,
                thickness = scaled_wall_thickness,
                dt_angle = dovetail_angle,
                dt_height = scaled_dovetail_height,
                dt_length = scaled_dovetail_length,
                dt_base_width = scaled_dovetail_base_width
            );
    }
}

// Calculate overall assembly dimensions for reference
assembly_width = scaled_width;
assembly_depth = scaled_depth;
assembly_height = scaled_height + scaled_top_thickness;

// Render the assembly
assembly();

// Reference dimensions (uncomment to visualize bounding box)
// %cube([scaled_width, scaled_depth, scaled_height + scaled_thickness]);
