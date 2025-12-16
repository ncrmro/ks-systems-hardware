import anchorscad as ad
from registry import register_part
from config import CommonDimensions, MinimalDimensions

# Imports from lib
from lib.motherboard import MiniItxMotherboard
from lib.storage import SSD25
from lib.ram import RamStick
from lib.cooling import Fan, FAN_120_25, FAN_120_15
from lib.psu import SfxPsu, FlexAtxPsu

@register_part("motherboard_mini_itx")
def create_motherboard() -> ad.Shape:
    return MiniItxMotherboard(dim=CommonDimensions().mobo)

@register_part("ssd_2_5")
def create_ssd() -> ad.Shape:
    return SSD25()

@register_part("ram_stick")
def create_ram() -> ad.Shape:
    return RamStick()

@register_part("fan_120_25")
def create_fan_120_25() -> ad.Shape:
    return Fan(dim=FAN_120_25)

@register_part("fan_120_15")
def create_fan_120_15() -> ad.Shape:
    return Fan(dim=FAN_120_15)

@register_part("psu_sfx")
def create_psu_sfx() -> ad.Shape:
    return SfxPsu()

@register_part("psu_flex_atx")
def create_psu_flex_atx() -> ad.Shape:
    # Use dimensions from Minimal config if needed, or default
    return FlexAtxPsu()
