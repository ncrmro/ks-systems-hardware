# Keystone Hardware - Modeling Tasks

This document tracks components and case parts that need to be modeled in OpenSCAD.

---

## Directory Structure

```
keystone-hardware/
│
├── modules/
│   │
│   ├── components/                    # Hardware component models
│   │   ├── motherboard.scad           # ✅ Mini-ITX motherboard
│   │   ├── cpu_cooler.scad            # ✅ Noctua NH-L12S
│   │   ├── cpu_cooler_tower.scad      # ❌ Tall heatsink (mid-tier)
│   │   ├── ram.scad                   # ✅ DDR4 RAM stick
│   │   ├── gpu.scad                   # ❌ Graphics card (320mm x 60mm)
│   │   ├── pcie_riser.scad            # ❌ PCIe riser cable
│   │   │
│   │   ├── storage/
│   │   │   ├── hdd_3_5.scad           # ✅ 3.5" HDD
│   │   │   ├── ssd_2_5.scad           # ❌ 2.5" SSD
│   │   │   └── nvme_ssd.scad          # ❌ M.2 2280 NVMe
│   │   │
│   │   ├── power/
│   │   │   ├── power-supply.sfx.scad      # ✅ SFX PSU
│   │   │   ├── power-supply.flex-atx.scad # ✅ Flex ATX PSU
│   │   │   ├── power-supply.pico.scad     # ❌ Pico PSU
│   │   │   ├── power_inlet_c14.scad       # ❌ IEC C14 connector
│   │   │   └── power_cable_internal.scad  # ❌ Internal power cable
│   │   │
│   │   └── cooling/
│   │       ├── fan_120.scad           # ❌ 120mm fan
│   │       ├── fan_140.scad           # ❌ 140mm fan
│   │       ├── aio_radiator_240.scad  # ❌ 240mm radiator (2x120)
│   │       ├── aio_radiator_280.scad  # ❌ 280mm radiator (2x140)
│   │       └── aio_pump.scad          # ❌ AIO pump block
│   │
│   ├── case/                          # Case part models
│   │   │
│   │   ├── base/                      # Base frame (all configs)
│   │   │   ├── motherboard_plate.scad # ⚠️ DEPRECATED - See integrated bottom panel design (panels/standard/bottom.scad)
│   │   │   ├── backplate_io.scad      # ✅ I/O backplate (in case.scad)
│   │   │   ├── standoffs.scad         # ❌ Motherboard standoffs
│   │   │   └── rubber_feet.scad       # ❌ Rubber feet for standalone config (same #6-32 holes as NAS mount)
│   │   │
│   │   ├── panels/
│   │   │   ├── standard/              # Barebones/Minimal config
│   │   │   │   ├── side_left.scad     # ❌ Left side panel
│   │   │   │   ├── side_right.scad    # ❌ Right side panel
│   │   │   │   ├── top.scad           # ❌ Top panel
│   │   │   │   ├── top_parameterized.scad # ❌ Top panel with dynamic vents
│   │   │   │   ├── bottom.scad        # ❌ Bottom panel
│   │   │   │   └── front.scad         # ❌ Front panel (power btn)
│   │   │   │
│   │   │   └── gpu/                   # GPU config (vertical)
│   │   │       ├── side_left.scad     # ❌ Extended height, vents
│   │   │       ├── side_right.scad    # ❌ Extended height, vents
│   │   │       ├── top.scad           # ❌ PSU above motherboard
│   │   │       └── bottom.scad        # ❌ Mobo I/O + GPU + power inlet
│   │   │
│   │   ├── gpu/                       # GPU mounting parts
│   │   │   ├── bracket.scad           # ❌ Vertical GPU mount
│   │   │   └── io_bracket.scad        # ❌ GPU I/O bracket
│   │   │
│   │   ├── nas_2disk/                 # 2-disk NAS enclosure
│   │   │   ├── frame.scad             # ❌ Main frame (connects to base)
│   │   │   ├── side_left.scad         # ❌ Air intake channels
│   │   │   ├── side_right.scad        # ❌ Air intake channels
│   │   │   ├── front.scad             # ❌ Hot-swap access
│   │   │   ├── back.scad              # ❌ Rear panel
│   │   │   └── hotswap_rails.scad     # ✅ HDD rails (case-hdd-hotswap-rails-35.scad)
│   │   │
│   │   ├── nas_many/                  # Many-disk NAS enclosure (5-8)
│   │   │   ├── frame.scad             # ❌ Larger frame
│   │   │   ├── side_left.scad         # ❌ Fan mount cutouts
│   │   │   ├── side_right.scad        # ❌ Fan mount cutouts
│   │   │   ├── front.scad             # ❌ Hot-swap access
│   │   │   ├── back.scad              # ❌ Rear panel
│   │   │   └── fan_mount.scad         # ❌ Dedicated fan mounting
│   │   │
│   │   ├── frame/                     # Open air frame components
│   │   │   ├── standoff_extended.scad # ✅ Standoff with male stud
│   │   │   ├── frame_cylinder.scad    # ✅ Free-floating mounting cylinder
│   │   │   └── upper_frame.scad       # ✅ Frame structure holding cylinders
│   │   │
│   │   ├── mounting/                  # Rapid panel mounting system
│   │   │   ├── quick_release_latch.scad # ❌ Single-action panel release
│   │   │   └── panel_hinge.scad       # ❌ Optional panel hinging
│   │   │
│   │   ├── cooling/                   # Cooling mounts
│   │   │   └── radiator_mount.scad    # ❌ 240mm/280mm radiator mount
│   │   │
│   │   ├── brackets/                  # Mounting brackets
│   │   │   ├── psu_flex.scad          # ❌ Flex ATX bracket
│   │   │   ├── psu_sfx.scad           # ❌ SFX bracket
│   │   │   └── psu_pico.scad          # ❌ Pico PSU bracket
│   │   │
│   │   └── cable_management.scad      # ❌ Clips, channels, pass-throughs
│   │
│   └── util/                          # Utility modules
│       └── honeycomb.scad             # ✅ Ventilation pattern
│
├── assemblies/                        # Full assembly files
│   ├── minimal.scad                   # ❌ Complete barebones case
│   ├── nas_2disk.scad                 # ❌ Base + 2-disk NAS stacked
│   ├── nas_many.scad                  # ❌ Base + many-disk NAS stacked
│   ├── gpu.scad                       # ❌ Full GPU build
│   └── gpu_aio.scad                   # ❌ GPU + liquid cooling
│
├── mini.scad                          # ✅ Current minimal visualization
├── mini-nas.scad                      # ✅ Current NAS visualization
│
├── SPEC.md                            # Design specification
└── TASKS.md                           # This file
```

