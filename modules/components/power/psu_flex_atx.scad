module power_supply_flex_atx() {
    // Flex ATX Power Supply Dimensions
    // Standing orientation: shortest side (40mm) as width on X axis
    psu_thickness = 40.5;   // X - shortest side on bottom
    psu_length = 150;       // Y - along case depth
    psu_height = 81.5;      // Z - standing upright

    color("green") {
        cube([psu_thickness, psu_length, psu_height]);
    }
}
