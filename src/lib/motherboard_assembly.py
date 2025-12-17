import anchorscad as ad
from anchorscad import datatree
from typing import Optional
from dataclasses import field

from config import PicoDimensions
from registry import register_part
from lib.motherboard import MiniItxMotherboard
from lib.ram import RamStick
from lib.psu import PicoPsu
from lib.heatsink import NoctuaL9

@register_part("motherboard_assembly_pico")
def create_motherboard_assembly_pico() -> ad.Shape:
    return MotherboardAssemblyPico(dim=PicoDimensions())

@ad.shape
@datatree
class MotherboardAssemblyPico(ad.CompositeShape):
    """
    Assembly of Motherboard + RAM + Cooler + PicoPSU.
    Used for the Pico case configuration.
    """
    dim: PicoDimensions
    
    def build(self) -> ad.Maker:
        # 1. Motherboard
        mobo = MiniItxMotherboard(dim=self.dim.mobo)
        assembly = mobo.solid("motherboard").at("centre")
        
        # 2. RAM Stick (Slot 1)
        # Position approx: X=110, Y=50 (relative to corner). 
        # Center-to-center:
        # Mobo Center is (0,0,0) (PCB center). 
        # Mobo size 170x170. Corner (-85, -85).
        # RAM pos from corner: ~110mm right, ~50mm back.
        # RAM center X = -85 + 110 = 25.
        # RAM center Y = -85 + 50 = -35.
        # RAM sits on top of PCB (Z = pcb_thickness/2 + ram_height/2).
        # RAM rotated 0 or 90? Usually parallel to front/back (X axis) or side (Y axis)?
        # ITX slots usually parallel to PCIe (X axis) or perpendicular?
        # Standard Mini-ITX: RAM slots are usually along the top edge or right edge.
        # Let's assume parallel to Front (X axis) near the CPU.
        
        
        ram = RamStick()
        ram_x1 = -1.325 # Derived from OpenSCAD: (17 + L/2) - (Mobo W/2)
        ram_y1 = -79.4 # Derived from OpenSCAD: (5 + T/2) - (Mobo D/2)
        ram_z = self.dim.mobo.pcb_thickness / 2 + ram.dim.height / 2
        
        # First RAM stick
        assembly.add_at(
            ram.solid("ram_stick_1").at("centre"),
            post=ad.translate([ram_x1, ram_y1, ram_z])
        )
        
        # Second RAM stick (offset by 8mm in Y from the first)
        ram_y2 = ram_y1 + 8.0
        assembly.add_at(
            ram.solid("ram_stick_2").at("centre"),
            post=ad.translate([ram_x1, ram_y2, ram_z])
        )
        
        # 3. Cooler (Noctua NH-L9)
        # Centered on CPU socket.
        # Socket pos from corner: ~85mm, ~85mm (Center of board).
        # So CPU is at (0,0).
        # Cooler sits on top of CPU (on top of PCB).
        # We need to rotate it? "Rotated 90 deg CCW" in legacy scad.
        
        cooler = NoctuaL9(dim=self.dim.cooling)
        cooler_z = self.dim.mobo.pcb_thickness / 2
        
        # OpenSCAD: translate([115, 20, mobo_pcb_thickness]) -> relative to mobo bottom-front-left
        # Converted to Python (relative to mobo center, Z is mobo center)
        # X: 115 - 85 = 30. New X for 20mm clearance from left edge: -17.5
        # Motherboard left edge at X=-85. Heatsink left edge at X=-85 + 20 = -65.
        # Heatsink X center = -65 + (95/2) = -65 + 47.5 = -17.5.
        # Y: 20 - 85 = -65. New Y for 20mm clearance from front edge: -17.5
        # Motherboard front edge at Y=-85. Heatsink front edge at Y=-85 + 20 = -65.
        # Heatsink Y center = -65 + (95/2) = -65 + 47.5 = -17.5.
        assembly.add_at(
            cooler.solid("cooler").at("base"), # Base anchor is contact surface
            post=ad.translate([-17.5, -17.5, cooler_z]) * ad.rotZ(90)
        )
        
        # 4. PicoPSU
        # Plugs into ATX connector.
        # ATX connector is at Right Edge (X=85).
        # PicoPSU sits on top/in it.
        # ATX connector center calculated in motherboard.py:
        # atx_x = width/2 - 10/2 = 85 - 5 = 80.
        # atx_y = -depth/2 + 25 + 51.6/2 = -85 + 25 + 25.8 = -34.2.
        # atx_z = thick/2 + 13/2.
        
        # PicoPSU should align with this.
        # PicoPSU is a box 50(W) x 30(D) x 35(H).
        # It should overlap/extend from the ATX connector.
        # Let's place it centered on the ATX connector for now, shifted up.
        
        psu = PicoPsu(dim=self.dim.psu)
        # Align to the actual ATX connector on the motherboard model.
        atx_x = self.dim.mobo.width / 2 - 5.0  # matches MiniItxMotherboard placement
        atx_y = -self.dim.mobo.depth / 2 + 25.0 + 51.6 / 2
        psu_x = atx_x
        psu_y = atx_y
        # Seat the male connector so its bottom sits on top of the PCB surface.
        psu_z = self.dim.mobo.pcb_thickness + psu.dim.connector_height / 2
        
        assembly.add_at(
            psu.solid("pico_psu").at("centre"),
            post=ad.translate([psu_x, psu_y, psu_z]) * ad.rotZ(90)
        )
        
        return assembly
