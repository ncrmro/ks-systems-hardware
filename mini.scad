use <modules/case.scad>;
use <modules/motherboard.scad>;

translate([0, 0, 180]) rotate([-90, 0, 0]) {
    mini_itx_case();
}

translate([220, 0, 170]) rotate([-90, 0, 0]) {
    motherboard();
}