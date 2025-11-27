// Right side panel for minimal/barebones configuration
// Mirror of left panel - features ventilation honeycomb and mounting holes

include <../../dimensions.scad>
use <side_left.scad>

module side_panel_right() {
    // Right panel is identical to left panel
    // In assembly, it will be positioned on the opposite side
    side_panel_left();
}

// Preview
side_panel_right();