### Legend

- ✅ = Exists (may need refactoring to new location)
- ❌ = TODO

### Migration Notes

Existing files need to be reorganized:
- `modules/case.scad` → Split into `modules/case/base/motherboard_plate.scad` (DEPRECATED) and `backplate_io.scad`
- **Note**: `motherboard_plate.scad` is now deprecated. Standoff mounting is integrated into `bottom.scad` via hexagonal recesses
- `modules/case-2x-nas.scad` → `modules/case/nas_2disk/frame.scad` (rename)
- `modules/case-hdd-hotswap-rails-35.scad` → `modules/case/nas_2disk/hotswap_rails.scad`
- `modules/*.scad` (components) → `modules/components/` subdirectories
- `mini.scad`, `mini-nas.scad` → Keep at root or move to `assemblies/`

---

## Existing Components

### Hardware Components (modules/)

| Component | File | Status | Notes |
|-----------|------|--------|-------|
| Mini-ITX Motherboard | `motherboard.scad` | ✅ Done | Includes I/O shield, ATX 24-pin connector, RAM slots |
| CPU Cooler (Noctua NH-L12S) | `cpu_cooler.scad` | ✅ Done | Heatsink (128x146x70mm) + 120mm thin fan (16mm) |
| DDR4 RAM | `ram.scad` | ✅ Done | Single stick module |
| SFX Power Supply | `power-supply.SFX.scad` | ✅ Done | 125 x 100 x 63.5mm |
| Flex ATX Power Supply | `power-supply.flex-atx.scad` | ✅ Done | 81.5 x 150 x 40.5mm |
| 3.5" HDD | `hdd_3_5.scad` | ✅ Done | 101.6 x 147 x 26.1mm |
| Honeycomb Pattern | `honeycomb.scad` | ✅ Done | Utility module for ventilation patterns |

