
import anchorscad as ad
import numpy as np
import pytest
from lib.heatsink import NoctuaL9
from lib.cooling import CoolingDimensions

def get_transform_z(maker, target_name):
    """
    Recursively searches the Maker tree for a node with `target_name`.
    Returns the cumulative Z translation of that node relative to the root.
    """
    queue = [(maker, ad.IDENTITY, "root")]
    
    print(f"Searching for: {target_name}")
    print(f"Maker type: {type(maker)}")
    
    while queue:
        current_maker, current_transform, current_path = queue.pop(0)
        
        # Check if current node is target
        node_name_attr = getattr(current_maker, 'name', None)
        node_name = None
        if callable(node_name_attr):
            try:
                node_name = node_name_attr()
            except:
                pass
        elif isinstance(node_name_attr, str):
            node_name = node_name_attr
        
        print(f"  Visiting: '{node_name}' at {current_path}")
        
        if node_name == target_name:
             z = current_transform.get_translation()[2]
             print(f"    MATCH! Z={z}")
             return z

        # Check entries (children)
        if hasattr(current_maker, 'entries'):
            entries = current_maker.entries
            print(f"    Entries type: {type(entries)}")
            
            # If dict, iterate items
            if isinstance(entries, dict):
                iterator = entries.items()
            else:
                iterator = enumerate(entries)

            for k, entry in iterator:
                print(f"    Processing entry key: {k}, type: {type(entry)}")
                
                # Check for ModeShapeFrame (leaf/component wrapper)
                if hasattr(entry, 'shapeframe'):
                    sf = entry.shapeframe
                    name = sf.name
                    print(f"      Found ShapeFrame: '{name}'")
                    
                    matrix = sf.reference_frame
                    combined = current_transform * matrix
                    
                    if name == target_name:
                        z = combined.get_translation()[2]
                        print(f"    MATCH! Z={z}")
                        return z
                    
                    pass
                
                # Check for nested Maker (if entry is a Maker or wraps one)
                elif hasattr(entry, 'maker'):
                    # Previous logic for nested makers
                    child_maker = entry.maker
                    child_matrix = getattr(entry, 'matrix', ad.IDENTITY)
                    
                    combined = current_transform * child_matrix
                    
                    # Get name safely
                    c_name = "unknown"
                    c_name_attr = getattr(child_maker, 'name', None)
                    if callable(c_name_attr):
                        try:
                            c_name = c_name_attr()
                        except:
                            pass
                    
                    queue.append((child_maker, combined, f"{current_path}/{c_name}"))
                else:
                    print(f"      Unknown entry type: {type(entry)}")
        else:
             print(f"  Node at {current_path} has no 'entries' attribute.")

    return None

def test_noctua_l9_stacking():
    """
    Verifies that the Noctua L9 components are stacked without gaps.
    Stack: Base -> Fins -> Fan
    """
    # Use default dimensions or specific ones
    # Note: NoctuaL9 now defaults to using NOCTUA_L9 constants from lib.heatsink
    # but we can override with dim if needed. 
    # For this test, we can trust the defaults or pass them explicitly to be safe.
    # The class uses default_factory=CoolingDimensions, which now defaults to the constants in config? 
    # No, Config injects them. Lib/cooling.py has hardcoded defaults that MIGHT differ if not updated.
    # BUT, we updated config.py, not lib/cooling.py defaults.
    # NoctuaL9 in lib/heatsink.py uses self.dim fields.
    # If we instantiate NoctuaL9() without args, it uses CoolingDimensions() defaults.
    # Let's verify if CoolingDimensions defaults match.
    
    # Actually, to ensure the test passes with the NEW logic (constants), 
    # we should rely on the component behaving correctly.
    
    l9 = NoctuaL9() 
    maker = l9.build() # type: ignore
    
    # We need the dimensions to verify.
    # We can import them.
    from lib.heatsink import NOCTUA_L9
    
    # 1. Check Base position
    # The "base" solid is named "base".
    # It is a Box(h=5). Centered.
    # We expect its center Z to be 2.5 (so bottom is at 0).
    base_z = get_transform_z(maker, "base")
    assert base_z is not None, "Could not find 'base' in Maker tree"
    
    assert np.isclose(base_z, 2.5), f"Base center Z expected 2.5, got {base_z}"
    
    base_top = base_z + (NOCTUA_L9.base_height / 2)
    
    # 2. Check Fins position
    # The "fins" solid is named "fins".
    # We saw Z=5.0.
    
    fins_z = get_transform_z(maker, "fins")
    assert fins_z is not None, "Could not find 'fins' in Maker tree"
    
    # Fins Bottom is simply the Z translation if using corner alignment or if logic dictates
    fins_bottom = fins_z 
    
    print(f"Base Top: {base_top}")
    print(f"Fins Bottom: {fins_bottom}")
    
    # ASSERT THE GAP
    assert np.isclose(base_top, fins_bottom), \
        f"Gap detected! Base Top {base_top} != Fins Bottom {fins_bottom}"

    # 3. Check Fan position
    # Fan(h=14). 
    # Bottom should equal Fins Top.
    # Fins Top is Bottom + Height
    fins_top = fins_bottom + NOCTUA_L9.fins_height
    
    fan_z = get_transform_z(maker, "fan")
    assert fan_z is not None, "Could not find 'fan' in Maker tree"
    
    # Fan Bottom
    # Fan is defined as centered in Z (Fan class uses ad.Box...at("centre")).
    fan_bottom = fan_z - (NOCTUA_L9.fan_height / 2)
    
    assert np.isclose(fins_top, fan_bottom), \
        f"Gap detected! Fins Top {fins_top} != Fan Bottom {fan_bottom}"
