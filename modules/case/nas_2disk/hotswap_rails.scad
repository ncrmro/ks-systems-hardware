module hdd_hotswap_rail_35() {
    // Simple representation of a rail
    rail_width = 5;
    rail_length = 140;
    rail_height = 10;

    color("orange") {
        cube([rail_width, rail_length, rail_height]);
    }
}
