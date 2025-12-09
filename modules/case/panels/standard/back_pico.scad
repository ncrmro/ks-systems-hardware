// Back panel for Pico configuration
// Simplified design with only I/O shield and barrel jack hole
// No PSU exhaust, C14 inlet, or mounting holes (Pico PSU is on-board)
// Parametric: accepts dimensions and barrel jack position

include <../../dimensions_pico.scad>
use <../../../util/honeycomb.scad>

module back_panel_pico(
    width = front_back_panel_width,            // 170mm
    height = back_panel_height,                // ~57mm - shortened to sit between top/bottom panels
    barrel_x = pico_barrel_jack_x,
    barrel_z = pico_barrel_jack_z,
    barrel_diameter = pico_barrel_jack_diameter
) {
    // Panel dimensions
    panel_width = width;
    panel_height = height;
    panel_thickness = wall_thickness;        // 3mm

    // Honeycomb ventilation area
    honeycomb_area_z_start = io_shield_z_offset + io_shield_height + vent_padding;
    honeycomb_area_width = mobo_width - 2 * vent_padding;
    honeycomb_area_height = panel_height - honeycomb_area_z_start - vent_padding;

    color("red") {
        difference() {
            // Back panel
            cube([panel_width, panel_thickness, panel_height]);

            // I/O shield cutout
            translate([io_shield_x_offset, -0.1, io_shield_z_offset]) {
                cube([io_shield_width, panel_thickness + 0.2, io_shield_height]);
            }

            // Honeycomb ventilation
            translate([vent_padding, 0, honeycomb_area_z_start]) {
                honeycomb_xz(honeycomb_radius, panel_thickness, honeycomb_area_width, honeycomb_area_height);
            }

            // Barrel jack hole (right side, where PSU would be in other configs)
            translate([barrel_x, -0.1, barrel_z]) {
                rotate([-90, 0, 0]) {
                    cylinder(h = panel_thickness + 0.2, d = barrel_diameter, $fn = 20);
                }
            }
        }
    }
}

// Preview
back_panel_pico();
