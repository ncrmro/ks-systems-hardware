# Visual Review: feat/pico-hinge-tophat

## Verdict: REQUEST_CHANGES

Two critical issues block approval: the back panel is missing the I/O shield cutout (motherboard ports completely blocked), and the back panel retains legacy dovetails instead of the latch lip specified in the plan. Additional issues with side flap ventilation and hinge knuckle counts also need addressing.

## Per-Part Screenshot Assessment

| Part | Screenshots | Assessment |
|------|-----------|------------|
| **Bottom Tray** | build-parts_case_pico_bottom_tray-{iso,front,top} | **OK** - Flat base with integrated back wall, low side walls with L-shaped lip profile visible. 4 standoff bosses with hex pockets (orange). Front-edge hinge knuckles (blue stubs) present at corners and center. Back wall shows barrel jack hole. Structure matches plan Phase 2. |
| **Top Hat** | build-parts_case_pico_top_hat-{iso,front,top} | **CONCERN** - Flat panel with SSD harness opening (orange-outlined rectangular cutout) in lower-left quadrant. 4 corner knuckle stubs present. Honeycomb vent not visible in per-part render (may need assembly context). SSD cutout positioned to one side only - verify diagonal SSD layout from top view. |
| **Side Flap Left** | build-parts_case_pico_side_flap_left-{iso,front} | **ISSUE** - Rectangular frame with completely open center (no honeycomb fill). Only 1 hinge knuckle visible on top edge. Orange inner edge (ledge) and blue bottom edge (inward ledge for rigidity interlock) present. See issues #3 and #4. |
| **Side Flap Right** | build-parts_case_pico_side_flap_right-iso | **ISSUE** - Mirror of left flap, same open-center and single-knuckle problems. |
| **Hinge Knuckle** | build-parts_hinge_knuckle-iso | **CONCERN** - Renders as plain decagonal cylinder. No visible pin/socket differentiation for snap-fit engagement per plan spec. |
| **Hinge Line** | build-parts_hinge_line-{iso,front} | **CONCERN** - Only 2 knuckles visible, widely spaced. Plan specifies 5 alternating knuckles for front hinge (176mm edge). Spacing appears too large for structural rigidity. |
| **SSD Harness** | build-parts_ssd_harness-{iso,front,top} | **CONCERN** - Cross-shaped structure: one horizontal lip + one vertical divider with 4 screw channels (orange). Geometry is minimal - thin bars only. Plan specifies "lips + screw channels for 2x 2.5\" drives in diagonal corners." Current dividers create zones but retention geometry (lips that grip SSD edges) appears insufficient. |
| **Latch Hook** | build-parts_latch_hook-{iso,front} | **MINOR** - U-channel / C-channel profile shape present. No visible flex tab for press-to-release action. Currently appears as rigid hook rather than cantilever snap-fit. |
| **Back Panel** | build-parts_case_pico_back_panel-{iso,front} | **CRITICAL** - Has barrel jack hole but **NO I/O shield cutout** for motherboard ports. Still has legacy dovetail protrusions on all edges. See issues #1 and #2. |
| **Base Panel** | build-parts_case_pico_base_panel-iso | **OK** - Original base panel with 6 standoff bosses (blue with orange hex pockets) at Mini-ITX mounting positions. 4 corner hex nut pockets. Geometry intact from proven design. |

## Assembly Screenshot Assessment

