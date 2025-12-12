// Back panel for Pico configuration
// Simplified design with only I/O shield and barrel jack hole
// No PSU exhaust, C14 inlet, or mounting holes (Pico PSU is on-board)
//
// DOVETAIL JOINTS (Two-Shell Assembly):
// - Male dovetails on bottom edge connect to bottom panel female dovetails (internal)
// - Male clip dovetails on left/right edges connect to side panel female clips (EXTERNAL)
//   User pinches these clips to release top shell from bottom shell
// - Per SPEC.md Section 9.6
//
// Parametric: accepts dimensions and barrel jack position

include <../../dimensions_pico.scad>
include <../../../util/dovetail/dimensions.scad>
use <../../../util/honeycomb.scad>
use <../../../util/dovetail/male_dovetail.scad>

module back_panel_pico(
    width = front_back_panel_width + 2 * wall_thickness,  // 176mm - flush with side walls
    height = back_panel_height,                // ~57mm - shortened to sit between top/bottom panels
    barrel_x = pico_barrel_jack_x,
    barrel_z = pico_barrel_jack_z,
    barrel_diameter = pico_barrel_jack_diameter,
    with_dovetails = true                      // Male dovetails on bottom edge for base assembly
) {
    // Panel dimensions
    panel_width = width;
    panel_height = height;
    panel_thickness = wall_thickness;        // 3mm

    // Honeycomb ventilation area
    honeycomb_area_z_start = io_shield_z_offset + io_shield_height + vent_padding;
    honeycomb_area_width = mobo_width - 2 * vent_padding;
    honeycomb_area_height = panel_height - honeycomb_area_z_start - vent_padding;

    // Dovetail positions on bottom edge (match bottom panel positions)
    // Male rails extend downward (-Z), positioned to align with female channels
    // Back panel is full exterior width (176mm) and positioned at X=0 in assembly
    // Bottom panel positions: width * 0.25 and width * 0.75 (at 176mm: 44mm and 132mm)
    bottom_dovetail_positions = [exterior_panel_width * 0.25, exterior_panel_width * 0.75];

    // Left/right edge dovetail position (clip - EXTERNAL user-accessible release)
    // Single clip per side - main release mechanism for the two-shell assembly
    side_dovetail_position = panel_height * 0.5;

    color("red") {
        difference() {
            // Back panel
            cube([panel_width, panel_thickness, panel_height]);

            // I/O shield cutout (offset by wall_thickness for extended panel width)
            translate([wall_thickness + io_shield_x_offset, -0.1, io_shield_z_offset]) {
                cube([io_shield_width, panel_thickness + 0.2, io_shield_height]);
            }

            // Honeycomb ventilation (offset by wall_thickness for extended panel width)
            translate([wall_thickness + vent_padding, 0, honeycomb_area_z_start]) {
                honeycomb_xz(honeycomb_radius, panel_thickness, honeycomb_area_width, honeycomb_area_height);
            }

            // Barrel jack hole (offset by wall_thickness for extended panel width)
            translate([wall_thickness + barrel_x, -0.1, barrel_z]) {
                rotate([-90, 0, 0]) {
                    cylinder(h = panel_thickness + 0.2, d = barrel_diameter, $fn = 20);
                }
            }
        }
    }

    // Male dovetails on bottom edge (for base assembly connection to bottom panel)
    // Rails extend from inside face (Y=0) toward -Y to engage with female channels on bottom panel
    if (with_dovetails) {
        color("red") {
            // Bottom edge dovetails (connect to bottom panel - internal)
            for (x_pos = bottom_dovetail_positions) {
                // Position so rail base is at inside face (Y=0), extending toward -Y (into case)
                // Raise by dovetail_height to account for 180° rotation
                translate([x_pos, -dovetail_length/2, dovetail_height])
                    rotate([180, 0, 0])
                        male_dovetail(with_latch = true);  // Clip version for base assembly
            }

            // Left edge dovetail (clip - EXTERNAL user-accessible release)
            // Rail faces front (-Y), positioned on inside face like bottom dovetails
            translate([0, -dovetail_length/2, side_dovetail_position])
                rotate([0, 90, 180])  // Rail faces -Y (front), cross-section rotated
                    male_dovetail(with_latch = true);  // Clip for snap-fit

            // Right edge dovetail (clip - EXTERNAL user-accessible release)
            // Rail faces front (-Y), positioned on inside face like bottom dovetails
            translate([panel_width, -dovetail_length/2, side_dovetail_position])
                rotate([0, -90, 180])  // Rail faces -Y (front), mirrored orientation
                    male_dovetail(with_latch = true);  // Clip for snap-fit
        }
    }
}

// Preview
back_panel_pico();
