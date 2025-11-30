// Dovetailed Shell Assembly
// Top panel + Front panel joined via dovetail

use <../modules/dovetail.scad>
use <../panels/top_panel.scad>
use <../panels/front_panel.scad>

// Shared parameters - adjust these to match panels
panel_width = 100;
panel_depth = 100;
panel_height = 100;
top_panel_thickness = 6;      // Top panel is 6mm thick
front_panel_thickness = 3;    // Front panel is 3mm thick

// Dovetail parameters
dovetail_angle = 50;
dovetail_height = 3;          // Trapezoid height (3mm into 6mm top panel)
dovetail_length = 30;
dovetail_base_width = 8;
clearance = 0.3;

// Scale factor for prototyping (0.5 = half size)
scale_factor = 1.0;

// Scaled dimensions
scaled_width = panel_width * scale_factor;
scaled_depth = panel_depth * scale_factor;
scaled_panel_height = panel_height * scale_factor;
scaled_top_thickness = top_panel_thickness * scale_factor;
scaled_front_thickness = front_panel_thickness * scale_factor;
scaled_dovetail_height = dovetail_height * scale_factor;
scaled_dovetail_length = dovetail_length * scale_factor;
scaled_dovetail_base_width = dovetail_base_width * scale_factor;
scaled_clearance = clearance * scale_factor;

// Assembly toggles
show_top_panel = true;
show_front_panel = true;
explode = 0;  // Set > 0 to separate panels for visualization (20-30 works well)

module assembly() {
    // Top panel positioned at top of assembly
    // Shifted back in Y so front panel sits in front of it
    // Panel bottom face at Z = scaled_panel_height (front panel top)
    if (show_top_panel) {
        translate([0, scaled_front_thickness, scaled_panel_height + explode])
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
    // Height spans from Z=0 to Z=scaled_panel_height
    // Male dovetail on top edge extends into top panel's front channel
    if (show_front_panel) {
        translate([0, -explode, 0])
            color("DarkGray")
            front_panel(
                width = scaled_width,
                panel_h = scaled_panel_height,
                thickness = scaled_front_thickness,
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
assembly_height = scaled_panel_height + scaled_top_thickness;

// Render the assembly
assembly();

// Reference dimensions (uncomment to visualize bounding box)
// %cube([scaled_width, scaled_depth, scaled_height + scaled_thickness]);
