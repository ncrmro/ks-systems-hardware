# Modular and Expandable Computer Case Specification

## 1. Overview

This document outlines the design requirements for a modular and expandable computer case. The case is designed to be configurable for different use cases, starting with a basic compact configuration and allowing for expansion, such as for an external GPU.

### 1.1. Design Philosophy

The primary goal of this design is **scalability**. The case should support configurations ranging from the most minimal build to high-performance or high-storage setups:

*   **Pico Configuration:** Ultra-compact motherboard-only build with Pico ATX PSU (on-board DC-DC converter), Noctua NH-L9 cooler, and NVMe SSD. This is the absolute smallest configuration at 176mm x 176mm x 52mm.
*   **Minimal Configuration:** Motherboard, CPU, low-profile heatsink (Noctua NH-L12S with 120mm thin fan), NVMe SSD, and a Flex ATX PSU. Includes dedicated PSU compartment.
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
    *   **Pico ATX:** DC-DC converter PCB mounted on motherboard (60mm x 50mm x 10mm typical). External AC-DC adapter. DC input via 5.5mm x 2.5mm barrel jack on back panel.
    *   **Flex ATX:** 150mm x 81.5mm x 40mm (L x W x H). Compact option for space-constrained builds.
    *   **SFX:** 125mm x 100mm x 63.5mm (L x W x H). Higher wattage option for GPU configurations.
*   **CPU Cooler Options:**
    *   **Noctua NH-L9:** 37mm height, 95mm x 95mm footprint. Used in Pico configuration for ultra-compact builds.
    *   **Noctua NH-L12S:** 70mm height, 128mm x 146mm footprint. Used in Minimal and NAS configurations.
*   **3.5" HDD:** 146mm x 101.6mm x 26.1mm (L x W x H). Used in NAS configurations.
*   **2.5" SSD:** 100mm x 69.85mm x 7mm (L x W x H). Optional storage expansion.

### 2.1. Motherboard Mounting - Integrated Bottom Panel

The motherboard mounting system uses an integrated design where the bottom panel directly accepts standoff bases via hexagonal recesses. This eliminates the separate motherboard plate component while improving structural integrity.

**Standoff Mounting System:**
*   **Mounting Points:** Four hexagonal recesses on bottom panel interior surface
*   **Pattern:** Standard Mini-ITX: [12.7, 12.7], [165.1, 12.7], [12.7, 165.1], [165.1, 165.1] mm from panel origin
*   **Standoff Type:** M3x6+6mm male-female standoffs
    *   Lower portion: 6mm female thread (accepts mounting screw from below)
    *   Upper portion: 6mm male threaded stud protruding above motherboard surface

**Hexagonal Receptacle Specifications:**
*   **Hex Size:** 5.5mm flat-to-flat (matches M3 hex head width)
*   **Boss Height:** 2.5mm above panel interior surface
*   **Pocket Depth:** 2.2mm (recessed to accommodate hex screw head)
*   **Total Recess Depth:** ~4.7mm (pocket + boss clearance)

**Fastening Method:**
*   **Screw Type:** M3 socket head cap screw (ISO 4762)
*   **Screw Length:** M3 x 8mm (recommended)
*   **Screw Orientation:** Upward through panel from underneath (bottom-up mounting)
*   **Thread Engagement:** 6mm into standoff female thread
*   **Torque Specification:** 1.5-2.0 Nm (finger-tight plus 1/4 turn)

**Configuration Heights:**
*   **All Configurations:** Standoff height = 6mm female thread portion + 2.5mm boss height = 8.5mm from bottom panel surface to motherboard mounting surface
*   This applies to: Minimal, NAS 2-disk, NAS many-disk, and GPU configurations

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
*   **Unified Mounting System:** Four #6-32 threaded mounting points at the corners of the **bottom panel** serve dual purposes:
    *   When standalone: Rubber feet screw into these holes.
    *   When expanded: NAS enclosure attaches via these same mounting points.
    *   **Note:** These #6-32 corner mounts are separate from the M3 standoff mounting system. The bottom panel features both: M3 hexagonal recesses for motherboard standoffs (at Mini-ITX pattern positions) and #6-32 threaded holes at corners for NAS/feet attachment.
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

### 8.1. Pico Configuration

*   **Width:** 176mm (mobo_width 170mm + 2 × wall_thickness 6mm)
*   **Depth:** 176mm (mobo_depth 170mm + 2 × wall_thickness 6mm)
*   **Height:** ~63mm (standoffs 6mm + mobo 1.6mm + I/O shield 44.45mm + offset 5mm + walls 6mm)
*   **Volume:** ~2.0L (0.176 × 0.176 × 0.063 m³)
*   **Note:** Height controlled by I/O shield (taller than NH-L9 cooler at 37mm)

