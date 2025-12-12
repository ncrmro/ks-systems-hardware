// Female Dovetail Bottom Shelf
// Creates a bottom support shelf for a female dovetail mounted on a panel edge
//
// The shelf provides:
// - Support underneath the dovetail on the interior side of the panel
// - Matches the dovetail boss depth
//
// Per SPEC.md Section 9.6 - External user-accessible release points

include <dimensions.scad>
use <female_dovetail.scad>

// Calculate dovetail top width (widest part of trapezoid)
function calc_dovetail_top_width() =
    dovetail_base_width + 2 * dovetail_height * tan(dovetail_angle);

// Female dovetail with bottom shelf module
// Creates a female dovetail with a support shelf underneath
//
// Origin: At the center of the dovetail (matching female_dovetail origin placement)
// Shelf extends in +X direction (into case interior)
//
// Parameters:
//   thickness - Depth of shelf into case (default: dovetail_height)
//   wall - Height of the shelf wall (default: dovetail_height)
//   with_catch_windows - Pass through to female_dovetail
//
module female_dovetail_pocket(
    thickness = dovetail_height,                  // 3mm - depth into case
    wall = dovetail_height,                       // 3mm - shelf wall height (standard panel width)
    with_catch_windows = true
) {
    // Boss dimensions (matches female_dovetail boss exactly)
    boss_width = calc_dovetail_top_width() + 2 * dovetail_boss_margin;  // ~13.6mm
    channel_length = dovetail_length + 2 * dovetail_clearance;          // ~20.3mm
    boss_depth = channel_length + dovetail_boss_margin;                 // ~22.3mm (margin on closed side only)

    // Shelf covers entire dovetail + standard panel width on closed side
    shelf_depth = boss_depth + wall;

    union() {
        // The female dovetail itself
        female_dovetail(with_catch_windows = with_catch_windows);

        // Top shelf - attached to top of dovetail boss, covers full depth + panel width
        // Width extends wall thickness beyond dovetail on each side
        // Flush with opening at -Y, extends wall thickness on closed side at +Y
        shelf_width = boss_width + 2 * wall;
        translate([-shelf_width/2, -channel_length/2, dovetail_height])
            cube([shelf_width, shelf_depth, wall]);
    }
}

// Preview
female_dovetail_pocket();
