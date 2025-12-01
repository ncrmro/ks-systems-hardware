# Modules Documentation

Detailed documentation for the modules directory. For high-level project info, see the root CLAUDE.md.

## Shared Dimensions

All shared dimensions are defined in `case/dimensions.scad`. Key variables:

### Core Dimensions
- `mobo_width/depth` (170mm Mini-ITX)
- `mobo_pcb_thickness` (1.6mm)
- `wall_thickness` (3mm)
- `standoff_height` (6mm)
- `standoff_hole_radius` (1.6mm, M3 clearance)
- `standoff_locations` - array of 4 Mini-ITX mounting positions
- `interior_chamber_height` (standoffs + mobo + cooler, ~94mm)
- `minimal_exterior_height` (~100mm)
- `minimal_with_psu_width` (~226mm, controlled by NAS 2-disk layout)

### Panel Dimensions
- `interior_panel_width/depth` (220mm x 170mm) - for top/bottom
- `side_panel_height/depth` (100mm x 176mm) - for left/right
- `front_back_panel_width/height` (220mm x 100mm) - for front/back
- `panel_screw_radius`, `panel_screw_inset` - for mounting holes

### PSU Dimensions
- `flex_atx_*` (40x150x80mm, standing orientation)
- `flex_atx_mount_holes` - array of 3 mounting positions (8-32 UNC)
- `sfx_*` (125x100x63.5mm)
- `psu_compartment_width` (~56mm)

### HDD Dimensions
- `hdd_width/length/height` (101.6x147x26.1mm)
- `nas_2disk_*` - 2-disk enclosure parameters

### CPU Cooler (Noctua NH-L12S)
- `cooler_width/depth` (128x146mm)
- `cooler_total_height` (70mm)
- `cooler_base_height/fan_height/fins_height`

### GPU Config
- `gpu_config_width/depth/height` (171x378x190mm)

### Frame Components
- `frame_cylinder_height` (calculated from interior_chamber_height)
- `upper_frame_rail_width` (16mm)

## Coordinate System & Assembly Positioning

**Coordinate conventions:**
- X-axis: Width (left-right, 0 = left side of case)
- Y-axis: Depth (front-back, 0 = front of case)
- Z-axis: Height (bottom-top, 0 = bottom of case)

**Base positioning offsets** (used in assemblies):
- `base_x = wall_thickness` (3mm from left edge)
- `base_y = wall_thickness` (3mm from front edge)
- `base_z = wall_thickness` (3mm from bottom)

**Component stacking heights:**
- Motherboard plate: `base_z + standoff_height` (~9mm from bottom)
- Motherboard PCB surface: `base_z + standoff_height + wall_thickness` (~12mm)
- Components on motherboard: Add to motherboard surface height

## Panel Positioning

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

## Open Air Frame Components

The upper air-frame system (Phase 7 in TASKS.md):

- **Extended Standoffs**: M3x10+6mm male-female standoffs
  - 6mm female thread (accepts mobo screw from below)
  - 10mm male stud protruding above motherboard
- **Frame Cylinders**: Free-floating, captive in upper frame
  - Height = `interior_chamber_height - standoff_height - mobo_pcb_thickness` (~86mm)
  - Screw onto standoff male studs (tool-free assembly)
- **Upper Frame**: Rectangular "halo" frame structure
  - Outside dimensions match Mini-ITX (170x170mm)
  - 16mm rail width, holds 4 frame cylinders
  - Foundation for panel attachment

## Panel Features

- **Raised Lips**: Front and side panels have 3mm lips that protrude into case
  - Purpose: Creates mounting surface for frame components
  - Positioning: Inset 3mm from sides, positioned at specific heights
- **Extended Panels**: Some panels extend 3mm beyond nominal dimensions
  - Front panel: Extended +6mm width (3mm each side) to cover gaps
  - Front panel: Extended +3mm height at bottom
- **Mounting Holes**: Corner screw holes for panel attachment
  - Radius defined by `panel_screw_radius`
  - Inset defined by `panel_screw_inset`

## File Reference

### Case Modules (`case/`)
- `dimensions.scad` - Single source of truth for all dimensions
- `base/` - Core frame components (motherboard plate, backplate)
- `frame/` - Open air frame components (standoffs, cylinders, upper frame)
- `panels/standard/` - Panels for minimal/NAS configs
- `panels/gpu/` - Taller panels for GPU configuration
- `nas_2disk/` - 2-disk NAS enclosure (frame, hotswap rails)
- `nas_many/` - Many-disk NAS enclosure

### Component Models (`components/`)
- `motherboard.scad` - Mini-ITX with I/O shield, connectors, RAM slots
- `cpu_cooler.scad` - Noctua NH-L12S assembly
- `NH-L12S/` - Detailed CPU cooler sub-components (base, heatpipes, fins, heatsink)
- `gpu.scad` - Graphics card model
- `pcie_riser.scad` - PCIe riser cable
- `ram.scad` - DDR4 memory stick
- `assemblies/motherboard.scad` - Complete motherboard assembly

### Power Components (`components/power/`)
- `psu_flex_atx.scad` - Flex ATX PSU with mounting holes
- `psu_sfx.scad` - SFX PSU
- `power_inlet_c14.scad` - IEC C14 connector
- `barrel_jack_5_5x2_5.scad` - DC barrel jack

### Storage Components (`components/storage/`)
- `hdd_3_5.scad` - 3.5" hard drive

### Cooling Components (`components/cooling/`)
- `fan_120.scad` - 120mm case fan
- `fan_120mm_15mm.scad` - Slim 120mm fan
- `aio_radiator_240.scad` - 240mm AIO radiator
- `aio_pump.scad` - AIO pump block

### Utilities (`util/`)
- `honeycomb.scad` - Honeycomb ventilation pattern utility