### Hardware Components - TODO

| Component | File | Status | Notes |
|-----------|------|--------|-------|
| GPU | `gpu.scad` | ❌ TODO | Max 320mm length, 3-slot (60mm) width |
| PCIe Riser Cable | `pcie_riser.scad` | ❌ TODO | Flexible cable representation |
| 2.5" SSD | `ssd_2_5.scad` | ❌ TODO | 100 x 69.85 x 7mm |
| Pico PSU | `power-supply.pico.scad` | ❌ TODO | For minimal builds |
| AIO Radiator (240mm) | `aio_radiator_240.scad` | ❌ TODO | 2x 120mm fan mount |
| AIO Radiator (280mm) | `aio_radiator_280.scad` | ❌ TODO | 2x 140mm fan mount |
| AIO Pump Block | `aio_pump.scad` | ❌ TODO | CPU/GPU mount block |
| Tall Heatsink | `cpu_cooler_tower.scad` | ❌ TODO | For mid-tier builds |
| 120mm Fan | `fan_120.scad` | ❌ TODO | Standard 120x120x25mm |
| 140mm Fan | `fan_140.scad` | ❌ TODO | Standard 140x140x25mm |
| NVMe SSD | `nvme_ssd.scad` | ❌ TODO | M.2 2280 form factor (22x80mm) |
| Internal Power Cable | `power_cable_internal.scad` | ❌ TODO | Routes PSU to bottom power inlet (GPU config) |
| Power Inlet (C14) | `power_inlet_c14.scad` | ❌ TODO | IEC C14 connector for external power |

---

## Existing Case Parts

### Case Parts (modules/)

| Part | File | Status | Notes |
|------|------|--------|-------|
| Motherboard Plate | `case.scad` | ⚠️ Deprecated | Replaced by integrated bottom panel design (see Phase 1.4) |
| Backplate (I/O) | `case.scad` | ✅ Done | I/O shield cutout + honeycomb ventilation |
| 2-Bay NAS Enclosure | `case-2x-nas.scad` | ✅ Done | Houses 2x 3.5" HDDs with hot-swap rails |
| HDD Hot-Swap Rails | `case-hdd-hotswap-rails-35.scad` | ✅ Done | Rails for 3.5" HDD insertion |

---

## Case Parts - TODO

### Base Frame Parts

| Part | File | Status | Notes |
|------|------|--------|-------|
| Top Panel | `case-panel-top.scad` | ❌ TODO | Ventilation or radiator mount option |
| Bottom Panel | `case-panel-bottom.scad` | ❌ TODO | 4x #6-32 threaded inserts at corners (dual-purpose: rubber feet OR NAS enclosure mounting) |
| Front Panel | `case-panel-front.scad` | ❌ TODO | Power button, USB, LEDs |
| Standoffs | `case-standoffs.scad` | ❌ TODO | Physical standoff models |

### Side Panels - Configuration Variants

Different side panels required for each configuration:

| Part | File | Status | Notes |
|------|------|--------|-------|
| Side Panel - Standard (Left) | `case-panel-side-std-left.scad` | ❌ TODO | For barebones/minimal config |
| Side Panel - Standard (Right) | `case-panel-side-std-right.scad` | ❌ TODO | For barebones/minimal config |
| Side Panel - GPU (Left) | `case-panel-side-gpu-left.scad` | ❌ TODO | Extended height, GPU ventilation |
| Side Panel - GPU (Right) | `case-panel-side-gpu-right.scad` | ❌ TODO | Extended height, GPU ventilation |

