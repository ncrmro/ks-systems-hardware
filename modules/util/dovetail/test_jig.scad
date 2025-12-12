// Dovetail Test Jig
// Print this to validate dovetail clearances and snap-fit engagement
// Contains both clip (locking) and non-locking variants
//
// Print orientation:
// - Male dovetails: Print with dovetails facing DOWN against build plate
// - Female dovetails: Print with channels facing UP
//
// Test procedure:
// 1. Print all four test pieces
// 2. Test clip male+female: Should click when fully inserted
// 3. Test non-locking male+female: Should slide freely with friction fit
// 4. Adjust clearance in dimensions.scad if needed

include <dimensions.scad>
use <male_dovetail.scad>
use <female_dovetail.scad>

// Test block dimensions
test_block_width = 40;
test_block_depth = 30;
test_block_height = 3;  // Same as wall_thickness

// Spacing between test pieces
spacing = 50;

// Male clip dovetail test piece
module male_clip_test() {
    difference() {
        // Base block
        cube([test_block_width, test_block_depth, test_block_height]);

        // Label "M-C" (Male Clip)
        translate([5, test_block_depth - 8, test_block_height - 0.5])
            linear_extrude(1)
                text("M-C", size = 5);
    }

    // Male dovetail with latch (clip)
    translate([test_block_width / 2, test_block_depth, test_block_height])
        rotate([0, 0, 180])
            male_dovetail(with_latch = true);
}

// Female clip dovetail test piece
module female_clip_test() {
    union() {
        difference() {
            // Base block
            cube([test_block_width, test_block_depth, test_block_height]);

            // Label "F-C" (Female Clip)
            translate([5, test_block_depth - 8, test_block_height - 0.5])
                linear_extrude(1)
                    text("F-C", size = 5);
        }

        // Female dovetail with catch windows (clip)
        translate([test_block_width / 2, 0, test_block_height + dovetail_height])
            rotate([180, 0, 0])
                female_dovetail(with_catch_windows = true);
    }
}

// Male non-locking dovetail test piece
module male_non_locking_test() {
    difference() {
        // Base block
        cube([test_block_width, test_block_depth, test_block_height]);

        // Label "M-NL" (Male Non-Locking)
        translate([5, test_block_depth - 8, test_block_height - 0.5])
            linear_extrude(1)
                text("M-NL", size = 5);
    }

    // Male dovetail without latch (non-locking)
    translate([test_block_width / 2, test_block_depth, test_block_height])
        rotate([0, 0, 180])
            male_dovetail(with_latch = false);
}

// Female non-locking dovetail test piece
module female_non_locking_test() {
    union() {
        difference() {
            // Base block
            cube([test_block_width, test_block_depth, test_block_height]);

            // Label "F-NL" (Female Non-Locking)
            translate([5, test_block_depth - 8, test_block_height - 0.5])
                linear_extrude(1)
                    text("F-NL", size = 5);
        }

        // Female dovetail without catch windows (non-locking)
        translate([test_block_width / 2, 0, test_block_height + dovetail_height])
            rotate([180, 0, 0])
                female_dovetail(with_catch_windows = false);
    }
}

// Full test jig layout (all four pieces arranged for printing)
module dovetail_test_jig() {
    // Row 1: Clip variants
    translate([0, 0, 0])
        male_clip_test();

    translate([spacing, 0, 0])
        female_clip_test();

    // Row 2: Non-locking variants
    translate([0, spacing, 0])
        male_non_locking_test();

    translate([spacing, spacing, 0])
        female_non_locking_test();
}

// Individual pieces for separate printing (comment/uncomment as needed)
// male_clip_test();
// female_clip_test();
// male_non_locking_test();
// female_non_locking_test();

// Preview full test jig
dovetail_test_jig();
