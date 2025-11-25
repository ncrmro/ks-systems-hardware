# Modular and Expandable Computer Case Specification

## 1. Overview

This document outlines the design requirements for a modular and expandable computer case. The case is designed to be configurable for different use cases, starting with a basic compact configuration and allowing for expansion, such as for an external GPU.

## 2. Core Components

The case is designed around the following core components:

*   **Motherboard:** Mini-ITX form factor (170mm x 170mm).
*   **Power Supply (Flex ATX):** 150mm x 81.5mm x 40mm (L x W x H). Note: The current OpenSCAD model uses an SFX power supply (125mm x 100mm x 63.5mm) for visualization purposes.
*   **CPU Cooler:** Noctua NH-L12S (70mm height without fan).

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

### 4.1. Orientation

*   The case is designed to stand vertically.
*   The motherboard's rear I/O ports shall face down.
*   The external GPU's I/O ports shall also face down.

### 4.2. Layout

*   The GPU is mounted vertically ("standing tall").
*   A PCIe riser cable is required to connect the GPU to the motherboard.
*   The case needs to provide adequate ventilation for the GPU.

## 5. Modularity and Expandability

The case design shall incorporate modular elements to allow for the following:

*   Easy transition between the Base Configuration and the External GPU Configuration.
*   Addition of other components, such as storage drives (2.5" SSDs).
*   Customizable panels for different aesthetics or ventilation options.