### 8.2. Minimal Configuration

*   **Width:** 226mm (controlled by NAS 2-disk HDD layout - see Section 3.3)
*   **Depth:** 176mm
*   **Height:** ~100mm (standoffs 6mm + mobo 1.6mm + NH-L12S cooler 70mm + walls 6mm)

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

### 9.1. Two-Shell Assembly Concept

The case uses a two-shell dovetail assembly system for tool-free construction with user-accessible opening:

*   **Bottom Shell (Base Assembly):** Bottom panel + Back panel joined via internal dovetails (semi-permanent connection). The back panel remains attached to the bottom when opening the case.
*   **Top Shell (Upper Assembly):** Top + Front + Left side + Right side panels interconnected via internal dovetail clips, forming a removable shell that slides off as a single unit.
*   **Shell Connection:** Top shell connects to bottom panel via non-locking dovetails at the front and side bottom edges. These provide structural alignment without catches.
*   **User Access:** Back panel has male dovetail clips on its left/right edges that engage with female clips on the side panels. User pinches the back panel clips to release, then slides the top shell forward along the Y axis.
*   **Assembly Method:** Snap-fit dovetail clips enable tool-free assembly; non-locking dovetails provide structural integrity without impeding shell separation.

### 9.2. Materials

*   **Primary Material:** 3D printed (PLA or PETG)
*   **Wall Thickness:** 3mm (standard panels), 6mm where dovetail boss required

#### 9.2.1. Retention Lip System

The front and side panels incorporate internal retention lips that extend into the case interior, providing additional structural rigidity and alignment between panels:

**Retention Lip Geometry:**
*   **Dimensions:** 3mm (width) × 3mm (height)
*   **Position:** Bottom lip at Z=3mm, top lip at Z=(panel_height - 6mm)
*   **Orientation:** Protrudes inward from panel interior face
*   **Purpose:** Provides panel-to-panel alignment and prevents racking/flexing

**Front Panel Retention Lips:**
*   **Location:** Interior face along bottom and top edges
*   **Length:** Extends across panel width minus 2×wall_thickness (excludes side edges)
*   **Function:** Aligns with bottom panel edge, provides structural stiffness

**Side Panel Retention Lips:**
*   **Location:** Interior face running front-to-back
*   **Length:** Full panel depth (170mm) plus extension tongues
*   **Extension Tongues:** 3mm × 3mm × 3mm tabs extending beyond panel back edge
*   **Function:** Tongues fit into back panel slots for precise alignment

**Back Panel Retention Lip Slots:**
*   **Location:** Left and right edges of back panel interior face
*   **Dimensions per slot:** 6mm (width) × 3.2mm (depth) × 3mm (height)
*   **Position:** Bottom slot at Z=3mm, top slot at Z=(panel_height - 6mm)
*   **Width:** Extends 2×wall_thickness to accommodate side panel thickness + tongue
*   **Function:** Receives side panel extension tongues for panel-to-panel locking

**Assembly Interaction:**
1. Side panel tongues slide into back panel slots as top shell moves backward
2. Retention lips prevent vertical panel movement and distribute stress
3. Tongue-and-slot connection adds mechanical interlock beyond dovetails alone

### 9.3. Dovetail Joint Geometry

The dovetail joint system uses chamfered trapezoidal profiles with integrated snap-fit latches:

| Parameter | Value | Description |
|-----------|-------|-------------|
| Dovetail Angle | 15° | Angle from vertical |
| Engagement Depth | 3mm | How deep the joint engages |
| Base Width | 8mm | Width at narrow end of dovetail |
| Clearance | 0.15mm | Per-side clearance (FDM tuned) |
| Top Width | Calculated | base_width + 2 × depth × tan(angle) |

### 9.4. Male Dovetail (Rail)

The male dovetail is a trapezoidal rail that protrudes from panel edges:

*   **Profile:** Narrower at base (panel edge), wider at tip
*   **Center Slot:** 5mm wide slot creates two flex arms for snap-fit mechanism
*   **Slot Margin:** 2mm solid material at base end for structural integrity, open at free end
*   **Catch Bumps:** Symmetric ramped bumps on both outer faces at the free end

**Catch Profile:**
```
        ___________
       /           \
      /   plateau   \
     /    (3mm)      \
____/                 \____
   entry             exit
   ramp              ramp
   (2mm)             (2mm)
```

