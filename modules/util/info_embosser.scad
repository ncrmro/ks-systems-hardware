// Embossed information block for labeling parts with metadata.
// Origin sits at the top-left corner of the first line (on the XZ plane),
// extruding along +Y so it can be dropped directly onto an interior face.
// Example:
//   info_embosser(part_name="Bottom Panel", version="v1.0");
module info_embosser(
    part_name = "Unnamed Part",
    version = "DEV",
    designer = "NCRMRO",
    year = 2025,
    location = "HTX",
    text_size = 3,
    emboss_height = .4,
    line_spacing = 2, // Multiplier on text_size
    font = "Liberation Sans:style=Bold",
    spacing = 1, // Letter spacing multiplier
    halign = "left" // Use "right" to anchor to a right margin
) {
    version_value = is_undef(emboss_version) ? version : emboss_version;

    lines = [
        str("PART: ", version_value, " ", part_name),
        str(location, " ", designer, " ", year )
    ];

    y_step = text_size * line_spacing;

    // Oriented for a front panel interior face (normal +Y); text reads upright from inside the case with no extra transforms.
    // Text lies on the XZ plane and extrudes along +Y into the case interior.
    rotate([-90, 180, 0]) {
        for (i = [0 : len(lines) - 1]) {
            translate([0, -i * y_step, 0]) // Step lines downward along -Z to keep top-aligned
                linear_extrude(emboss_height)
                    text(
                        lines[i],
                        size = text_size,
                        font = font,
                        halign = halign,
                        valign = "baseline",
                        spacing = spacing
                    );
        }
    }
}
