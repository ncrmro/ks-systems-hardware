# PR: Fix visual review issues for pico-hinge-tophat (Pass 2)

This PR addresses all 7 issues identified in the visual review (pass 2) of the `pico-hinge-tophat` feature.

## Changes

### Critical
- **Back Panel**: Added I/O shield cutout (158.75mm x 44.45mm) at the correct height.
- **Back Panel**: Removed legacy dovetails (back panel is now integrated into the bottom tray).
- **Back Panel**: Added latch lip at the top edge for the `LatchHook` to catch.

### Major
- **Side Flaps**: Added real `Honeycomb` ventilation pattern (solid panel with hex holes) instead of placeholder boxes.
- **Side Flaps**: Increased hinge knuckle count to 3 (distributed as 0, 2, 4 in a 5-knuckle `HingeLine`) to properly interlock with the top hat.
- **Top Hat**: Updated side hinges to have 2 knuckles (indices 1, 3 in a 5-knuckle `HingeLine`) for alternating interlock with side flaps.

### Minor
- **Hinge Geometry**: Increased resolution of `HingeKnuckle` barrel, pins, and sockets (`fn=32`).
- **Hinge Geometry**: Updated `HingeLine` to automatically override `knuckle_width` with the calculated `pitch`. This ensures that knuckles always touch and pins properly engage, regardless of the edge length or total count.
- **SSD Harness**: Increased divider height to 10.0mm (to clear 9.5mm SSDs) and added a second horizontal lip for the front-right SSD zone to improve retention.
- **Utilities**: Created `src/util/honeycomb.py` with a parametric honeycomb pattern generator.

## Verification Results

### Automated Tests
- `bin/test` passed: 29/29 tests passed.
- All parts rendered successfully to SCAD.

### Visual Verification (Self-Review)
- Rendered all modified parts individually using `bin/screenshots --scan-dir build/ --angles iso`.
- Verified:
  - [x] I/O shield cutout is present and correctly sized on the back panel.
  - [x] No dovetails on the back panel.
  - [x] Latch lip is present at the top of the back panel.
  - [x] Honeycomb pattern is visible on both side flaps and the top hat.
  - [x] Side flaps have 3 knuckles; top hat has 2 knuckles per side (total 5 alternating).
  - [x] Front hinge has 5 alternating knuckles.
  - [x] Hinge knuckles are smooth and have visible pins/sockets.
  - [x] SSD harness has the additional retention lip.

## Manual Testing
1. Run `nix develop --command bin/render pico` to generate SCAD files.
2. Open `build/parts_case_pico_back_panel.scad` in OpenSCAD to verify I/O cutout and latch lip.
3. Open `build/parts_case_pico_side_flap_left.scad` to verify honeycomb and 3 knuckles.
4. Open `build/parts_case_pico_top_hat.scad` to verify honeycomb and side hinge indices.