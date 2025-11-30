# PSU Mounting Plan

## Problem

Two issues with current PSU mounting:

1. **Incorrect hole inset**: Currently `flex_atx_mount_x_inset = 12.5mm`, but PSU holes are actually 5mm from the edge.

2. **No material for mounting holes**: The backplate PSU cutout is the full size of the PSU face (40mm x 80mm), which removes all the material where the mounting holes need to go. The screws have nothing to thread through.

## Current State

```
PSU Face (40mm x 80mm)
┌────────────────────────────────┐
│  ○                          ○  │  <- Mounting holes at 5mm from edges
│                                │
│      ┌──────────────────┐      │
│      │                  │      │  <- Fan/exhaust area (center)
│      │                  │      │
│      └──────────────────┘      │
│                                │
│  ○                          ○  │  <- Mounting holes at 5mm from edges
└────────────────────────────────┘

Current backplate cuts out the ENTIRE 40x80mm area,
leaving no material for screw holes!
```

## Solution

### 1. Fix mounting hole positions in `dimensions.scad`

Change `flex_atx_mount_x_inset` from 12.5mm to 5mm:
```openscad
flex_atx_mount_x_inset = 5;      // Distance from left/right edges (was 12.5)
flex_atx_mount_z_inset = 5;      // Distance from top/bottom edges (was 8.25)
```

### 2. Reduce PSU exhaust cutout size in `backplate_io.scad`

The exhaust cutout should be smaller than the PSU face, leaving material around the edges for mounting holes. The cutout should be inset by enough to leave material for the screw holes.

**Calculation:**
- Hole center is 5mm from PSU edge
- Hole radius is ~2.1mm (8-32 clearance)
- Need ~3mm material around hole for strength
- Total inset needed: 5mm + 2.1mm + 3mm ≈ 10mm from each edge

**New cutout dimensions:**
```openscad
// Exhaust cutout inset (leave material for mounting holes)
psu_exhaust_inset = 10;  // Material border for mounting holes

psu_cutout_width = flex_atx_width - 2 * psu_exhaust_inset;    // 40 - 20 = 20mm
psu_cutout_height = flex_atx_height - 2 * psu_exhaust_inset;  // 80 - 20 = 60mm
```

### 3. Update PSU model in `psu_flex_atx.scad`

The PSU model mounting holes should also use the corrected 5mm inset values (already references dimensions.scad, so will update automatically).

## Visual Result

```
Backplate PSU Section
┌────────────────────────────────┐
│  ○                          ○  │  <- Mounting holes (5mm from PSU edge)
│     ┌────────────────────┐     │
│     │ ░░░░░░░░░░░░░░░░░░ │     │  <- Exhaust cutout (20x60mm)
│     │ ░░░░░░░░░░░░░░░░░░ │     │     with honeycomb or open
│     │ ░░░░░░░░░░░░░░░░░░ │     │
│     └────────────────────┘     │
│  ○                          ○  │  <- Mounting holes (5mm from PSU edge)
└────────────────────────────────┘

Now there's solid material (10mm border) for the mounting screws!
```

## Files to Modify

1. **`modules/case/dimensions.scad`**
   - Change `flex_atx_mount_x_inset` to 5mm
   - Change `flex_atx_mount_z_inset` calculation or set to 5mm

2. **`modules/case/base/backplate_io.scad`**
   - Add `psu_exhaust_inset` variable
   - Reduce `psu_cutout_width` and `psu_cutout_height` by 2*inset
   - Center the smaller cutout within the PSU face area
   - Optionally add honeycomb pattern to the cutout for better airflow

3. **`modules/components/power/psu_flex_atx.scad`**
   - Already uses dimensions.scad, will update automatically
