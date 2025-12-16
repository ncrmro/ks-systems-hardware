import anchorscad as ad
import pytest
from lib.cooling import Fan, FAN_120_25, FAN_120_15
from lib.psu import SfxPsu, FlexAtxPsu

def test_fan_generation():
    # 120x25
    fan = Fan(dim=FAN_120_25)
    maker = fan.build()
    assert maker is not None
    
    # 120x15
    fan_slim = Fan(dim=FAN_120_15)
    maker_slim = fan_slim.build()
    assert maker_slim is not None

def test_sfx_psu_generation():
    psu = SfxPsu()
    maker = psu.build()
    assert maker is not None
    # Check dimensions approximately by bounding box logic if possible, 
    # but ad.Maker doesn't easily expose bbox without processing.
    # We rely on no crash.

def test_flex_atx_psu_generation():
    psu = FlexAtxPsu()
    maker = psu.build()
    assert maker is not None
