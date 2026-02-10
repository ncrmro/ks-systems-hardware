import anchorscad as ad
import pytest
from config import PicoDimensions
from parts.case_pico import PicoBottomTray, PicoTopHat, PicoSideFlap
from parts.hinge import HingeKnuckle, HingeLine, LatchHook
from parts.ssd_harness import SsdHarness

def test_pico_bottom_tray_builds():
    shape = PicoBottomTray(dim=PicoDimensions())
    assert shape.build() is not None

def test_pico_top_hat_builds():
    shape = PicoTopHat(dim=PicoDimensions())
    assert shape.build() is not None

def test_pico_side_flap_builds():
    shape = PicoSideFlap(dim=PicoDimensions(), side="left")
    assert shape.build() is not None

def test_ssd_harness_builds():
    shape = SsdHarness(dim=PicoDimensions())
    assert shape.build() is not None

def test_hinge_knuckle_builds():
    from parts.hinge import HingeDimensions
    shape = HingeKnuckle(dim=HingeDimensions(), mode="male")
    assert shape.build() is not None
    shape_f = HingeKnuckle(dim=HingeDimensions(), mode="female")
    assert shape_f.build() is not None

def test_hinge_line_builds():
    from parts.hinge import HingeDimensions
    shape = HingeLine(dim=HingeDimensions(), length=100.0)
    assert shape.build() is not None

def test_latch_hook_builds():
    shape = LatchHook()
    assert shape.build() is not None

def test_pico_assembly_builds():
    from assemblies.pico import PicoAssembly
    shape = PicoAssembly(dim=PicoDimensions())
    assert shape.build() is not None
    
    shape_exploded = PicoAssembly(dim=PicoDimensions(), exploded=True)
    assert shape_exploded.build() is not None
