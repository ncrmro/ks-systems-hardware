"""Part registration system for AnchorSCAD shapes."""

import anchorscad as ad
import inspect
import re
from typing import Dict, Callable, List

# Simple Registry — stores (factory, part_type) tuples
_PART_REGISTRY: Dict[str, tuple[Callable, str]] = {}


def register_part(name: str, part_type: str = "component"):
    """Decorator to register a part factory with its type."""

    def decorator(cls_or_func):
        _PART_REGISTRY[name] = (cls_or_func, part_type)
        return cls_or_func

    return decorator


def get_registry():
    return _PART_REGISTRY


def camel_to_snake(name):
    name = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", name).lower()


def auto_register_module(module, part_type: str = "component"):
    """
    Scans a module for Shape classes and registers them if they have defaults.
    """
    for name, obj in inspect.getmembers(module):
        if (
            inspect.isclass(obj)
            and issubclass(obj, ad.Shape)
            and obj is not ad.Shape
            and obj is not ad.CompositeShape
        ):
            # Only register classes defined in this module
            if obj.__module__ != module.__name__:
                continue

            # Generate candidate name
            part_name = camel_to_snake(name)

            # Check if we can instantiate it (no required args)
            try:
                sig = inspect.signature(obj)
                required_args = [
                    p.name
                    for p in sig.parameters.values()
                    if p.default == inspect.Parameter.empty and p.name != "self"
                ]

                if not required_args:
                    if part_name not in _PART_REGISTRY:
                        _PART_REGISTRY[part_name] = (lambda cls=obj: cls(), part_type)
            except Exception:
                pass


def list_parts() -> List[dict]:
    """Return JSON-serializable list with type from registry."""
    registry = get_registry()
    return [
        {"name": name, "type": ptype, "stl": True}
        for name, (factory, ptype) in sorted(registry.items())
    ]
