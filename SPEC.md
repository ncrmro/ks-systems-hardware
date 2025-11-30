# Modular and Expandable Computer Case Specification

## 1. Overview

This document outlines the design requirements for a modular and expandable computer case. The case is designed to be configurable for different use cases, starting with a basic compact configuration and allowing for expansion, such as for an external GPU.

### 1.1. Design Philosophy

The primary goal of this design is **scalability**. The case should support configurations ranging from the most minimal build to high-performance or high-storage setups:

*   **Minimal Configuration:** Motherboard, CPU, low-profile heatsink (Noctua NH-L12S with 120mm thin fan), NVMe SSD, and a Pico or Flex ATX PSU. This represents the smallest possible footprint.
*   **NAS Configuration:** Expanded to include multiple 3.5" HDDs for network-attached storage.
*   **Full GPU Configuration:** Expanded to accommodate a full-sized graphics card with dedicated cooling.

### 1.2. Cooling Philosophy

The case supports multiple cooling strategies to match the configuration:

*   **Low-Profile Air Cooling:** For minimal builds using the Noctua NH-L12S with a 120mm thin fan.
*   **Custom Tall Heatsink:** For CPU cooling in mid-tier builds requiring more thermal headroom.
*   **AIO Liquid Cooling:** For high-performance builds, supporting off-the-shelf All-In-One liquid coolers for both CPU and GPU. Radiator mounting supports either 2x 120mm or 2x 140mm fans.

### 1.3. Radiator Mounting

*   **Supported Sizes:** 2x 120mm or 2x 140mm
*   **Mounting Location:** TODO - Top, side, front?
*   **Clearance Requirements:** TODO
*   **Tubing Routing:** TODO - Path for AIO tubing

## 2. Core Components

The case is designed around the following core components:

*   **Motherboard:** Mini-ITX form factor (170mm x 170mm).
*   **Power Supply:** Supports multiple form factors depending on configuration:
    *   **Pico PSU:** For minimal builds with external AC adapter.
    *   **Flex ATX:** 150mm x 81.5mm x 40mm (L x W x H). Compact option for space-constrained builds.
    *   **SFX:** 125mm x 100mm x 63.5mm (L x W x H). Higher wattage option for GPU configurations.
*   **CPU Cooler:** Noctua NH-L12S (70mm height without fan).
*   **3.5" HDD:** 146mm x 101.6mm x 26.1mm (L x W x H). Used in NAS configurations.
*   **2.5" SSD:** 100mm x 69.85mm x 7mm (L x W x H). Optional storage expansion.

### 2.1. Motherboard Mounting

*   **Standoff Pattern:** TODO - Standard Mini-ITX pattern?
*   **Standoff Heights:**
    *   Minimal Configuration: TODO
    *   NAS Configuration (Option A): TODO
    *   NAS Configuration (Option B): TODO
    *   GPU Configuration: TODO
*   **Fasteners:** TODO - Screw type and size

## 3. Base Configuration

The most basic configuration of the case is designed for a compact, low-profile setup.

### 3.1. Orientation

*   The case is designed to be laid flat (horizontal orientation).
*   The motherboard's rear I/O ports shall face the back of the case.

### 3.2. Layout

*   The Mini-ITX motherboard is mounted flat.
*   The Flex ATX power supply is mounted next to the motherboard.

### 3.3. Case Width

The case width is determined by the NAS 2-disk configuration (controlling dimension), ensuring both the base case and NAS enclosure share the same footprint.

**Controlling Dimension - 2 HDDs Side-by-Side:**

*   2 × HDD width: 2 × 101.6mm = 203.2mm
*   Rails: 2mm × 4 = 8mm
*   Gap between bays: 5mm
*   Walls: 3mm × 2 = 6mm
*   Padding: 2mm × 2 = 4mm
*   **Total case width: ~226mm**

**Base Case Width Breakdown:**

*   Motherboard area: 170mm (Mini-ITX width)
*   PSU compartment: 56mm (226mm - 170mm)
*   **Total: 226mm**

**PSU Orientation:**

*   The Flex ATX PSU stands on its side (40mm height becomes width).
*   PSU dimensions on side: 40mm wide × 150mm deep × 80mm tall.
*   The 40mm PSU fits in the 56mm compartment with 16mm clearance.

