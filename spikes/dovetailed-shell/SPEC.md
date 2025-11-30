# Dovetailed Shell Design Specification

## Overview

This spike explores a chamfered-dovetail joint system for assembling flat 3D-printed panels into a rigid shell structure. The design is fully parameterized to allow creating small prototype versions before printing production-scale panels.

## Design Goals

1. **Support-free printing**: All dovetail features printable flat without supports
2. **Semi-permanent assembly**: Panels lock by friction and geometry, removable with deliberate force
3. **No mechanical fasteners**: Joint system is integral to the printed panels
4. **Parameterized scaling**: Same design works for small prototypes and full-size panels

## Joint Geometry

### Dovetail Profile

```
        ┌─────────┐
       /           \
      /   45-60°    \
     /               \
    ┌─────────────────┐
```

- **Dovetail angle**: 45-60° from vertical (50° default)
- **Engagement depth**: 3-6mm depending on panel thickness
- **Clearance**: 0.25-0.35mm per side (PLA), 0.35-0.45mm (PETG)
- **Joint width**: Parameterized, typically 20-40% of panel edge length

### Female Dovetail (Channel)

- Cut into panel edge as a trapezoidal channel
- Wider at interior, narrower at panel edge
- Located at center of each edge on top panel

### Male Dovetail (Rail)

- Protrudes from panel edge as a trapezoidal rail
- Narrower at base, wider at tip
- Matches female channel with appropriate clearance

## Panel Specifications

### Top Panel

- Rectangular panel forming the top face of the shell
- **Thickness**: 6mm total
- **Female dovetails** on all 4 edges, cut into the bottom (inside) surface
- **Channel depth**: 3mm (does not penetrate through panel - top 3mm remains solid)
- Each dovetail channel centered on its respective edge, inset 3mm from panel edge
- Panel prints flat with top face down (channels facing up during print)

### Front Panel

- Rectangular panel forming the front face of the shell
- **Thickness**: 3mm
- **Male dovetail** on top edge only (for this initial implementation)
- **Rail height**: 3mm (matches top panel channel depth)
- Dovetail is **flush with panel top** (integrated into panel, not protruding)
- Dovetail rail centered on top edge
- Panel prints flat with front face down (dovetail rail facing up during print)

## Assembly

1. Position top panel with dovetail channels facing down
2. Slide front panel's male dovetail into top panel's front female channel
3. Panels self-align and lock via friction fit

## Parameters

### Global Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `scale_factor` | 1.0 | Scale all dimensions (0.5 = half size prototype) |
| `clearance` | 0.3mm | Joint clearance per side |

### Panel Dimensions

| Parameter | Default | Description |
|-----------|---------|-------------|
| `panel_width` | 100mm | Width of panels (X dimension) |
| `panel_depth` | 100mm | Depth of panels (Y dimension) |
| `panel_height` | 100mm | Height of side/front panels (Z dimension) |
| `top_panel_thickness` | 6mm | Top panel thickness |
| `front_panel_thickness` | 3mm | Front/side panel thickness |

### Dovetail Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `dovetail_angle` | 50° | Angle from vertical |
| `dovetail_depth` | 3mm | How deep the joint engages (channel/rail depth) |
| `dovetail_length` | 30mm | Length of dovetail along edge |
| `dovetail_base_width` | 8mm | Width at narrow end |
| `dt_edge_inset` | 3mm | Distance from panel edge to channel center |

### Calculated Values

- `dovetail_top_width` = `dovetail_base_width + 2 * dovetail_depth * tan(dovetail_angle)`

## Print Orientation

- **Top panel**: Print with outer (top) face down on bed. Dovetail channels face up during print, ensuring support-free printing of the chamfered surfaces.
- **Front panel**: Print with outer (front) face down on bed. Dovetail rail faces up during print.

## File Structure

```
spikes/dovetailed-shell/
├── SPEC.md                    # This specification
├── modules/
│   └── dovetail.scad          # Dovetail joint primitives
├── panels/
│   ├── top_panel.scad         # Top panel with female dovetails
│   └── front_panel.scad       # Front panel with male dovetail
├── prototypes/
│   └── assembly.scad          # Assembly of top + front panels
└── production/
    └── (future full-size exports)
```

## Testing Protocol

1. Print at 50% scale first to verify joint fit
2. Adjust `clearance` parameter based on test results
3. Print at 100% scale once joint geometry is validated
