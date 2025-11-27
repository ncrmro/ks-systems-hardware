// PCIe Riser Cable Model
// Flexible ribbon cable for vertical GPU mounting

module pcie_riser(length = 200) {
    // Connector dimensions (PCIe x16)
    connector_length = 90;
    connector_width = 25;
    connector_height = 10;

    // Cable dimensions
    cable_width = 80;
    cable_thickness = 3;

    union() {
        // Motherboard-side connector
        color("black") {
            cube([connector_length, connector_width, connector_height]);
        }

        // Flexible cable (simplified as curved path)
        color("orange") {
            translate([connector_length/2 - cable_width/2, connector_width, 0]) {
                cube([cable_width, length, cable_thickness]);
            }
        }

        // GPU-side connector
        color("black") {
            translate([0, connector_width + length, 0]) {
                cube([connector_length, connector_width, connector_height]);
            }
        }
    }
}

// Preview
pcie_riser();
