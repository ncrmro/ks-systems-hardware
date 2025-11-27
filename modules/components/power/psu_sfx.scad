module power_supply_sfx() {
    // --- SFX Power Supply Dimensions ---
    sfx_psu_width = 125;
    sfx_psu_depth = 100;
    sfx_psu_height = 63.5;

    color("green") {
        cube([sfx_psu_width, sfx_psu_depth, sfx_psu_height]);
    }
}
