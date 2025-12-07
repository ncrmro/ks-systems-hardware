# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Keystone Hardware is an OpenSCAD project for designing a modular, expandable computer case. The case supports multiple configurations:

- **Minimal**: Mini-ITX motherboard + Flex ATX PSU (horizontal orientation)
  - Case dimensions: ~226mm wide (controlled by NAS 2-disk layout)
  - PSU stands on side (40mm width) in compartment next to motherboard
- **NAS 2-disk**: Base + 2 HDDs mounted underneath (passive chimney airflow)
  - HDDs lie flat side-by-side in roofless enclosure
  - Connects via 4x #6-32 corner mounting holes
- **NAS many-disk**: Base + 5-8 HDDs with active fan cooling
  - HDDs mounted vertically (on narrow edge)
  - Uses same 4x #6-32 corner mounting system
- **GPU**: Vertical orientation with full-size GPU, all I/O facing bottom
  - Max GPU: 320mm length, 3-slot width (60mm)
  - PCIe riser cable required
  - SFX PSU mounted above motherboard
  - Internal power cable routes PSU to bottom-mounted C14 inlet

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
│   ├── base/                # Backplate (I/O shield mounting) - Note: motherboard_plate.scad deprecated
│   ├── panels/standard/     # Panels for minimal/NAS configs (bottom panel has integrated standoff mounting)
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
- `mobo_pcb_thickness` (1.6mm)
- `wall_thickness` (3mm)
- `standoff_height` (6mm female thread portion of M3x10+6mm standoff)
- `standoff_hole_radius` (1.6mm, M3 clearance - deprecated, see integrated design)
- `standoff_locations` - array of 4 Mini-ITX mounting positions
- **Integrated Bottom Panel Standoff Mounting:**
  - `standoff_boss_height` (2.5mm above panel surface)
  - `standoff_hex_size_flat_to_flat` (5.5mm for M3 hex head)
  - `standoff_mounting_screw_length` (8mm, M3 socket head cap screw)
- `interior_chamber_height` (standoffs + mobo + cooler, ~94mm)
- `minimal_exterior_height` (~100mm)
- `minimal_with_psu_width` (~226mm, controlled by NAS 2-disk layout)
- Panel dimensions:
  - `interior_panel_width/depth` (220mm x 170mm) - for top/bottom
  - `side_panel_height/depth` (100mm x 176mm) - for left/right
  - `front_back_panel_width/height` (220mm x 100mm) - for front/back
  - `panel_screw_radius`, `panel_screw_inset` - for mounting holes
- PSU dimensions:
  - `flex_atx_*` (40x150x80mm, standing orientation)
  - `flex_atx_mount_holes` - array of 3 mounting positions (8-32 UNC)
  - `sfx_*` (125x100x63.5mm)
  - `psu_compartment_width` (~56mm)
- HDD dimensions:
  - `hdd_width/length/height` (101.6x147x26.1mm)
  - `nas_2disk_*` - 2-disk enclosure parameters
- CPU Cooler (Noctua NH-L12S):
  - `cooler_width/depth` (128x146mm)
  - `cooler_total_height` (70mm)
  - `cooler_base_height/fan_height/fins_height`
- GPU config:
  - `gpu_config_width/depth/height` (171x378x190mm)
- Frame components:
  - `frame_cylinder_height` (calculated from interior_chamber_height)
  - `upper_frame_rail_width` (16mm)

### Coordinate System & Assembly Positioning

**Coordinate conventions:**
- X-axis: Width (left-right, 0 = left side of case)
- Y-axis: Depth (front-back, 0 = front of case)
- Z-axis: Height (bottom-top, 0 = bottom of case)

**Base positioning offsets** (used in assemblies):
- `base_x = wall_thickness` (3mm from left edge)
- `base_y = wall_thickness` (3mm from front edge)
- `base_z = wall_thickness` (3mm from bottom)

**Component stacking heights (Integrated Bottom Panel Design):**
- Bottom panel with standoff receptacles: Z=0 (positioned at wall_thickness = 3mm from exterior)
- Standoff bases in hexagonal recesses: Z=0 to 2.5mm (boss height above panel)
- Standoff tops (female thread end): Z=8.5mm (2.5mm boss + 6mm standoff height)
- Motherboard PCB bottom surface: Z=~8.5mm (rests on standoff male studs)
- Motherboard PCB top surface: Z=~10.1mm (8.5mm + 1.6mm PCB thickness)
- Components on motherboard: Add to ~10.1mm base height

**Note:** The separate motherboard plate component has been eliminated. Standoffs now mount directly into hexagonal recesses on the bottom panel interior surface, secured by M3 x 8mm screws from underneath.

### Panel Positioning

Panels fall into two categories:

**Exterior panels** (form the outer shell):
- Side panels: Full exterior height, positioned at Z=0
  - Left: X=0 (sometimes offset -explode for exploded view)
  - Right: X=case_width-wall_thickness (sometimes offset +explode)
- Front/back panels: Full exterior height, positioned at Z=0
  - Front: Y=0 (sometimes offset -explode)
  - Back: Y=mobo_depth+wall_thickness (sometimes offset +explode)

**Interior panels** (fit between walls):
- Top: Interior width/depth, positioned at X=wall_thickness, Y=wall_thickness, Z=minimal_exterior_height
- Bottom: Interior width/depth, positioned at X=wall_thickness, Y=wall_thickness, Z=0 (sometimes offset -explode)

### Key Design Patterns