### NAS Enclosure Parts

NAS enclosures mount underneath the base frame via 4x #6-32 screw holes at corners. **Roofless design:** enclosures have no top panel - the base frame bottom serves as the ceiling. Each enclosure has its own side panels:

| Part | File | Status | Notes |
|------|------|--------|-------|
| 2-Disk NAS Frame | `case-nas-2disk-frame.scad` | ❌ TODO | Roofless frame, mounts via 4-corner #6-32 holes, holds 2x HDDs |
| 2-Disk NAS Side Panel (Left) | `case-nas-2disk-side-left.scad` | ❌ TODO | Air intake channels for chimney airflow |
| 2-Disk NAS Side Panel (Right) | `case-nas-2disk-side-right.scad` | ❌ TODO | Air intake channels for chimney airflow |
| 2-Disk NAS Front Panel | `case-nas-2disk-front.scad` | ❌ TODO | Hot-swap bay access |
| 2-Disk NAS Back Panel | `case-nas-2disk-back.scad` | ❌ TODO | Rear enclosure panel |
| Many-Disk NAS Frame (5-8) | `case-nas-many-frame.scad` | ❌ TODO | Roofless frame, mounts via 4-corner #6-32 holes, holds 5-8 HDDs |
| Many-Disk NAS Side Panel (Left) | `case-nas-many-side-left.scad` | ❌ TODO | Fan mount cutouts |
| Many-Disk NAS Side Panel (Right) | `case-nas-many-side-right.scad` | ❌ TODO | Fan mount cutouts |
| Many-Disk NAS Front Panel | `case-nas-many-front.scad` | ❌ TODO | Hot-swap bay access |
| Many-Disk NAS Back Panel | `case-nas-many-back.scad` | ❌ TODO | Rear enclosure panel |
| Many-Disk NAS Fan Mount | `case-nas-many-fan-mount.scad` | ❌ TODO | Dedicated fan mounting |

### GPU Configuration Parts

| Part | File | Status | Notes |
|------|------|--------|-------|
| GPU Bracket | `case-gpu-bracket.scad` | ❌ TODO | Vertical GPU mount |
| GPU I/O Bracket | `case-gpu-io-bracket.scad` | ❌ TODO | Rear bracket for GPU outputs |
| Radiator Mount | `case-radiator-mount.scad` | ❌ TODO | For 240mm/280mm radiators |
| GPU Bottom Panel | `case-panel-gpu-bottom.scad` | ❌ TODO | Cutouts for: motherboard I/O, GPU outputs, power inlet |
| GPU Top Panel | `case-panel-gpu-top.scad` | ❌ TODO | PSU mounted above motherboard in this config |

### Utility Parts

| Part | File | Status | Notes |
|------|------|--------|-------|
| PSU Bracket (Flex) | `case-psu-bracket-flex.scad` | ❌ TODO | Mounting for Flex ATX |
| PSU Bracket (SFX) | `case-psu-bracket-sfx.scad` | ❌ TODO | Mounting for SFX |
| PSU Bracket (Pico) | `case-psu-bracket-pico.scad` | ❌ TODO | Mounting for Pico PSU |
| Rubber Feet | `case-rubber-feet.scad` | ❌ TODO | 4x feet with #6-32 thread for standalone config (removed when NAS attached) |
| Cable Management | `case-cable-routing.scad` | ❌ TODO | Clips, channels, pass-throughs |

### Frame & Mounting Parts

Open air frame and rapid panel mounting components:

