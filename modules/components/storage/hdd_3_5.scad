module hdd_3_5() {
    // Standard 3.5" HDD Dimensions
    hdd_width = 101.6;
    hdd_length = 147;
    hdd_height = 26.1;

    color("dimgrey") {
        cube([hdd_width, hdd_length, hdd_height]);
    }
}
