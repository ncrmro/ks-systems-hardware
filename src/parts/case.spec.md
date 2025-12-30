# Case Parts Specification

This document details the design and implementation specifications for various case parts within the Keystone Hardware project. Case designs are primarily driven by the dimensions of the motherboard and the selected power supply unit (PSU). Currently, the project supports Pico-ITX and SFX PSU form factors.

---

## Pico Base Panel (`PicoBasePanel`)

**File:** `src/parts/case_pico.py`  
**Registry Key:** `parts_case_pico_base_panel`

### Dimensions
-   **Width**: `PicoDimensions.pico_case_width` (covers full width).
-   **Depth**: `PicoDimensions.pico_case_depth` (covers full depth, supporting front and back panels).
-   **Thickness**: `PicoDimensions.wall_thickness`.

### Features
1.  **Standoff Mounting**:
    -   Integrated hexagonal bosses.
    -   **Height**: `standoff_boss_height` (2.5mm).
    -   **Pocket**: Hexagonal pocket for standoff base (`standoff_pocket_depth` deep).
    -   **Location Fix**: Standoffs must be offset by `wall_thickness` in **both X and Y** to center the motherboard and clear the front/back walls.
        -   X Offset: `wall_thickness` (centering horizontally).
        -   Y Offset: `wall_thickness` (clearing front panel).
    -   **Holes**: Clearance holes (`standoff_screw_clearance_hole`) through boss and panel.

2.  **Dovetails**:
    -   **Back Edge**: Female "Clip" Dovetails (internal, catching back panel).
        -   Positions: 25% and 75% of width.
        -   Orientation: Channel faces +Y (back).
    -   **Front Edge**: Female "Latchless" Dovetails (internal, holding front panel).
        -   Positions: 25% and 75% of width.
        -   Orientation: Channel faces -Y (front).

3.  **Cutout** (Rapid Prototyping):
    -   Center square cutout to reduce print time.
    -   **Control**: `center_cutout` parameter.
    -   **Default**: `False` (Standard production part), can be enabled for prototyping.
    -   **Size**: 125mm square (approx).

### Implementation Plan
-   Update `PicoBasePanel` to use correct `panel_depth` (full depth).
-   Apply `wall_thickness` offset to `standoff_locations` (Y-axis fix).
-   Implement `FemaleDovetail` shape (create `src/parts/dovetail.py`).
-   Integrate dovetails into `PicoBasePanel`.
-   Ensure `center_cutout` is configurable and defaults to `False`.

## Pico Back Panel (`PicoBackPanel`)
(Placeholder for completeness)

## Pico Side Panels (`PicoSidePanel`)
(Placeholder for completeness)