| Part | File | Status | Notes |
|------|------|--------|-------|
| Extended Standoff | `frame/standoff_extended.scad` | ✅ Done | M3x10+6mm male-female standoff (10mm stud above mobo) |
| Frame Cylinder | `frame/frame_cylinder.scad` | ✅ Done | Free-floating, captive in upper frame, height derived from interior_chamber_height |
| Upper Frame | `frame/upper_frame.scad` | ✅ Done | Structure holding 4 cylinders with retention lips |
| Quick-Release Latch | `mounting/quick_release_latch.scad` | ❌ TODO | Single-action panel release |
| Panel Hinge | `mounting/panel_hinge.scad` | ❌ TODO | Optional panel linking |
| Parameterized Top Panel | `panels/standard/top_parameterized.scad` | ❌ TODO | Dynamic vent based on cpu_cooler_offset_x/y |
| Internal Air Channels | `panels/standard/air_channels.scad` | ❌ TODO | Underside structures for airflow direction |

---

## Assembly Files

### Existing Assemblies

| Assembly | File | Status | Notes |
|----------|------|--------|-------|
| Minimal Config | `mini.scad` | ✅ Done | Motherboard + SFX PSU + HDDs (visualization) |
| NAS Config | `mini-nas.scad` | ✅ Done | Motherboard + Flex ATX + 2-bay NAS enclosure |

### Assemblies - TODO

| Assembly | File | Status | Notes |
|----------|------|--------|-------|
| Minimal Config (Complete) | `assembly-minimal.scad` | ❌ TODO | Full case with all panels |
| NAS 2-Disk Config | `assembly-nas-2disk.scad` | ❌ TODO | Base frame + 2-disk enclosure stacked |
| NAS Many-Disk Config | `assembly-nas-many.scad` | ❌ TODO | Base frame + 5-8 disk enclosure stacked |
| GPU Config | `assembly-gpu.scad` | ❌ TODO | Full GPU build with riser |
| GPU + AIO Config | `assembly-gpu-aio.scad` | ❌ TODO | GPU build with liquid cooling |

---

## Priority Order

Priorities are organized by dependency and the "minimal to complex" design philosophy.

---

### Phase 1: Complete Minimal/Barebones Configuration (Foundation)

The base frame that all other configurations build upon.

| Priority | Task | Dependency | Notes |
|----------|------|------------|-------|
| 1.1 | Standard side panel (left) | None | Core enclosure |
| 1.2 | Standard side panel (right) | None | Core enclosure |
| 1.3 | Top panel | None | Core enclosure |
| 1.4 | Bottom panel | None | **Integrated standoff mounting**: Hexagonal recesses at Mini-ITX positions for M3 standoffs + 4x #6-32 corners for feet/NAS mount |
| 1.5 | Front panel (basic) | None | Power button hole |
| 1.6 | Standoffs | None | Motherboard mounting |
| 1.7 | Full minimal assembly | 1.1-1.6 | Validate fit |

---

### Phase 2: NAS 2-Disk Configuration (Passive Cooling)

Stacks underneath barebones. Uses chimney airflow - no active cooling needed.

| Priority | Task | Dependency | Notes |
|----------|------|------------|-------|
| 2.1 | 2-disk NAS frame | Phase 1.4 | Roofless frame, mounts via 4x #6-32 holes in base bottom panel |
| 2.2 | 2-disk NAS side panels (L/R) | 2.1 | Air intake channels for chimney |
| 2.3 | 2-disk NAS front panel | 2.1 | Hot-swap bay access |
| 2.4 | 2-disk NAS back panel | 2.1 | Rear enclosure |
| 2.5 | Full 2-disk NAS assembly | 2.1-2.4 | Validate airflow path |

---

### Phase 3: GPU Configuration (Vertical Orientation)

Major structural change - case stands vertical, all I/O faces bottom.

| Priority | Task | Dependency | Notes |
|----------|------|------------|-------|
| 3.1 | GPU model | None | Reference for sizing |
| 3.2 | PCIe riser cable | None | Reference for routing |
| 3.3 | Power inlet (C14) | None | Bottom-mounted connector |
| 3.4 | GPU bracket | 3.1 | Vertical GPU mount |
| 3.5 | GPU I/O bracket | 3.1 | Rear bracket for outputs |
| 3.6 | GPU side panels (L/R) | 3.1, 3.4 | Extended height, ventilation |
| 3.7 | GPU bottom panel | 3.3, 3.5 | Mobo I/O + GPU + power inlet |
| 3.8 | GPU top panel | None | PSU above motherboard |
| 3.9 | Internal power cable | 3.3 | PSU to bottom inlet routing |
| 3.10 | Full GPU assembly | 3.1-3.9 | Validate clearances |

