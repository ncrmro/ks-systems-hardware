// A module to create a rudimentary Mini-ITX motherboard model
module motherboard() {
    mobo_width = 170;
    mobo_depth = 170;
    mobo_thickness = 1.6;

    io_shield_width = 152.4;
    io_shield_height = 33.87;
    io_shield_thickness = 2;
    io_shield_x_offset = (mobo_width - io_shield_width) / 2;

    // ATX 24-pin connector dimensions
    atx_conn_l = 51.6;
    atx_conn_w = 15.1;
    atx_conn_h = 19.6;

    color("purple") {
        union() {
            // Motherboard PCB
            cube([mobo_width, mobo_depth, mobo_thickness]);
            // I/O Shield
            translate([io_shield_x_offset, mobo_depth - io_shield_thickness, mobo_thickness]) {
                cube([io_shield_width, io_shield_thickness, io_shield_height]);
            }
            // 24-pin ATX Connector
            translate([mobo_width - atx_conn_l, 0, mobo_thickness]) {
                cube([atx_conn_l, atx_conn_w, atx_conn_h]);
            }
        }
    }
}
