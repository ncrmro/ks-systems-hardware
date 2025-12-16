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
- **Registry:** Parts are registered using `@registry.register_part("name")` (defined in `src/registry.py`).
- **Configuration:** `src/config.py` uses `@anchorscad.datatree` to define parametric dimensions (`CommonDimensions`, `PicoDimensions`, etc.).
- **Organization:**
  - `src/lib/`: **Vitamins** (Off-the-shelf parts like Motherboards, PSUs). These define their own dimensions.
  - `src/parts/`: **Fabricated Parts** (3D printed/machined). These derive dimensions from `config.py`.
- **Build System:** `bin/render`
  - **Discovery:** Recursively imports `parts` package to trigger registration.
  - **Output:** Generates `.scad` and `.stl` files in `build/`.
  - **Usage:**
    - `bin/render`: Build all registered parts.
    - `bin/render [filter]`: Build parts matching the filter string.
    - `bin/render --list`: List all registered parts.
    - `bin/render --scad-only`: Skip STL generation (faster).
    - `bin/watch`: Watch for changes in `src/`, run tests, then build.

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

3.  **Testing:**
    - **PREFERRED:** Run `bin/test` to execute the project's verification suite (pytest). This is the standard way to ensure all tests pass.
    - Tests are located in `tests/`.
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

## Dependencies
- **Python:** `anchorscad`, `numpy`, `watchdog`, `pytest`.
- **System:** `openscad` CLI required for STL generation.
- **Environment:** Managed via `uv`.
- **Imports:** Source root is `src/`. Imports should be absolute (e.g., `from lib.motherboard import ...`).

## Key Files
- `src/registry.py`: Registry logic.
- `src/config.py`: Global configuration and dimensions.
- `bin/render`: Main build script (mocks OpenGL).
- `bin/watch`: Watcher hook (runs tests before build).