---

### Phase 4: NAS Many-Disk Configuration (Active Cooling)

Larger enclosure (5-8 drives) with dedicated fans.

| Priority | Task | Dependency | Notes |
|----------|------|------------|-------|
| 4.1 | 120mm fan model | None | Reference for mounts |
| 4.2 | Many-disk NAS frame | Phase 1.4 | Roofless frame, mounts via same 4x #6-32 holes as 2-disk |
| 4.3 | Fan mount components | 4.1, 4.2 | Dedicated cooling |
| 4.4 | Many-disk side panels (L/R) | 4.2, 4.3 | Fan mount cutouts |
| 4.5 | Many-disk front panel | 4.2 | Hot-swap bay access |
| 4.6 | Many-disk back panel | 4.2 | Rear enclosure |
| 4.7 | Full many-disk NAS assembly | 4.1-4.6 | Validate cooling |

---

### Phase 5: AIO Liquid Cooling (High Performance)

Optional cooling upgrades for CPU and GPU.

| Priority | Task | Dependency | Notes |
|----------|------|------------|-------|
| 5.1 | 140mm fan model | None | For 280mm radiators |
| 5.2 | AIO radiator (240mm) | Phase 1 | 2x 120mm |
| 5.3 | AIO radiator (280mm) | 5.1 | 2x 140mm |
| 5.4 | Radiator mount brackets | 5.2 or 5.3 | Case mounting points |
| 5.5 | AIO pump block | None | CPU/GPU mount |
| 5.6 | Tall heatsink | None | Alternative to AIO |
| 5.7 | GPU + AIO assembly | Phase 3, 5.2-5.5 | Validate fit |

---

### Phase 6: Refinements & Accessories

Nice-to-haves and alternative components.

| Priority | Task | Dependency | Notes |
|----------|------|------------|-------|
| 6.1 | PSU bracket (Flex) | Phase 1 | Secure mounting |
| 6.2 | PSU bracket (SFX) | Phase 3 | GPU config uses SFX |
| 6.3 | PSU bracket (Pico) | Phase 1 | Minimal config option |
| 6.4 | Pico PSU model | None | Reference model |
| 6.5 | NVMe SSD model | None | M.2 2280 reference |
| 6.6 | 2.5" SSD model | None | Optional storage |
| 6.7 | Cable management | All phases | Clips, channels, pass-throughs |

---

### Phase 7: Open Air Frame & Advanced Panel System

Advanced mounting and ventilation features for improved accessibility and cooling.

| Priority | Task | Dependency | Status | Notes |
|----------|------|------------|--------|-------|
| 7.1 | Extended standoff (M3x10+6mm) | Phase 1.6 | ✅ Done | M3 male-female standoff: 6mm female thread below, 10mm male stud above mobo |
| 7.2 | Frame cylinder | 7.1 | ✅ Done | Free-floating cylinder, height = interior_chamber_height - standoff_height - mobo_pcb_thickness (~86mm) |
| 7.3 | Upper frame structure | 7.2 | ✅ Done | Holds 4 frame cylinders with retention lips, foundation for panels |
| 7.4 | Quick-release latch mechanism | Phase 1 | ❌ TODO | Single action unlocks top/side/front panels |
| 7.5 | Panel hinge component | 7.4 | ❌ TODO | Optional hinging for clamshell-style opening |
| 7.6 | Parameterized top panel | 7.3, Phase 1.3 | ❌ TODO | Dynamic vent placement based on CPU cooler position |
| 7.7 | Internal air channels | 7.6 | ❌ TODO | Underside structures directing airflow over components |
| 7.8 | Full open-air frame assembly | 7.1-7.7 | ❌ TODO | Validate tool-free assembly and airflow |