**I/O Backplate Extension:**

*   The I/O backplate extends the full 226mm case width.
*   PSU mounting screw holes are positioned in the PSU compartment area (X = 170mm to 226mm).
*   Screw pattern: 8-32 UNC thread, aligned with Flex ATX mounting holes.

## 4. External GPU Configuration

This configuration allows for the addition of a full-sized external GPU.

### 4.1. GPU Specifications

*   **Maximum Length:** 320mm
*   **Maximum Width:** 3 slots (60mm)

### 4.2. Orientation

*   The case is designed to stand vertically.
*   The motherboard's rear I/O ports shall face down.
*   The external GPU's I/O ports shall also face down.

### 4.3. Layout

*   The GPU is mounted vertically ("standing tall").
*   A PCIe riser cable is required to connect the GPU to the motherboard.
*   The case needs to provide adequate ventilation for the GPU.
*   The PSU is mounted above the motherboard.
*   An internal power cord routes from the PSU to a power inlet at the bottom of the case.
*   All I/O ports face the bottom of the case:
    *   Motherboard rear I/O
    *   GPU display outputs
    *   Power inlet

### 4.4. PCIe Riser Cable

*   **Minimum Length:** TODO
*   **Maximum Length:** TODO
*   **PCIe Generation:** TODO - Gen 4 / Gen 5 compatibility
*   **Routing Path:** TODO - Describe cable routing within case

## 5. Modularity and Expandability

The case design shall incorporate modular elements to allow for the following:

