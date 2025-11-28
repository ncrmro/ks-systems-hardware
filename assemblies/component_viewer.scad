// Component Viewer
// Displays all components in a grid for inspection

// Components
use <../modules/components/motherboard.scad>
use <../modules/components/cpu_cooler.scad>  // provides noctua_nh_l12s()
use <../modules/components/gpu.scad>
use <../modules/components/ram.scad>  // provides ram_stick()
use <../modules/components/pcie_riser.scad>
use <../modules/components/power/psu_flex_atx.scad>
use <../modules/components/power/psu_sfx.scad>
use <../modules/components/power/power_inlet_c14.scad>
use <../modules/components/storage/hdd_3_5.scad>
use <../modules/components/cooling/fan_120.scad>
use <../modules/components/cooling/aio_radiator_240.scad>
use <../modules/components/cooling/aio_pump.scad>

// Grid settings
grid_spacing_x = 200;  // Spacing between columns
grid_spacing_y = 200;  // Spacing between rows
columns = 4;           // Number of columns

// Component list with names for labels
module component_grid() {
    // Row 0: Core components
    translate([0 * grid_spacing_x, 0 * grid_spacing_y, 0]) {
        motherboard();
        color("white") translate([0, -20, 0]) text("Motherboard", size=10);
    }

    translate([1 * grid_spacing_x, 0 * grid_spacing_y, 0]) {
        noctua_nh_l12s();
        color("white") translate([0, -20, 0]) text("CPU Cooler", size=10);
    }

    translate([2 * grid_spacing_x, 0 * grid_spacing_y, 0]) {
        ram_stick();
        color("white") translate([0, -20, 0]) text("RAM", size=10);
    }

    translate([3 * grid_spacing_x, 0 * grid_spacing_y, 0]) {
        pcie_riser();
        color("white") translate([0, -20, 0]) text("PCIe Riser", size=10);
    }

    // Row 1: Power components
    translate([0 * grid_spacing_x, 1 * grid_spacing_y, 0]) {
        power_supply_flex_atx();
        color("white") translate([0, -20, 0]) text("PSU Flex ATX", size=10);
    }

    translate([1 * grid_spacing_x, 1 * grid_spacing_y, 0]) {
        power_supply_sfx();
        color("white") translate([0, -20, 0]) text("PSU SFX", size=10);
    }

    translate([2 * grid_spacing_x, 1 * grid_spacing_y, 0]) {
        power_inlet_c14();
        color("white") translate([0, -20, 0]) text("C14 Power Inlet", size=10);
    }

    // Row 2: Storage and small cooling
    translate([0 * grid_spacing_x, 2 * grid_spacing_y, 0]) {
        hdd_3_5();
        color("white") translate([0, -20, 0]) text("HDD 3.5\"", size=10);
    }

    translate([1 * grid_spacing_x, 2 * grid_spacing_y, 0]) {
        fan_120();
        color("white") translate([0, -20, 0]) text("Fan 120mm", size=10);
    }

    translate([2 * grid_spacing_x, 2 * grid_spacing_y, 0]) {
        aio_pump();
        color("white") translate([0, -20, 0]) text("AIO Pump", size=10);
    }

    // Row 3: GPU (large component - 320mm)
    translate([0 * grid_spacing_x, 3 * grid_spacing_y, 0]) {
        gpu();
        color("white") translate([0, -20, 0]) text("GPU", size=10);
    }

    // Row 4: AIO Radiator (large component - 275mm)
    translate([0 * grid_spacing_x, 4 * grid_spacing_y, 0]) {
        aio_radiator_240();
        color("white") translate([0, -20, 0]) text("AIO Radiator 240", size=10);
    }
}

// Render the grid
component_grid();