| View | Screenshot | Assessment |
|------|-----------|------------|
| **Normal ISO** | assembly-pico-iso | **OK** - Compact box case. Honeycomb vent on top panel (offset over cooler area). Side flaps close against bottom tray. Red accent at back edge. Barrel jack visible. Small gaps at panel joints acceptable. |
| **Exploded ISO** | assembly-pico-exploded-iso | **OK** - Top hat lifts clearly showing separation. Internal components visible: orange cooler, blue RAM, magenta mobo, green PSU. Red SSD harness structure visible at back. Hinge knuckles at front edge visible. |
| **Open ISO** | assembly-pico-open-iso | **OK** - Panels removed, full interior access. Orange Noctua cooler, blue RAM sticks, magenta PCB, green PSU with yellow connector, black barrel jack. Bottom tray side walls visible. |
| **Back** | assembly-pico-back | **CRITICAL** - Confirms missing I/O cutout. Back panel shows only barrel jack hole on upper right. Motherboard I/O ports (USB, HDMI, Ethernet) are completely blocked. Honeycomb vent visible but only on top panel. |
| **Front** | assembly-pico-front | **OK** - Honeycomb vent pattern visible (lower-left quadrant, over cooler). Red accent at top. Hinge knuckles at bottom front edge connecting top hat to bottom tray. |
| **Top** | assembly-pico-top | **OK** - Front panel view showing barrel jack circle and LED holes. Thin profile. Side flap edges visible. |
| **Left** | assembly-pico-left | **OK** - Honeycomb vent in upper-left area (top hat surface). Red accent strip on back edge. Side flap below is plain (no ventilation) per issue #3. |
| **Right** | assembly-pico-right | **OK** - Mirror of left. Honeycomb on upper area, plain side flap below. |
| **Exploded Back** | assembly-pico-exploded-back | **OK** - Back panel separated, showing honeycomb top and side flaps detached. Components visible inside. Confirms assembly composition works. |
| **Open Back** | assembly-pico-open-back | **OK** - Top removed, internal layout visible from rear. Back panel structure with hinge knuckles and latch positions. |
| **Open Front** | assembly-pico-open-front | **OK** - Top-down into open case. Magenta PCB, orange cooler, green PSU, blue RAM, yellow connector all visible. Standoffs and mounting hardware present. |
| **Open Top** | assembly-pico-open-top | **OK** - Front profile of open case. RAM sticks (blue) prominent. Cooler (orange) behind. Barrel jack on right side. Base panel and bottom tray visible. |
| **Exploded Top** | assembly-pico-exploded-top | **OK** - Top hat separated above, bottom tray below. Side flaps separated to left and right with blue hinge knuckles. Red SSD harness at bottom. Composition is correct. |

## Issues Found

### Critical (must fix before merge)

**#1 - Back panel missing I/O shield cutout**
- **Evidence**: `build-parts_case_pico_back_panel-iso.png`, `assembly-pico-back.png`
- **Problem**: The back panel (`PicoBackPanel` in `src/parts/case_pico.py:320`) only has a barrel jack hole. There is no rectangular cutout for the motherboard I/O shield (USB, HDMI, Ethernet, audio). The motherboard ports would be completely blocked.
- **Remediation**: Add a rectangular cutout matching the Mini-ITX I/O shield dimensions (159mm x 44.45mm per ATX spec) positioned at the correct height (`io_shield_z_offset` from config). Reference the SCAD legacy back panel for exact positioning.

**#2 - Back panel retains legacy dovetails**
- **Evidence**: `build-parts_case_pico_back_panel-iso.png` (blue/orange dovetail protrusions on all edges)
- **Problem**: Plan Phase 2 states the back panel should be integrated into the bottom tray and dovetails removed. `PicoBackPanel` (`case_pico.py:362-394`) still creates `MaleDovetail` instances on bottom and both sides. Plan also specifies "add latch lip at top edge" for the hook closure.
- **Remediation**: Remove all dovetail code from `PicoBackPanel`. Add a latch lip (small shelf/ledge) at the top edge where `LatchHook` engages. The back panel is now part of the bottom tray assembly, not a standalone joined part.

### Major (should fix)

**#3 - Side flaps missing honeycomb ventilation**
- **Evidence**: `build-parts_case_pico_side_flap_left-iso.png`, `build-parts_case_pico_side_flap_right-iso.png`
- **Problem**: Side flaps render as rectangular frames with completely open centers (no honeycomb pattern). Plan Phase 4 specifies "Flat side panel with honeycomb ventilation." Currently they are just open holes, which provides zero dust protection and looks unfinished.
- **Remediation**: Add honeycomb cutout pattern to the side flap center area, matching the pattern used on the top hat. A solid panel with hex holes, not an open frame.

**#4 - Side flaps have only 1 hinge knuckle each**
- **Evidence**: `build-parts_case_pico_side_flap_left-iso.png` (single blue stub on top edge)
- **Problem**: Plan specifies "3 alternating knuckles per side" for the side hinges connecting flaps to top hat. Only 1 knuckle is visible per flap, which would provide inadequate support and allow the flap to pivot/wobble.
- **Remediation**: Increase to 3 knuckles evenly spaced along the top edge of each side flap. Ensure the mating top hat edges have the complementary 2 knuckles for the alternating pattern.

