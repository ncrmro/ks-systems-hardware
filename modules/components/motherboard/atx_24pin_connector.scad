// ATX 24-Pin Power Connector
// Standard motherboard power connector

module atx_24pin_connector() {
    // ATX 24-pin connector dimensions
    conn_length = 51.6;
    conn_width = 10;
    conn_height = 13;

    color("black") {
        cube([conn_length, conn_width, conn_height]);
    }
}

// Preview
atx_24pin_connector();
