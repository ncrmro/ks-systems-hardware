# Keystone Hardware - AI Agent Context

## Project Overview
Keystone Hardware is a modular, expandable computer case. The project is currently **migrating from legacy OpenSCAD (`modules/*.scad`) to Python-generated OpenSCAD (`src/`)** using the `anchorscad` library.

**Key Documentation:**
- `SPEC.md`: Full design specification, dimensions, and requirements.
- `CLAUDE.md`: Guidance for the legacy OpenSCAD workflow and detailed architectural notes for the existing codebase.
- `TASKS.md`: Component tracking and development phases.

## Architecture

### Python/AnchorSCAD (Active Development)
This is the active development area for new features and migration.
- **Source:** `src/` (Root package directory).
- **Library:** Uses `anchorscad` for geometry generation.
- **Registry:** Parts are registered using `@registry.register_part("name", part_type="component")` (defined in `src/registry.py`). Registry stores `(factory, part_type)` tuples. Gallery sort order: `assembly` (1) → `component` (2) → `vitamin_assembly` (3) → `vitamin` (4).
- **Configuration:** `src/config.py` uses `@anchorscad.datatree` to define parametric dimensions (`CommonDimensions`, `PicoDimensions`, etc.).
- **Organization:**
  - `src/vitamins/`: **Vitamins** (Off-the-shelf parts). Things you buy (Motherboards, PSUs, Heatsinks). These define the fixed interfaces.
  - `src/components/`: **Fabricated Parts** (3D printed/machined). Things you make (Shells, Frames, Brackets). These derive dimensions from `config.py`.
  - `src/assemblies/`: **System Builds**. Top-level compositions of Components + Vitamins (e.g., `PicoAssembly`).
- **CADeng Integration:** `cadeng.yaml` defines projects, models, and camera angles for the gallery server. The optional `projects:` section groups models into named gallery tabs:
    ```yaml
    projects:
      - name: pico
        label: Pico
        models: [assembly_pico, component_pico_shell, vitamin_miniitx]
      - name: gpu
        label: GPU
        models: []
    ```
    - `label` is auto-generated from `name` if omitted (splits on `-_`, title-cases)
    - Model references are validated against the top-level `models:` list at startup — invalid references cause an error
    - Gallery shows "All" tab plus one tab per project for filtering
- **Build System:** `bin/render`
  - **Discovery:** Recursively imports `vitamins`, `components`, and `assemblies` packages to trigger registration.
  - **Output:** Generates `.scad` and `.stl` files in `build/`.
  - **Usage:**
    - `bin/render`: Build all registered parts.
    - `bin/render [filter]`: Build parts matching the filter string.
    - `bin/render --list`: List all registered parts.
    - `bin/render --list-json`: Output JSON for cadeng gallery integration.
    - `bin/render --scad-only`: Skip STL generation (faster).
    - `cadeng`: Start the gallery server (requires `nix develop`).

### Legacy OpenSCAD (Reference)
- **Source:** `modules/` and `assemblies/`.
- **Status:** Reference only. **Do not import these files.** Recreate geometry in pure Python.
- **Context:** See `CLAUDE.md` for detailed structure of this legacy code.

## Development Workflow

1.  **Create/Edit Part:**
    - Define a class decorated with `@ad.shape`.
    - Use `@ad.anchor` to define connection points.
    - Register the part with `@registry.register_part("part_name")`.

2.  **Verify/Render:**
    - Run `bin/watch` to automatically test and render on file save.
    - Run `bin/render [part_name]` to manually generate SCAD/STL.
    - **Visual Verification:** `bin/screenshots pico` to screenshot all models whose assembly/component path contains `pico` from all angles (this may include multiple pico-related models). Use `bin/screenshots --all` for everything. Use `bin/screenshots --scan-dir build/` for arbitrary .scad files. Screenshots are saved to `screenshots/` with the angle encoded in the filename (e.g., `assembly-pico-iso.png`, `assembly-pico-exploded-front.png`).

3.  **Testing (Strict Requirement):**
    - **Methodology:** Utilize the existing test infrastructure (`pytest` via `bin/test`) to verify geometry and logic. **Do not create one-off debugging scripts.** This ensures reproducible verification and prevents regression.
    - **Recommended Workflow:**
        1. **Isolate:** Create a focused unit test (e.g., in `tests/`) that asserts the specific geometric condition (e.g., "Part A top must equal Part B bottom").
        2. **Verify Failure:** Run the test with `bin/test <test_file>` to confirm it fails (demonstrating the bug).
        3. **Fix:** Modify the source code.
        4. **Verify Success:** Run the test again to confirm it passes.
    - `tests/hardware_components_dimensions_test.py` verifies core dimensions.

4.  **Committing:**
    - Always use **Semantic Commit Messages** with a clear subject line.
    - Format: `<type>(<scope>): <subject>`
    - Example: `feat(mobo): add ATX connector to MiniITX motherboard`
    - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

