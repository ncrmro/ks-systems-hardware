# Plan: Pico Mini-ITX with Hinged Top Hat for 2x 2.5" SSDs

## Task

Redesign the Pico case assembly to replace fragile dovetail connectors with snap-fit 3D printed hinges. The top hat (tall top panel holding 2x 2.5" SSDs) folds forward on a front hinge. Top and sides are connected through printed hinges or durable snap-fit connectors. All parts remain flat-printable. BOM: 3D printed parts only (no screws for panel assembly, only for SSD/mobo mounting).

## Context

### Problems with current dovetail design
- Dovetails are **extremely fragile** in PLA/PETG — the flex arms and 0.8mm catch bumps break after a few open/close cycles
- Complex assembly — 5+ panel edges with dovetails, each with specific male/female/clip/non-locking assignments
- SSD harness required removing dovetails from multiple corners to clear the drives, weakening the structure further
- Two-shell concept (top shell slides off) requires precision across all edges simultaneously
- **Side panel rigidity**: Side panels could easily be pushed inward when squeezed — the original retention lip system (3mm x 3mm lips per SPEC.md 9.2.1) was insufficient. No positive mechanical stop prevented inward deflection under lateral pressure.

### What we're keeping
- **Bottom panel** with integrated standoff bosses (M3 hex pockets) — proven design
- **Back panel** with barrel jack cutout — unchanged
- **Honeycomb ventilation** pattern on top panel
- **SSD harness** concept from legacy OpenSCAD (2 drives in diagonal corners), but now built into a taller "top hat" panel
- **176mm x 176mm footprint** (Pico dimensions)

### What we're replacing
- **Dovetail joints everywhere** → snap-fit printed hinges at specific edges
- **Two-shell slide-off** → top hat folds forward on front hinge for access
- **Side panels as separate parts** → sides fold out on hinges attached to the top hat

### Key dimensions
- Mobo: 170mm x 170mm (Mini-ITX)
- Wall thickness: 3mm
- Pico case footprint: 176mm x 176mm
- Current interior height: ~57mm (standoff 6mm + PCB 1.6mm + I/O shield 44.45mm + 5mm offset)
- "Server" variation adds 15mm for SSDs → interior ~72mm
- SSD: 100mm x 69.85mm x 9.5mm (typical 2.5")
- Top hat needs enough height for SSD harness lips (9mm) + SSD (9.5mm) + clearance

## New Assembly Concept

### Three-piece design

```
     ┌──────────────────────┐
     │     TOP HAT          │ ← Folds forward on front hinge
     │  (top + SSD harness) │    Sides fold out on side hinges
     │  ┌────┐      ┌────┐  │
     │  │SSD1│      │SSD2│  │
     └──┤    ├──────┤    ├──┘
        └────┘      └────┘
   ─────────────────────────── ← Front hinge axis
     ┌──────────────────────┐
     │     BOTTOM TRAY      │ ← Base + back panel (one piece or joined)
     │  [mobo + cooler]     │    Sits on surface, does not move
     └──────────────────────┘
```

1. **Bottom tray** — base panel + back panel + low side walls (one piece or permanently joined). Holds motherboard, standoffs, PSU. This sits on the desk.

2. **Top hat** — top panel with integrated SSD harness underneath + fold-out side panels. Connected to bottom tray via **front hinge**.

3. **Side flaps** — integrated into the top hat via **side hinges**. When closed, they form the case sides. When the top hat is folded forward, the sides fold outward for full access.

### Hinge design

**Print-in-place barrel hinge** (snap-fit):
- Two interlocking knuckles with a cylindrical pin axis
- Pin is part of one knuckle, socket in the other — snap-fits together
- ~5mm barrel diameter, 0.3mm clearance for FDM
- Knuckles alternate along the hinge line (e.g., 3 knuckles on one part, 2 on the other)
- Prints flat — knuckle halves nest when panel is unfolded

**Front hinge** (top hat ↔ bottom tray):
- Runs along the full front edge (176mm)
- 5 alternating knuckles
- Allows top hat to fold forward ~110° (past vertical for full access)
- Hinge axis at Z = bottom tray top edge

**Side hinges** (side flaps ↔ top hat):
- Run along the top panel's left and right edges
- 3 alternating knuckles per side
- Allow sides to fold outward when top hat is open
- Hinge axis at the top edge of each side

### Side panel rigidity — inward ledge system

The original design's side panels could be pushed inward when squeezed because the small retention lips provided no real structural resistance. The new design solves this with a **ledge-and-channel interlock**:

```
  Cross-section (looking from front):

  Top hat (closed position)
  ┌─────────────────────────┐
  │         top panel        │
  ├─┐                     ┌─┤
  │ │ side                │ │ side
  │ │ flap                │ │ flap
  │ │                     │ │
  │ ├─┐               ┌─┤ │  ← Inward ledge on side flap
  │ │  │               │  │ │    hooks UNDER bottom tray lip
  └─┘  │               │  └─┘
  ┌────┤               ├────┐
  │    │  bottom tray   │    │  ← Bottom tray side wall with
  │    │  side wall     │    │    outward lip at top
  └────┴───────────────┴────┘
```

**Bottom tray side walls**:
- ~10mm tall walls along left and right edges
- Outward-facing **lip** at the top edge (3mm wide, 2mm tall) — an L-shaped profile
- The lip creates a shelf that the side flap's bottom edge hooks under

**Side flap bottom edge**:
- Inward-facing **ledge** (3mm wide, 2mm tall) at the bottom of each side flap
- When closed, this ledge slides under the bottom tray's lip
- Any inward squeeze pressure is transferred through the ledge into the bottom tray wall — the side flap physically cannot deflect inward past the lip

**Why this works**:
- The interlock is a **positive mechanical stop** — not friction-dependent like the old retention lips
- The load path goes: side flap → ledge → bottom tray wall → base panel. Compressive, not bending.
- The ledge naturally engages when closing the top hat (side flaps fold down and the ledge slides under the lip)
- Also prevents the side flaps from falling open — they're captured between the top hat hinge above and the bottom tray lip below

### Closure/latch mechanism

Instead of dovetails, use simple **hook latches** at the back:
- Small hook on top hat's back edge snaps over a lip on the back panel
- Press-to-release tab (similar to battery cover on electronics)
- 2 latches total (one per back corner)
- Much more durable than dovetails — larger cross-section, simpler geometry

## Files to Modify

### `src/config.py`
- Add `PicoServerDimensions` (or update `PicoDimensions` variation="server") with:
  - `tophat_interior_height`: space for SSD harness + drives
  - `hinge_barrel_diameter`: 5.0mm
  - `hinge_clearance`: 0.3mm
  - `hinge_knuckle_width`: 10mm
  - `latch_hook_height`: 3mm
  - `side_wall_height`: 10mm (bottom tray side walls)
  - `side_lip_width`: 3mm (outward lip on bottom tray side wall)
  - `side_lip_height`: 2mm (lip + ledge interlock height)
  - `side_ledge_width`: 3mm (inward ledge on side flap bottom edge)

### `src/parts/case_pico.py`
- **Modify `PicoBasePanel`** — remove dovetail references, keep standoff bosses
- **Modify `PicoBackPanel`** — remove dovetail males, add latch lip at top edge
- **Modify `PicoSidePanel`** — remove dovetails. Side panels become flaps attached to top hat
- **Replace `PicoTopShell` / `PicoBottomShell`** with:
  - `PicoBottomTray` — base + back + low walls (single printable part or assembly)
  - `PicoTopHat` — top panel + SSD harness underneath + hinge knuckles on front edge
  - `PicoSideFlap` — side panel with hinge knuckles on top edge

### `src/parts/dovetail.py`
- **No changes needed** for this task (dovetails still exist for other configs)
- May eventually remove once all configs migrate to hinges

### `src/parts/hinge.py` (NEW)
- `HingeDimensions` — dataclass with barrel diameter, clearance, knuckle width, knuckle count
- `HingeKnuckle` — single barrel knuckle (male or female)
- `HingeLine` — row of alternating knuckles along an edge
- `LatchHook` — press-to-release hook for back panel closure

### `src/parts/ssd_harness.py` (NEW)
- Port from legacy `modules/case/panels/standard/top_pico.scad`
- `SsdHarness` — lips + screw channels for 2x 2.5" drives in diagonal corners
- Integrated into `PicoTopHat` as interior geometry

### `src/assemblies/pico.py`
- Update `PicoAssembly` to use new `PicoBottomTray` + `PicoTopHat` + `PicoSideFlap`
- Add exploded/open views showing top hat folded forward

## Approach

### Phase 1: Hinge system (`src/parts/hinge.py`)
1. Create `HingeDimensions` dataclass with parametric values
2. Implement `HingeKnuckle` — cylindrical barrel with pin/socket halves
3. Implement `HingeLine` — array of alternating knuckles along a given length
4. Implement `LatchHook` — simple press-to-release hook
5. Test: Render individual hinge and latch parts, verify dimensions

### Phase 2: Bottom tray (`PicoBottomTray`)
1. Start from existing `PicoBasePanel` (standoff bosses, hex pockets)
2. Add integrated back wall (from `PicoBackPanel` — barrel jack hole)
3. Add low side walls (~10mm) with **outward L-shaped lip** at top edge (3mm wide, 2mm tall) — this is the female half of the rigidity interlock
4. Add front-edge hinge knuckles (female sockets)
5. Test: Render, verify standoff positions match Mini-ITX pattern, verify lip profile

### Phase 3: Top hat (`PicoTopHat`)
1. Top panel with honeycomb ventilation (from existing code)
2. Port SSD harness from legacy OpenSCAD — lips, screw channels, diagonal layout
3. Add front-edge hinge knuckles (male pins) — mates with bottom tray
4. Add left/right edge hinge knuckles (female sockets) — mates with side flaps
5. Add back-edge latch hooks
6. Test: Render, verify SSD positions don't interfere with cooler

### Phase 4: Side flaps (`PicoSideFlap`)
1. Flat side panel with honeycomb ventilation
2. Top-edge hinge knuckles (male pins) — mates with top hat
3. **Inward ledge** at bottom edge (3mm wide, 2mm tall) — hooks under bottom tray lip when closed, prevents inward deflection
4. Height matches: bottom tray side wall height + main chamber height (so ledge aligns with lip when closed)
5. Test: Render, verify height, hinge alignment, and ledge-to-lip engagement in closed position

### Phase 5: Assembly (`PicoAssembly`)
1. Compose bottom tray + top hat + side flaps
2. Add motherboard assembly inside
3. Add exploded view with top hat folded forward
4. Test: Full render, screenshot all angles, verify clearances

## Patterns to Follow

- Registration: `@register_part("pico_tophat")` with factory function
- Shape class: `@ad.shape` + `@datatree` decorator
- Composition: `maker = shape.solid().at(...)` then `maker.add_at(...)`
- Config: Import dimensions from `config.py` PicoDimensions, not hardcoded
- Anchors: Define `@ad.anchor` for hinge connection points
- Boolean: Use `shape.hole().at(...)` for cutouts (honeycomb, barrel jack, screw channels)

## Risks

- **Hinge durability**: Barrel hinges in PLA can be fragile at small diameters. 5mm barrel with 0.3mm clearance should work but may need tuning. PETG recommended for hinges.
- **Print-in-place vs separate**: May need to print hinges as separate snap-together pieces rather than print-in-place, depending on FDM tolerances. Design should support both.
- **SSD clearance**: With the top hat folded to ~110°, the SSD harness lips must not catch on the motherboard components below. Need to verify clearance path.
- **Side flap retention**: Sides hinge at top hat's edge and fold outward for access. When closed, the inward ledge hooks under the bottom tray lip — this captures the flap and prevents both inward deflection and accidental opening. The back latches provide the final lock. If the ledge/lip tolerances are too tight, flaps won't close easily; too loose and they'll rattle. Target 0.2mm clearance.
- **AnchorSCAD complexity**: The `ad.render` function can fail with complex boolean operations in headless mode. Keep geometry simple, test incrementally.
