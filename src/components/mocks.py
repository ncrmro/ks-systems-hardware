import anchorscad as ad
from registry import register_part
from config import CommonDimensions, MinimalDimensions

# Imports from vitamins
from vitamins.motherboard import MiniItxMotherboard
from vitamins.storage import SSD25
from vitamins.ram import RamStick
from vitamins.cooling import Fan, FAN_120_25, FAN_120_15
from vitamins.psu import SfxPsu, FlexAtxPsu

@register_part("motherboard_mini_itx", part_type="vitamin")
def create_motherboard() -> ad.Shape:
    return MiniItxMotherboard(dim=CommonDimensions().mobo)

@register_part("ssd_2_5", part_type="vitamin")
def create_ssd() -> ad.Shape:
    return SSD25()

@register_part("ram_stick", part_type="vitamin")
def create_ram() -> ad.Shape:
    return RamStick()

@register_part("fan_120_25", part_type="vitamin")
def create_fan_120_25() -> ad.Shape:
    return Fan(dim=FAN_120_25)

@register_part("fan_120_15", part_type="vitamin")
def create_fan_120_15() -> ad.Shape:
    return Fan(dim=FAN_120_15)

@register_part("psu_sfx", part_type="vitamin")
def create_psu_sfx() -> ad.Shape:
    return SfxPsu()

@register_part("psu_flex_atx", part_type="vitamin")
def create_psu_flex_atx() -> ad.Shape:
    return FlexAtxPsu()