## AnchorSCAD Patterns & Gotchas

- **Composites:** `ad.CompositeMaker` does not exist. Use the "first component as root" pattern:
  ```python
  maker = first_shape.solid().at(...)
  maker.add_at(second_shape.solid().at(...))
  return maker
  ```
- **Boolean Operations:** `Maker` objects do NOT support `-` operator. Use `HoleMode`:
  ```python
  body = shape.solid().at(...)
  hole = other_shape.hole().at(...)
  body.add_at(hole) # Subtraction
  ```
- **Coloring:** Apply `.colour()` to the `SolidMode` **before** `.at()`:
  ```python
  # CORRECT:
  shape.solid("name").colour("red").at("centre")
  # INCORRECT:
  shape.solid("name").at("centre").colour("red") # AttributeError
  ```
- **Matrices:** Use `ad.IDENTITY` (constant), not `ad.identity()`.
- **Dataclasses:** Import `field` from `dataclasses`, not `anchorscad.datatree`.
- **Headless Rendering:** `ad.render` may fail with internal errors (`AttributeError: 'str' object has no attribute 'A'`) in the headless test environment. Avoid full geometry intersection tests; rely on logic/dimension tests.
- **cadeng.yaml Sync:** When `@register_part()` names change (rename, not just add/delete), **both** `cadeng.yaml` sections must be updated: the project `models:` list AND the top-level `models:` definitions. Tests and SCAD generation pass without cadeng.yaml updates (registry is independent), so the mismatch is silent until you check the gallery.

## Coordinate System Convention

**Front/Back Orientation:**
- IO shield / rear ports side is the **BACK** of the case (+Y in model coordinates)
- Opposite side (front panel, power button) is the **FRONT** (-Y in model coordinates)
- This convention ensures isometric views in the gallery show the front of the case facing the viewer

All motherboard, PSU, and case shell models follow this convention. When composing assemblies, ensure components are oriented with their fronts aligned.

## ASCII Clean-Box Diagram Convention

Hardware documentation (specs, IO shield layouts, panel dimensions) should include ASCII diagrams following these 5 rules:

### 1. Canvas & Bounding Box
Draw physical edges with `|` and `_`. Leave 4-6 space margins on left/right for external metadata.

### 2. Strict Column Grid
Connector positions and headers use fixed-width blocks (e.g., `[USB]`, `[ETH]`, `[AUD]`). Every character slot aligns vertically.

### 3. External Pin Mapping
Port names, signal types, and connector labels go **outside** the board/panel borders. The margins are the guides. Never put labels inside the outline.

### 4. Center Voiding
Only render internal components that require user interaction (power button, USB port) or dictate orientation (mounting holes, standoffs). Omit traces, silkscreen, and internal routing.

### 5. Detached Footer Legend
Below the diagram, add a `--- LEGEND & DIMENSIONS ---` block with physical footprint (W x H x D) and abbreviation key.

### Example: Mini-ITX IO Shield

```
                   _______________________________________
                  |                                       |
   USB 3.0  ←  [USB]  [USB]                  [ETH]  → RJ45
                  |                                       |
   HDMI     ←  [HDMI]         [AUD] [AUD] [AUD]    → Audio
                  |                                       |
   USB 2.0  ←  [USB]  [USB]        [DP]            → DisplayPort
                  |_______________________________________|

  --- LEGEND & DIMENSIONS ---
  Panel: Mini-ITX IO Shield  |  159mm x 44.5mm
  [USB] = USB Type-A port
  [ETH] = RJ45 Ethernet jack
  [HDMI] = HDMI video output
  [AUD] = 3.5mm audio jack
  [DP] = DisplayPort video output
```

## Dependencies
- **Python:** `anchorscad`, `numpy`, `watchdog`, `pytest`.
- **System:** `openscad` CLI required for STL generation.
- **Environment:** Managed via `uv`.
- **Imports:** Source root is `src/`. Imports should be absolute (e.g., `from vitamins.motherboard import ...`).

## Key Files
- `src/registry.py`: Registry logic.
- `src/config.py`: Global configuration and dimensions.
- `bin/render`: Main build script (mocks OpenGL).
- `bin/screenshots`: Screenshot generator. Defines camera angles (iso, front, back, top, right, left) and rendering settings. Uses `--autocenter --viewall` for auto-framing.
- `bin/watch`: Watcher hook (runs tests before build).

## Learnings

Record confirmed findings here as they are discovered. Format: `### YYYY-MM-DD: Title` with details below. Useful categories:

- **Dimensional tolerances** — measured vs. modeled dimensions, printer-specific shrink/growth
- **Printability** — orientation constraints, support requirements, build-plate contact rules
- **AnchorSCAD bugs/workarounds** — library-specific issues encountered during development
- **Assembly fit** — clearance values that work, interference findings from physical builds