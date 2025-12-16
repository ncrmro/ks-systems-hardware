# AnchorSCAD keystone package
import anchorscad
from typing import Dict, Callable, Type, Union

# Simple Registry
_PART_REGISTRY: Dict[str, Callable[[], anchorscad.Shape]] = {}

def register_part(name: str):
    """Decorator to register a part for rendering."""
    def decorator(cls_or_func):
        _PART_REGISTRY[name] = cls_or_func
        return cls_or_func
    return decorator

def get_registry():
    return _PART_REGISTRY