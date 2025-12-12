# Keystone Hardware

A modular, expandable computer case designed in OpenSCAD. The case supports multiple configurations from ultra-compact to full GPU builds.

![Minimal Configuration - Exploded View](https://r2.ks.systems/openscad-screenshots/assembly-minimal-exploded.png)

## Configurations

| Configuration | Description | Dimensions |
|--------------|-------------|------------|
| **Pico** | Ultra-compact with Pico ATX PSU and NH-L9 cooler | 176 x 176 x ~63mm |
| **Minimal** | Mini-ITX + Flex ATX PSU (horizontal) | ~226 x 173 x 100mm |
| **NAS 2-disk** | Base + 2 HDDs with passive chimney airflow | 226 x 173 x ~150mm |
| **NAS many-disk** | Base + 5-8 HDDs with active fan cooling | 226 x 173 x ~200mm |
| **GPU** | Vertical orientation with full-size GPU, SFX PSU | 171 x 378 x 190mm |
| **GPU AIO** | GPU config with 240mm AIO liquid cooling | 171 x 378 x 190mm |

## Gallery

<table>
<tr>
<td><strong>Pico</strong></td>
<td><strong>Minimal</strong></td>
<td><strong>NAS 2-disk</strong></td>
</tr>
<tr>
<td><img src="https://r2.ks.systems/openscad-screenshots/assembly-pico-exploded.png" width="250"/></td>
<td><img src="https://r2.ks.systems/openscad-screenshots/assembly-minimal-exploded.png" width="250"/></td>
<td><img src="https://r2.ks.systems/openscad-screenshots/assembly-nas_2disk-exploded.png" width="250"/></td>
</tr>
<tr>
<td><strong>NAS many-disk</strong></td>
<td><strong>GPU</strong></td>
<td><strong>GPU AIO</strong></td>
</tr>
<tr>
<td><img src="https://r2.ks.systems/openscad-screenshots/assembly-nas_many-exploded.png" width="250"/></td>
<td><img src="https://r2.ks.systems/openscad-screenshots/assembly-gpu-exploded.png" width="250"/></td>
<td><img src="https://r2.ks.systems/openscad-screenshots/assembly-gpu_aio-exploded.png" width="250"/></td>
</tr>
</table>

## Requirements

- [OpenSCAD](https://openscad.org/) (2021.01 or later recommended)

## Usage

Preview a configuration in OpenSCAD:

```bash
openscad assemblies/minimal.scad
openscad assemblies/pico.scad
openscad assemblies/gpu.scad
```

Render to STL for 3D printing:

```bash
openscad -o output.stl assemblies/minimal.scad
```

## Project Structure

```
assemblies/          # Complete case configurations
modules/
├── case/
│   ├── dimensions.scad   # Shared dimensions
│   ├── base/             # Core frame components
│   ├── panels/           # Side, top, bottom panels
│   ├── nas_2disk/        # 2-disk NAS enclosure
│   └── nas_many/         # Many-disk NAS enclosure
├── components/           # Hardware models
│   ├── motherboard/      # Mini-ITX assemblies
│   ├── power/            # PSU models (SFX, Flex ATX, Pico)
│   ├── storage/          # HDDs, SSDs
│   └── cooling/          # Fans, radiators, AIO
└── util/                 # Helper modules
```

## Design Features

- **Modular stacking**: NAS enclosures mount underneath base via 4x #6-32 corner holes
- **Passive cooling**: Chimney airflow design for quiet NAS operation
- **Integrated standoffs**: Bottom panel includes hexagonal recesses for motherboard mounting
- **Dovetail joints**: Tool-free panel assembly

## License

MIT License - See [LICENSE](LICENSE) for details.
