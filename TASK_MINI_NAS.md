# Mini-NAS Case Width Implementation Tasks

This document tracks the implementation of the case width changes for the Mini-NAS configuration.

## Design Summary

The case width is controlled by the NAS 2-disk configuration (2 HDDs side-by-side = ~226mm). See SPEC.md Section 3.3 for full design rationale.

**Target Width:** 226mm
- Motherboard area: 170mm
- PSU compartment: 56mm (Flex ATX on side = 40mm + 16mm clearance)

---

## Tasks

### Phase 1: Update Shared Dimensions

| Task | File | Status | Notes |
|------|------|--------|-------|
| Add `nas_2disk_width` variable | `modules/case/dimensions.scad` | DONE | ~226mm (controlling dimension) |
| Add `psu_compartment_width` variable | `modules/case/dimensions.scad` | DONE | 56mm (nas_2disk_width - mobo_width) |
| Update `minimal_with_psu_width` | `modules/case/dimensions.scad` | DONE | Now uses nas_2disk_width |

### Phase 2: Update Base Case

| Task | File | Status | Notes |
|------|------|--------|-------|
| Update case plate width | `modules/case.scad` | DONE | Extended to nas_2disk_width (~226mm) |
| Update backplate width | `modules/case.scad` | DONE | Extended to nas_2disk_width (~226mm) |
| Add PSU mounting screw holes | `modules/case.scad` | DONE | 8-32 UNC holes in PSU compartment area |
| Verify honeycomb ventilation | `modules/case.scad` | DONE | Pattern limited to mobo area (170mm) |

### Phase 3: Verify NAS Alignment

| Task | File | Status | Notes |
|------|------|--------|-------|
| Verify NAS frame width | `modules/case/nas_2disk/frame.scad` | DONE | Uses nas_2disk_width (~226mm) |
| Ensure width derives from shared dimensions | `modules/case/nas_2disk/frame.scad` | DONE | Now includes dimensions.scad |

---

## PSU Mounting Screw Specifications

- **Thread:** 8-32 UNC (Flex ATX standard)
- **Hole radius:** 2.1mm (8-32 clearance)
- **Horizontal spacing:** 63.5mm
- **Vertical spacing:** 12.5mm from edges
- **Position:** PSU compartment area (X = 170mm to 226mm)

---

## Verification Checklist

- [ ] Case width = 226mm
- [ ] Backplate width = 226mm
- [ ] NAS enclosure width = 226mm (aligned with base)
- [ ] PSU (40mm on side) fits in 56mm compartment
- [ ] PSU screw holes align with Flex ATX mounting pattern
- [ ] I/O shield cutout unchanged (centered in 170mm mobo area)