### Minor (consider fixing)

**#5 - Hinge knuckle lacks pin/socket geometry**
- **Evidence**: `build-parts_hinge_knuckle-iso.png` (plain decagonal cylinder)
- **Problem**: Plan specifies "Pin is part of one knuckle, socket in the other - snap-fits together" with 0.3mm clearance. The rendered knuckle appears as a plain barrel with no internal pin/socket differentiation.
- **Remediation**: Add a pin protrusion to male knuckles and a matching socket bore to female knuckles. This is what enables snap-fit assembly without a separate hinge pin.

**#6 - SSD harness retention geometry minimal**
- **Evidence**: `build-parts_ssd_harness-{iso,front,top}.png` (thin cross-shaped bars only)
- **Problem**: The harness is two thin bars forming a cross with screw channels. While the divider/lip zones are present, the lips that actually retain SSDs against gravity (especially when the top hat is open/flipped) appear very thin. The legacy SCAD design had more substantial retention lips.
- **Remediation**: Verify lip height (currently 9mm `divider_h`) is sufficient to prevent SSD from sliding out when case is open. Consider adding a second horizontal lip for the front-right SSD zone.

**#7 - Hinge line knuckle count**
- **Evidence**: `build-parts_hinge_line-iso.png` (only 2 knuckles visible, widely spaced)
- **Problem**: Plan specifies 5 alternating knuckles for the 176mm front hinge. The rendered hinge line shows only 2 barrels with very wide spacing.
- **Remediation**: Check `HingeLine` parameters - ensure `knuckle_count` is set to 5 for the front hinge and spacing distributes them evenly across the 176mm edge.

## Plan Compliance Checklist

| Planned Feature | Status | Notes |
|----------------|--------|-------|
| Phase 1: HingeKnuckle with pin/socket | Partial | Knuckle renders but appears as plain cylinder, no snap-fit geometry visible |
| Phase 1: HingeLine alternating knuckles | Partial | Renders 2 knuckles, plan specifies 5 for front edge |
| Phase 1: LatchHook press-to-release | Partial | U-channel shape present, no visible flex tab |
| Phase 2: Bottom tray base + back + walls | Present | Integrated structure with L-shaped lip visible |
| Phase 2: Bottom tray front hinge knuckles | Present | Blue stubs at front edge |
| Phase 2: Bottom tray standoff bosses | Present | 4 hex pocket standoffs match Mini-ITX |
| Phase 3: Top hat with honeycomb vent | Present | Honeycomb visible in assembly views on top surface |
| Phase 3: Top hat SSD harness integrated | Present | Cross-shaped harness attached to underside |
| Phase 3: Top hat front hinge knuckles (male) | Present | Corner stubs visible |
| Phase 3: Top hat side hinge knuckles (female) | Present | Side stubs visible |
| Phase 3: Top hat back-edge latch hooks | Not verified | Not clearly visible in screenshots |
| Phase 4: Side flap honeycomb ventilation | **Missing** | Open frames, no honeycomb fill |
| Phase 4: Side flap top-edge hinge knuckles | Partial | Only 1 per flap, plan says 3 |
| Phase 4: Side flap inward ledge | Present | Blue/orange bottom edge geometry visible |
| Phase 5: Assembly normal/exploded/open | Present | All 3 variants render across 6 angles |
| Back panel I/O shield cutout | **Missing** | Only barrel jack hole present |
| Back panel dovetails removed | **Not done** | Legacy dovetails still present |
| Back panel latch lip at top | **Not done** | No lip geometry visible |

## Summary

The overall structure of the hinged top hat design is taking shape: the bottom tray, top hat, and side flaps compose correctly in assembly views, and the hinge-based open/close concept is evident. However, two critical functional issues prevent approval:

1. The back panel would completely block motherboard I/O ports (no cutout)
2. The back panel still uses the old dovetail system instead of the new latch mechanism

Additionally, the side flaps need honeycomb ventilation (currently open frames) and more hinge knuckles for proper support. The hinge snap-fit geometry (pin/socket) should be verified to ensure the parts actually interlock.
