# Keystone Hardware - AI Agent Context

## Project Overview
Keystone Hardware is a modular, expandable computer case. The project is currently **migrating from legacy OpenSCAD (`modules/*.scad`) to Python-generated OpenSCAD (`src/keystone`)** using the `anchorscad` library.

**Key Documentation:**
- `SPEC.md`: Full design specification, dimensions, and requirements.
- `CLAUDE.md`: Guidance for the legacy OpenSCAD workflow and detailed architectural notes for the existing codebase.
- `TASKS.md`: Component tracking and development phases.

## Architecture

### Python/AnchorSCAD (Active Development)
This is the active development area for new features and migration.
- **Source:** `src/keystone/` package.
- **Library:** Uses `anchorscad` for geometry generation.
- **Registry:** Parts are registered using `@keystone.register_part("name")` (defined in `src/keystone/__init__.py`).
- **Configuration:** `src/keystone/config.py` uses `@anchorscad.datatree` to define parametric dimensions (`CommonDimensions`, `PicoDimensions`, etc.).
- **Organization:**
  - `src/keystone/lib/`: **Vitamins** (Off-the-shelf parts like Motherboards, PSUs). These define their own dimensions.
  - `src/keystone/parts/`: **Fabricated Parts** (3D printed/machined). These derive dimensions from `config.py`.
- **Build System:** `bin/render`
  - **Discovery:** Recursively imports `keystone.parts` to trigger registration.
  - **Output:** Generates `.scad` and `.stl` files in `build/`.
  - **Usage:**
    - `bin/render`: Build all registered parts.
    - `bin/render [filter]`: Build parts matching the filter string.
    - `bin/render --list`: List all registered parts.
    - `bin/render --scad-only`: Skip STL generation (faster).

### Legacy OpenSCAD (Reference)
- **Source:** `modules/` and `assemblies/`.
- **Status:** Reference only. Currently being ported to Python.
- **Context:** See `CLAUDE.md` for detailed structure of this legacy code.
- **Screenshots:** `bin/screenshots` is currently hardcoded to generate images from these legacy files.

## Development Workflow

1.  **Create/Edit Part:**
    - Define a class decorated with `@ad.shape`.
    - Use `@ad.anchor` to define connection points.
    - For fabricated parts, accept a `dimensions` object (from `config.py`) in `__init__`.
    - Register the part with `@keystone.register_part("part_name")`.

2.  **Verify/Render:**
    - Run `bin/render [part_name] --scad-only` to generate the SCAD file in `build/`.
    - Open `build/[part_name].scad` in OpenSCAD to inspect.
    - Run `bin/render [part_name]` to generate the STL.

3.  **Assemblies:**
    - Use `ad.Maker()` to create assemblies.
    - Use `maker.add_at(shape, anchor=..., post=...)` to position parts.
    - Avoid raw matrix multiplication; use anchors.

## Dependencies
- **Python:** Requires `anchorscad` and standard libraries.
- **System:** Requires `openscad` CLI to be in the PATH for STL generation.
- **Environment:** Project uses `uv` for dependency management. `pyproject.toml` and `uv.lock` are tracked.
  - Run `uv sync` to install dependencies.
  - Run `bin/render` (which uses `uv run`) to build.

## Key Files
- `src/keystone/__init__.py`: Registry logic.
- `src/keystone/config.py`: Global configuration and dimensions.
- `bin/render`: Main build script.
- `bin/screenshots`: Legacy screenshot tool.

## Common Issues & Notes
- **OpenGL Mocking:** `bin/render` mocks `OpenGL` to prevent crashes in headless environments (AnchorSCAD imports it).
- **Anchors:** `shape.at()` returns a matrix, not a transformed shape. Use `Maker.add_at` to apply transformations.
- **Datatrees:** Use `field(default_factory=...)` for mutable defaults in datatree classes.