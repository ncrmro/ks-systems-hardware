import anchorscad as ad
from anchorscad import datatree
from typing import Optional
from dataclasses import field

from config import CommonDimensions
from registry import register_part
from lib.motherboard import MiniItxMotherboard
from lib.ram import RamStick
from lib.psu import PicoPsu
from parts.heatsink import NoctuaL12S

@register_part("motherboard_assembly_pico")
def create_motherboard_assembly_pico() -> ad.Shape:
    return MotherboardAssemblyPico(dim=CommonDimensions())

@ad.shape
@datatree
class MotherboardAssemblyPico(ad.CompositeShape):
    """
    Assembly of Motherboard + RAM + Cooler + PicoPSU.
    Used for the Pico case configuration.
    """
    dim: CommonDimensions
    
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
        ram_x = 25.0
        ram_y = -35.0
        ram_z = self.dim.mobo.pcb_thickness / 2 + ram.dim.height / 2
        
        assembly.add_at(
            ram.solid("ram_stick").at("centre"),
            post=ad.translate([ram_x, ram_y, ram_z])
        )
        
        # 3. Cooler (Noctua NH-L12S)
        # Centered on CPU socket.
        # Socket pos from corner: ~85mm, ~85mm (Center of board).
        # So CPU is at (0,0).
        # Cooler sits on top of CPU (on top of PCB).
        # We need to rotate it? "Rotated 90 deg CCW" in legacy scad.
        
        cooler = NoctuaL12S(dim=self.dim.cooling)
        cooler_z = self.dim.mobo.pcb_thickness / 2
        
        assembly.add_at(
            cooler.solid("cooler").at("base"), # Base anchor is contact surface
            post=ad.translate([0, 0, cooler_z]) * ad.rotZ(90)
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
        psu_x = 80.0
        psu_y = -34.2
        psu_z = self.dim.mobo.pcb_thickness / 2 + 13.0 + psu.dim.height / 2 
        
        assembly.add_at(
            psu.solid("pico_psu").at("centre"),
            post=ad.translate([psu_x, psu_y, psu_z])
        )
        
        return assembly