*   Easy transition between the Base Configuration and the External GPU Configuration.
*   Addition of other components, such as storage drives (2.5" SSDs).
*   Customizable panels for different aesthetics or ventilation options.

### 5.1. Modular Frame System

The case uses a stacking/modular frame approach:

*   **Base Frame:** The barebones case (motherboard + Flex PSU) serves as the top/main chamber.
*   **NAS Enclosures:** Both 2-disk and many-disk (5-8) enclosures are designed to mount **underneath** the base frame.
*   **Roofless Enclosure Design:** NAS enclosures have no top panel (roof). The bottom of the base frame serves as the ceiling for the NAS enclosure, creating a shared boundary between chambers.
*   **Unified Mounting System:** Four #6-32 threaded mounting points at the corners of the base frame bottom serve dual purposes:
    *   When standalone: Rubber feet screw into these holes.
    *   When expanded: NAS enclosure attaches via these same mounting points.
*   **Frame Connection:** NAS enclosures connect to the base frame but feature their own side panels.
*   **Panel Variants:** Different side panels are used for GPU configuration vs. barebones/NAS configurations.

### 5.2. Panel Configuration

| Configuration | Left Panel | Right Panel | Notes |
|---------------|------------|-------------|-------|
| Barebones/Minimal | Standard | Standard | Enclosed sides |
| NAS (2-disk) | NAS variant | NAS variant | Air intake channels |
| NAS (5-8 disk) | NAS variant | NAS variant | Fan mount cutouts |
| GPU | GPU variant | GPU variant | Extended height, GPU ventilation |

## 6. NAS Configuration

This configuration focuses on maximizing storage capacity within the Mini-ITX form factor, primarily for Network Attached Storage (NAS) use cases. The NAS enclosures mount **underneath** the barebones case frame, creating a stacked two-chamber design.

### 6.1. HDD Layout Options

Two primary layout options are supported for 3.5" Hard Disk Drives (HDDs):

*   **Option A: 2-Disk Enclosure (Side-by-Side Flat Mount):**
    *   Two 3.5" HDDs are mounted side-by-side, lying flat (on their widest surface) in a dedicated enclosure underneath the motherboard chamber.
    *   This configuration prioritizes a low profile and passive cooling.
    *   Requires the motherboard to be raised sufficiently to clear the height of a single 3.5" HDD (approximately 26.1mm) plus any necessary clearance.

*   **Option B: Many-Disk Enclosure (5-8 Drives):**
    *   Multiple 3.5" HDDs (5 to 8) are mounted vertically, laying on their narrowest side, with their longest dimension parallel to the motherboard.
    *   This option maximizes the number of drives in a compact space.
    *   Features dedicated cooling fans within the enclosure.
    *   Requires the motherboard to be raised sufficiently to clear the width of a single 3.5" HDD (approximately 101.6mm) plus any necessary clearance.

### 6.2. NAS Enclosure Mounting

*   Both NAS enclosures mount underneath the barebones case frame with Flex ATX PSU.
*   **Roofless Design:** NAS enclosures have no top panel. The bottom of the base frame acts as the enclosure ceiling.
*   **Mounting Points:** Four #6-32 threaded inserts at corners of the base frame bottom.
*   **Thread Specification:** #6-32 UNC (standard PC case screw thread, approximately M3.5 metric equivalent).
*   **Attachment Method:** NAS enclosure frame has four corresponding holes at corners that align with base frame mounting points. Screws pass through the enclosure frame into the base frame threaded inserts.
*   Each NAS enclosure has its own dedicated side panels (separate from the base frame panels).
*   **Benefits of Roofless Design:**
    *   Simplified construction (fewer parts per enclosure)
    *   Shared airflow path between chambers (for passive cooling configurations)
    *   Easy enclosure swap without disassembling base frame

### 6.3. NAS Airflow Design

**Option A (2-Disk) - Passive Chimney Airflow:**

*   Side panels feature air intake channels at the bottom of the NAS enclosure.
*   Air is directed over the HDDs and flows upward into the motherboard chamber above.
*   The Noctua NH-L12S fan pulls this pre-warmed air over the motherboard and heatsink.
*   Air exhausts directly out of the case through the rear (I/O backplate area).
*   This creates a unified airflow path: Intake → HDDs → Motherboard → Heatsink → Exhaust.

**Option B (5-8 Disk) - Active Fan Cooling:**

*   The many-disk enclosure includes dedicated cooling fans.
*   Fan mounting locations: TODO - Front intake? Rear exhaust?
*   Airflow is independent from the motherboard chamber above.

### 6.4. Base Case Feet

When no NAS enclosure is attached, rubber feet provide case support and use the same mounting system:

*   **Mounting:** Four rubber feet screw into the #6-32 threaded inserts at corners of the base frame bottom.
*   **Thread:** #6-32 UNC (standard PC case feet thread).
*   **Purpose:** Provides stability, vibration dampening, and airflow clearance underneath the case.
*   **Removal:** When attaching a NAS enclosure, rubber feet are unscrewed and replaced by the enclosure mounting screws.
*   **Compatibility:** Standard PC case rubber feet with #6-32 threaded stud.

## 8. Case Dimensions

Overall external dimensions for each configuration:

### 8.1. Minimal Configuration

*   **Width:** 226mm (controlled by NAS 2-disk HDD layout - see Section 3.3)
*   **Depth:** TODO
*   **Height:** TODO

### 8.2. NAS Configuration (Option A - Flat Mount)

*   **Width:** 226mm (same as minimal - base case and NAS share footprint)
*   **Depth:** TODO
*   **Height:** TODO

### 8.3. NAS Configuration (Option B - Vertical Mount)

*   **Width:** TODO
*   **Depth:** TODO
*   **Height:** TODO

### 8.4. GPU Configuration

*   **Width:** 171mm
*   **Depth:** 378mm
*   **Height:** 190mm

## 9. Panel Construction & Attachment

### 9.1. Materials

*   **Primary Material:** TODO - 3D printed, aluminum, acrylic?
*   **Wall Thickness:** TODO

### 9.2. Attachment Mechanism

*   **Panel Attachment:** TODO - Screws, magnets, tool-less clips?
*   **Fastener Specifications:** TODO

### 9.3. Ventilation

*   **Ventilation Pattern:** TODO - Honeycomb, mesh, slots?
*   **Ventilation Locations:** TODO - Which panels have ventilation?

## 10. Front Panel I/O & Access

### 10.1. Power & Controls

*   **Power Button:** TODO - Location and type
*   **Reset Button:** TODO - Include or not?
*   **Power LED:** TODO - Location
*   **Activity LED:** TODO - Location

### 10.2. Front I/O Ports

*   **USB Ports:** TODO - Type, quantity, location
*   **Audio Ports:** TODO - Include or not?

### 10.3. Drive Access

*   **Hot-Swap Bays:** TODO - For NAS configuration?
*   **Access Panels:** TODO - Tool-less access for maintenance?

## 11. Open Air Frame

The upper air-frame consists of four cylinders that screw onto the motherboard standoff screws. The standoffs have a male end that protrudes from the top of the motherboard, allowing the cylinders to screw into them. These cylinders are free-floating in the upper frame, enabling tool-free assembly by hand.

### 11.1. Standoff Design

*   **Type:** M3x10+6mm male-female standoff
*   **Lower Portion:** 6mm female thread (accepts motherboard mounting screw from below)
*   **Upper Portion:** 10mm male threaded stud protruding above the motherboard surface
*   **Thread Specification:** M3

### 11.2. Frame Cylinders

*   **Material:** TODO - 3D printed, aluminum?
*   **Internal Thread:** Matches standoff male thread
*   **Mounting:** Free-floating within frame structure (captive but rotatable)
*   **Purpose:** Serve as foundation for case panels to attach to

### 11.3. Assembly Process

1.  Install standoffs with male studs into motherboard plate
2.  Mount motherboard onto standoffs
3.  Place upper frame over motherboard
4.  Hand-tighten frame cylinders onto standoff studs (no tools required)

## 12. Rapid Panel Mounting System

The case panels feature a unified quick-release mechanism that enables rapid access to internal components. A single latch unlocks multiple panels simultaneously.

### 12.1. Quick-Release Mechanism

*   **Type:** TODO - Cam latch, toggle latch, push-button release?
*   **Location:** TODO - Corner, edge, center?
*   **Operation:** Single action unlocks top, side, and front panels
*   **Security:** TODO - Optional keyed lock?

### 12.2. Panel Hinging

Optional hinge mechanisms allow connected panels to be handled as a single assembly:

*   **Top + Side Configuration:** Top panel hinges to one side panel, opening like a clamshell
*   **Front + Top Configuration:** Front and top panels hinge together for full access
*   **Hinge Type:** TODO - Piano hinge, concealed hinge, removable pin hinge?
*   **Detachability:** Panels can be fully removed or left attached when opened

### 12.3. Benefits

*   Tool-free panel removal for maintenance and upgrades
*   Single-handed operation for quick access
*   Panels can be configured as single assembly or individual pieces
*   Reduces time for component installation and service

## 13. Parameterized Upper Panels

The top panel features dynamically positioned ventilation and internal air channeling based on configurable parameters. This enables optimized airflow for different CPU cooler and component configurations.

### 13.1. Top Panel Ventilation

*   **Vent Purpose:** Direct hot air egress from CPU heatsink to exterior
*   **Positioning:** Parameterized X/Y offset based on CPU cooler location
*   **Vent Size:** TODO - Fixed or parameterized?
*   **Vent Pattern:** TODO - Honeycomb, mesh, circular?

### 13.2. Parameterized Vent Placement

Key parameters for vent positioning:

*   `cpu_cooler_offset_x` - X offset from motherboard origin to cooler center
*   `cpu_cooler_offset_y` - Y offset from motherboard origin to cooler center
*   `vent_diameter` - Size of the exhaust vent opening
*   `vent_margin` - Minimum distance from panel edges

### 13.3. Airflow Design

*   **Negative Pressure:** Hot air exhausting directly above CPU creates negative pressure inside case
*   **Air Intake:** Cool air drawn in through side/front panel vents
*   **Direct Path:** Minimizes recirculation of heated air within case

### 13.4. Internal Air Channels

The underside of the top panel features parameterized air channels that direct airflow over specific components:

*   **Channel Purpose:** Guide airflow from intake to exhaust, preventing dead zones
*   **Channel Height:** TODO - Parameterized based on component clearance
*   **Channel Routing:** Configurable paths over RAM, VRM, and other heat-generating components

### 13.5. Channel Parameters

*   `channel_width` - Width of air channels
*   `channel_depth` - Height of channel walls (protrusion into case)
*   `vrm_channel_enable` - Enable/disable channel over VRM area
*   `ram_channel_enable` - Enable/disable channel over RAM slots
*   `component_clearance` - Minimum clearance above components