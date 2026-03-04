---
repo: ncrmro/ks-systems-hardware
branch: fix/dovetail-position
agent: gemini
github_issue: 6
priority: 1
status: ready
created: 2026-03-04
---

# Fix PR #6 Copilot Review Comments

## Description

PR #6 (`fix/dovetail-position`) received 9 review comments from Copilot. All are cleanup items — broken doc links, unused params/variables, and stale docstrings. No behavioral changes needed.

Tech stack: Python + AnchorSCAD (`@ad.shape`, `@datatree`, `CompositeShape`). Nix dev shell. Tests via `bin/test` (pytest). SCAD generation via `bin/render`.

**Working directory**: `.repos/ncrmro/ks-systems-hardware/.worktrees/fix/dovetail-position/`

## Acceptance Criteria

- [x] **Remove broken doc links from AGENTS.md**: Lines 178-180 and 184-186 reference `.deepwork/jobs/cadeng/steps/shared/dovetail-conventions.md` and `.deepwork/jobs/cadeng/steps/shared/screenshot-conventions.md` — these paths don't exist in this repo (they live in the obsidian vault). Remove the "See ..." sentences that reference these paths. Keep the learning content itself.

- [x] **Remove unused `dovetail_angle` param**: `src/components/dovetail.py:10` — `dovetail_angle: float = 15.0` is defined in `DovetailDimensions` but never used in any geometry calculation in `FemaleDovetail.build()` or `MaleDovetail.build()`. Remove it.

- [x] **Remove unused catch/ramp params**: `src/components/dovetail.py:16-18` — `catch_bump_height`, `catch_bump_length`, `catch_ramp_length` are defined in `DovetailDimensions` but never used in any build method. Remove them.

- [x] **Fix FemaleDovetail docstring**: `src/components/dovetail.py:28` says "Origin at center of boss top surface" but the shape uses `.at("centre")` which is the geometric center of the boss, not the top surface. Update to "Origin at geometric centre of boss."

- [x] **Fix MaleDovetail docstring**: `src/components/dovetail.py:66` says "Origin at center of rail base (XY plane), extends in +Z direction" but uses `.at("centre")`. Update to "Origin at geometric centre of rail."

- [x] **Fix LatchArm docstring**: `src/components/latch.py:25` says "Origin at the top attachment point" but uses `.at("centre")`. Update to "Origin at geometric centre of arm."

- [x] **Fix LatchLedge docstring**: `src/components/latch.py:55` says "Origin at the center of the ledge base (where it attaches to panel)" but uses `.at("centre")`. Update to "Origin at geometric centre of ledge."

- [x] **Remove unused `inner_width`**: `src/assemblies/pico.py:73` — `inner_width = panel_width - 2 * wall` is computed but never used in `PicoAssembly.build()`. Remove it. (Note: `inner_width` IS used in `PicoBasePanel` and `PicoBackPanel` — only remove it from `pico.py`.)

- [x] All 21 tests pass (`nix develop --command bin/test`)

## Agent Notes

- Removed 4 unused fields from `DovetailDimensions`: `dovetail_angle`, `catch_bump_height`, `catch_bump_length`, `catch_ramp_length`. None appeared in any `build()` method.
- Docstrings updated to reflect `.at("centre")` usage (geometric centre), not a face anchor.
- `inner_width` removed only from `PicoAssembly.build()` as instructed; the variable remains present in `PicoBasePanel` and `PicoBackPanel` where it is used.
- `panel_width` in `PicoAssembly.build()` is now technically unused after removing `inner_width`, but removing it was not in the task scope so it was left in place.
- Broken "See ..." sentences removed from AGENTS.md Learnings section; surrounding content preserved.

## Results

```
============================= test session starts ==============================
platform linux -- Python 3.13.9, pytest-9.0.2, pluggy-1.6.0
collected 21 items

tests/hardware_components_dimensions_test.py ............                [ 57%]
tests/lib_migration_test.py ...                                          [ 71%]
tests/test_heatsink_gap.py .                                             [ 76%]
tests/test_pico_dimensions.py ....                                       [ 95%]
tests/test_pico_heatsink_height.py .                                     [100%]

============================== 21 passed in 0.37s ==============================
```

All 39 parts render to SCAD successfully.