1. **Assemblies** combine case parts and components with positioning logic
2. **Toggle flags** (`show_panels`, `show_components`, `explode`) enable debugging
3. **Color coding** distinguishes parts:
   - blue = (deprecated - previously motherboard plate, now integrated into bottom panel)
   - red = backplate (I/O panel)
   - gray = all other panels (side, top, bottom with integrated standoff mounting, front)
   - purple = PCBs (motherboard)
   - green = PSU
   - medium gray (0.4, 0.4, 0.4) = 3D printed frame parts
4. **Honeycomb ventilation** uses the `honeycomb_xz()` utility module

### Modular Frame System

The case uses a stacking/modular frame approach:

- **Base Frame**: Barebones case (motherboard + PSU) serves as the top chamber
- **NAS Enclosures**: Mount underneath the base frame via 4x #6-32 threaded inserts
  - Roofless design - base frame bottom serves as enclosure ceiling
  - Two variants: 2-disk (passive cooling) and many-disk (5-8 drives, active cooling)
  - Each enclosure has its own side panels
- **Unified Mounting**: 4 corner #6-32 holes dual-purpose:
  - Standalone config: Rubber feet attach here
  - NAS config: Enclosure attaches via same holes
- **Panel Variants**: Different side panels for GPU vs barebones/NAS configs

### Open Air Frame Components

The upper air-frame system (Phase 7 in TASKS.md):

- **Extended Standoffs**: M3x10+6mm male-female standoffs
  - 6mm female thread (accepts M3 x 8mm screw from below through bottom panel)
  - Sits in hexagonal recesses on bottom panel (integrated mounting design)
  - 10mm male stud protruding above motherboard
  - Secured via bottom-up screw mounting (no separate motherboard plate)
- **Frame Cylinders**: Free-floating, captive in upper frame
  - Height = `interior_chamber_height - standoff_height - mobo_pcb_thickness` (~86mm)
  - Screw onto standoff male studs (tool-free assembly)
- **Upper Frame**: Rectangular "halo" frame structure
  - Outside dimensions match Mini-ITX (170x170mm)
  - 16mm rail width, holds 4 frame cylinders
  - Foundation for panel attachment

### Panel Features

- **Raised Lips**: Front and side panels have 3mm lips that protrude into case
  - Purpose: Creates mounting surface for frame components
  - Positioning: Inset 3mm from sides, positioned at specific heights
- **Extended Panels**: Some panels extend 3mm beyond nominal dimensions
  - Front panel: Extended +6mm width (3mm each side) to cover gaps
  - Front panel: Extended +3mm height at bottom
- **Mounting Holes**: Corner screw holes for panel attachment
  - Radius defined by `panel_screw_radius`
  - Inset defined by `panel_screw_inset`

### Cooling & Airflow

- **Minimal/NAS 2-disk**: Passive chimney airflow
  - Air intake → HDDs → motherboard → CPU cooler → exhaust
  - Noctua NH-L12S fan pulls air through entire path
- **NAS many-disk**: Active fan cooling (dedicated 120mm fans)
- **GPU config**: Vertical orientation with dedicated GPU ventilation
- **Parameterized vents**: Top panel can have dynamic vent positioning based on CPU cooler location

## Reference Documents

- `SPEC.md` - Full design specification with dimensions and requirements
- `TASKS.md` - Component tracking with ✅/❌ status and priority phases

## Important Component Locations

Key files and their purposes:

- `modules/case/dimensions.scad` - Single source of truth for all dimensions
- `modules/case/base/` - Core frame components (backplate; Note: motherboard_plate.scad is deprecated)
- `modules/case/frame/` - Open air frame components (standoffs, cylinders, upper frame)
- `modules/case/panels/standard/` - Panels for minimal/NAS configs (bottom panel has integrated standoff mounting)
- `modules/case/panels/gpu/` - Taller panels for GPU configuration
- `modules/case/nas_2disk/` - 2-disk NAS enclosure (frame, hotswap rails)
- `modules/case/nas_many/` - Many-disk NAS enclosure
- `modules/components/assemblies/motherboard.scad` - Complete motherboard assembly
- `modules/components/` - Hardware component models:
  - `motherboard.scad` - Mini-ITX with I/O shield, connectors, RAM slots
  - `cpu_cooler.scad` - Noctua NH-L12S assembly
  - `NH-L12S/` - Detailed CPU cooler sub-components (base, heatpipes, fins, heatsink)
  - `power/psu_flex_atx.scad` - Flex ATX PSU with mounting holes
  - `power/psu_sfx.scad` - SFX PSU
  - `power/power_inlet_c14.scad` - IEC C14 connector
  - `power/barrel_jack_5_5x2_5.scad` - DC barrel jack
  - `storage/hdd_3_5.scad` - 3.5" hard drive
  - `cooling/fan_120.scad` - 120mm case fan
  - `cooling/fan_120mm_15mm.scad` - Slim 120mm fan
  - `cooling/aio_radiator_240.scad` - 240mm AIO radiator
  - `cooling/aio_pump.scad` - AIO pump block
  - `gpu.scad` - Graphics card model
  - `pcie_riser.scad` - PCIe riser cable
  - `ram.scad` - DDR4 memory stick
- `modules/util/honeycomb.scad` - Honeycomb ventilation pattern utility
- `assemblies/` - Full case assemblies showcasing different configs

## Component Completion Status

See `TASKS.md` for detailed tracking of what's completed (✅) vs TODO (❌). Key completed components:
- Phase 1 (Minimal config): All standard panels complete
- Phase 7 (Open air frame): Extended standoffs, frame cylinders, upper frame complete
- Components: Motherboard, CPU cooler, PSU (Flex ATX, SFX), HDD, RAM, GPU, fans, AIO parts
- NAS: 2-disk frame and hotswap rails complete
