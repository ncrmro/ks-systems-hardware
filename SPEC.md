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
*   Enclosures connect to the base frame via TODO mounting mechanism.
*   Each NAS enclosure has its own dedicated side panels (separate from the base frame panels).

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

## 8. Case Dimensions

Overall external dimensions for each configuration:

### 8.1. Minimal Configuration

*   **Width:** TODO
*   **Depth:** TODO
*   **Height:** TODO

### 8.2. NAS Configuration (Option A - Flat Mount)

*   **Width:** TODO
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