| Parameter | Value | Description |
|-----------|-------|-------------|
| Catch Height | 0.8mm | Bump protrusion from dovetail face |
| Catch Plateau | 3mm | Flat top of bump |
| Catch Ramp | 2mm | Entry and exit ramp length |

### 9.5. Female Dovetail (Channel)

The female dovetail is a trapezoidal channel cut into panel edges:

*   **Boss Design:** 3mm raised rectangular section only where channel is cut (saves ~50% material vs thickening entire panel)
*   **Channel Profile:** Wider at interior (entry point), narrower at panel surface (locking point)
*   **Geometry Method:** hull() approach connecting two rectangles at different Z positions
*   **Catch Recesses:** Ramped recesses cut into inner channel walls for snap-fit engagement
*   **Window Clearance:** 0.3mm clearance around catches in recesses

### 9.6. Panel Edge Assignments

**Dovetail Types:**
*   **Clip:** Has snap-fit catches for secure locking
*   **Non-locking:** Friction-fit only, no catches - provides structural alignment and rigidity

**Structural Integrity via Non-Locking Dovetails:**

The case uses non-locking (friction-fit) dovetails at specific panel connections to provide structural rigidity while allowing easy assembly and disassembly:

*   **Front-to-Bottom Connection:** Male dovetails on the front panel's bottom edge fit into female channels on the bottom panel. These provide vertical alignment and prevent panel flex at the bottom of the front panel.
*   **Top-to-Back Connection:** Male dovetails on the back panel's top edge fit into female channels on the top panel. These provide vertical alignment at the case's rear-top corner and prevent the back panel from racking under load.

Both of these structural connections use non-locking dovetails (without snap-fit catches) to allow the panels to separate freely when needed, while providing the rigidity that a simple butt joint cannot offer. This design ensures the case remains square and rigid without requiring complex fasteners.

**Bottom Shell (Base Assembly):**

| Panel | Edge | Dovetail Type | Connects To | Access |
|-------|------|---------------|-------------|--------|
| Bottom | Back edge | Female | Back panel bottom | Internal |
| Bottom | Left edge | Female (non-locking) | Left side bottom | Internal |
| Bottom | Right edge | Female (non-locking) | Right side bottom | Internal |
| Bottom | Front edge | Female (non-locking) | Front panel bottom | Internal |
| Back | Bottom edge | Male | Bottom panel back | Internal |
| Back | Left edge | Male (clip) | Left side back | External |
| Back | Right edge | Male (clip) | Right side back | External |

**Top Shell (Upper Assembly):**

| Panel | Edge | Dovetail Type | Connects To | Access |
|-------|------|---------------|-------------|--------|
| Top | Front edge | Female (clip) | Front panel top | Internal |
| Top | Left edge | Female (clip) | Left side top | Internal |
| Top | Right edge | Female (clip) | Right side top | Internal |
| Top | Back edge | Female (non-locking) | Back panel top | Internal |
| Front | Top edge | Male (clip) | Top panel front | Internal |
| Front | Bottom edge | Male (non-locking) | Bottom panel front | Internal |
| Left Side | Top edge | Male (clip) | Top panel left | Internal |
| Left Side | Bottom edge | Male (non-locking) | Bottom panel left | Internal |
| Left Side | Back edge | Female (clip) | Back panel left | External |
| Right Side | Top edge | Male (clip) | Top panel right | Internal |
| Right Side | Bottom edge | Male (non-locking) | Bottom panel right | Internal |
| Right Side | Back edge | Female (clip) | Back panel right | External |
| Back | Top edge | Male (non-locking) | Top panel back | Internal |

**Assembly Order (Top Shell):**
1. Connect front panel to both side panels (front male clips → side female clips at front edges)
2. Lower top panel onto the front+sides sub-assembly (side/front male clips → top female clips)
3. Connect top panel back edge into back panel top (top female channels → back male dovetails for structural rigidity)

**Full Case Assembly:**
1. Assemble bottom shell: Insert back panel male dovetail into bottom panel female channel
2. Assemble top shell: Connect front, sides, and attach top panel (including back edge connection for rigidity)
3. Place top shell onto bottom panel (non-locking dovetails align at front/side bottom edges)
4. Slide top shell back until side panel female clips engage with back panel male clips (audible click)
   - This final locking action also seats the top-to-back structural dovetails

### 9.7. Print Orientation

Print orientation is critical for snap-fit functionality:

*   **Male Dovetails:** Print with dovetails facing DOWN against build plate
    *   Layer lines run parallel to flex arms
    *   Enables proper elastic deformation during insertion/release
    *   Printing dovetails-up causes prongs to snap instead of flex
