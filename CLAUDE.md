# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Keystone Hardware is an OpenSCAD project for designing a modular, expandable computer case. The case supports multiple configurations:

- **Minimal**: Mini-ITX motherboard + Flex ATX PSU (horizontal orientation)
- **NAS 2-disk**: Base + 2 HDDs mounted underneath (passive chimney airflow)
- **NAS many-disk**: Base + 5-8 HDDs with active fan cooling
- **GPU**: Vertical orientation with full-size GPU, all I/O facing bottom

## Commands

Preview a model in OpenSCAD:
```bash
openscad mini.scad
openscad assemblies/minimal.scad
openscad assemblies/gpu.scad
```

Render to STL (for 3D printing):
```bash
openscad -o output.stl assemblies/minimal.scad
```

## Architecture

### Directory Structure

```
modules/
├── case/
│   ├── dimensions.scad      # Shared dimensions - INCLUDE in files needing variables
│   ├── base/                # Motherboard plate, backplate, standoffs
│   ├── panels/standard/     # Panels for minimal/NAS configs
│   ├── panels/gpu/          # Panels for GPU config (taller)
│   ├── gpu/                  # GPU mounting brackets
│   ├── nas_2disk/           # 2-disk NAS enclosure parts
│   └── nas_many/            # Many-disk NAS enclosure parts
├── components/              # Hardware models (motherboard, PSU, HDD, etc.)
│   ├── power/               # PSU models (SFX, Flex ATX)
│   ├── storage/             # HDDs, SSDs
│   └── cooling/             # Fans, radiators, AIO
└── util/
    └── honeycomb.scad       # Ventilation pattern utility

assemblies/                  # Complete case assemblies
├── minimal.scad             # Barebones case
├── nas_2disk.scad           # With 2-disk NAS
├── gpu.scad                 # GPU configuration
└── gpu_aio.scad             # GPU with liquid cooling
```

### OpenSCAD Patterns

**Include vs Use:**
- `include <file.scad>` - imports variables AND modules (use for `dimensions.scad`)
- `use <file.scad>` - imports only modules (use for component files)

**Module structure:**
```openscad
include <../modules/case/dimensions.scad>  // Get shared dimensions
use <../modules/components/motherboard.scad>  // Get modules only
```

**Shared dimensions** are defined in `modules/case/dimensions.scad`. Key variables:
- `mobo_width/depth` (170mm Mini-ITX)
- `wall_thickness` (3mm)
- `standoff_height` (6mm)
- `interior_chamber_height` (standoffs + mobo + cooler, ~94mm)
- `minimal_exterior_height` (~100mm)
- Panel dimensions:
  - `interior_panel_width/depth` (220mm x 170mm) - for top/bottom
  - `side_panel_height/depth` (100mm x 176mm) - for left/right
  - `front_back_panel_width/height` (220mm x 100mm) - for front/back
- `flex_atx_*`, `sfx_*` (PSU dimensions)
- `gpu_config_width/depth/height` (171x378x190mm)

### Panel Positioning

Panels fall into two categories:

**Exterior panels** (form the outer shell):
- Side panels: Full exterior height, positioned at Z=0, X=0 or X=case_width-wall_thickness

**Interior panels** (fit between walls):
- Top/bottom: Interior width/depth, positioned at X=wall_thickness, Y=wall_thickness
- Front/back: Interior width, full exterior height, positioned at X=wall_thickness, Z=0

### Key Design Patterns

1. **Assemblies** combine case parts and components with positioning logic
2. **Toggle flags** (`show_panels`, `show_components`, `explode`) enable debugging
3. **Color coding** distinguishes parts:
   - blue = motherboard plate
   - red = backplate (I/O panel)
   - gray = all other panels (side, top, bottom, front)
   - purple = PCBs (motherboard)
   - green = PSU
4. **Honeycomb ventilation** uses the `honeycomb_xz()` utility module

## Reference Documents

- `SPEC.md` - Full design specification with dimensions and requirements
- `TASKS.md` - Component tracking with ✅/❌ status and priority phases
