// A module to create a honeycomb pattern on the XZ plane, centered within the given width and height
module honeycomb_xz(radius, thickness, width, height) {
    x_spacing = radius * 2.5; // Changed from 1.5 to 2.5
    z_spacing = radius * 2.5 * sqrt(3)/2; // Changed from radius * sqrt(3)
    
    // Calculate how many full hexagons fit
    cols = floor(width / x_spacing);
    rows = floor(height / z_spacing);

    // Calculate the actual size of the honeycomb pattern
    actual_width = cols * x_spacing - (cols > 0 ? 0.5 * radius : 0);
    actual_height = rows * z_spacing;

    // Center the pattern
    x_offset = (width - actual_width) / 2;
    z_offset = (height - actual_height) / 2;
    
    translate([x_offset, 0, z_offset]) {
        for (row = [0:rows-1]) {
            for (col = [0:cols-1]) {
                x = col * x_spacing;
                z = row * z_spacing + (col % 2 == 1 ? z_spacing / 2 : 0);
                translate([x, thickness/2, z]) {
                    rotate([90,0,0])
                        cylinder(h = thickness + 0.2, r = radius, $fn = 6, center=true);
                }
            }
        }
    }
}