*   **Female Dovetails:** Print with channels facing UP
    *   Support-free printing of chamfered surfaces
    *   Outer panel face down on build plate

### 9.8. Assembly & Disassembly

**To Assemble Individual Joints (Insert):**
1. Align male dovetail with female channel
2. Slide forward - ramped catches cam inward against channel walls
3. When catches align with recesses, they snap in (audible click)

**To Disassemble Individual Joints (Release):**
1. Squeeze the two flex halves of the male dovetail together (pinch at free end)
2. Center slot compresses, catches retract from recesses
3. Slide panels apart

**To Open Case (Normal Operation):**
1. Locate the back panel - male dovetail clips are exposed on left and right edges
2. Pinch both male dovetail flex arms on back panel to retract catches from side panel female clips
3. Slide top shell forward along Y axis (toward front of case)
4. Non-locking bottom dovetails allow top shell to slide freely once back clips are released
5. Lift top shell away for full access to internal components
6. Back panel remains attached to bottom panel (base assembly stays intact)

**To Close Case:**
1. Position top shell above bottom panel, aligning non-locking dovetails at front and side bottom edges
2. Lower top shell onto bottom panel
3. Slide top shell backward along Y axis until side panel clips engage with back panel clips (audible click)

### 9.9. Ventilation

*   **Ventilation Pattern:** Honeycomb pattern for optimal strength-to-airflow ratio
*   **Ventilation Locations:** Top panel (above CPU cooler), side panels (intake), back panel (above I/O shield)

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

*   **Type:** M3x6+6mm male-female standoff
*   **Lower Portion:** 6mm female thread (accepts motherboard mounting screw from below)
*   **Upper Portion:** 6mm male threaded stud protruding above the motherboard surface
*   **Thread Specification:** M3

### 11.2. Frame Cylinders

*   **Material:** TODO - 3D printed, aluminum?
*   **Internal Thread:** Matches standoff male thread
*   **Mounting:** Free-floating within frame structure (captive but rotatable)
*   **Purpose:** Serve as foundation for case panels to attach to

### 11.3. Assembly Process

1.  Position bottom panel with interior side facing up (for screw access)
2.  Insert M3 x 8mm screws through bottom panel from underneath
3.  Position extended standoffs in hexagonal recesses (female thread facing down)
4.  Thread screws upward into standoff female threads (6mm engagement minimum)
5.  Torque screws to 1.5-2.0 Nm (finger-tight plus 1/4 turn)
6.  Flip assembly and mount motherboard onto standoff male studs from above
7.  Place upper frame over motherboard
8.  Hand-tighten frame cylinders onto standoff male studs (tool-free assembly)

## 12. Rapid Panel Mounting System

The case panels use the dovetail snap-fit system (see Section 9) for tool-free rapid access to internal components.

### 12.1. Quick-Release Mechanism

*   **Type:** Snap-fit dovetail latches with squeeze-to-release flex arms
*   **Location:** All panel edges where panels connect (see Section 9.6 for edge assignments)
*   **Operation:** Pinch the male dovetail flex arms to release catches, then slide apart
*   **Security:** Friction fit provides secure hold; panels cannot accidentally detach

### 12.2. Two-Shell Design

The case consists of two interconnected shell assemblies:

**Bottom Shell (Base Assembly):**
*   **Components:** Bottom panel + Back panel
*   **Connection:** Back panel male dovetail inserts into bottom panel female channel (semi-permanent)
*   **Stability:** Remains assembled during normal case opening/closing
*   **Back Panel Role:** Provides the locking interface for the top shell via external male clips

**Top Shell (Upper Assembly):**
*   **Components:** Top + Front + Left side + Right side panels
*   **Internal Connections:** All panels connected via internal dovetail clips (semi-permanent)
*   **Shell Assembly:** Front panel connects to both side panels via clips, then top panel caps the assembly
*   **One-Piece Removal:** Entire top shell slides off and lifts away as a single unit
*   **Full Access:** Removing shell exposes motherboard, CPU cooler, and all internal components

**Shell-to-Shell Interface:**
*   **Structural:** Non-locking dovetails at front and side bottom edges provide alignment
*   **Locking:** Back panel male clips engage side panel female clips (user-accessible release)
*   **No Hinges Required:** Sliding dovetail system eliminates need for separate hinge mechanisms

### 12.3. Benefits

*   Tool-free panel removal for maintenance and upgrades
*   Single-handed operation for quick access (squeeze and slide)
*   Upper shell handled as single assembly - no loose panels
*   Audible click confirms secure panel engagement
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