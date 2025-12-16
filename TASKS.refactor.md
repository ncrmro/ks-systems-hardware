# Refactoring Tasks: Migration to Python

This document tracks the migration of OpenSCAD modules to Python-based generators.

## Components to Migrate

### 1. Motherboard
- **Source:** `modules/components/motherboard/motherboard.scad` (and related files in that directory)
- **Target:** `src/lib/motherboard.py` (or similar)
- **Goal:** define motherboard dimensions and mounting holes in Python.

### 2. Storage (2.5" HDD/SSD)
- **Source:** `modules/components/storage/ssd_2_5.scad`
- **Target:** `src/lib/storage.py` (New file needed)
- **Goal:** Parametric generation of 2.5" drive geometry.

### 3. RAM Sticks
- **Source:** `modules/components/ram.scad`
- **Target:** `src/lib/ram.py` (New file needed)
- **Goal:** Define RAM stick dimensions and possibly slot mechanisms.
