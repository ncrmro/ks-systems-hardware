# AnchorSCAD keystone package
import anchorscad as ad
import inspect
import re
from typing import Dict, Callable, Type, Union

# Simple Registry
_PART_REGISTRY: Dict[str, Callable[[], ad.Shape]] = {}

def register_part(name: str):
    """Decorator to register a part for rendering."""
    def decorator(cls_or_func):
        _PART_REGISTRY[name] = cls_or_func
        return cls_or_func
    return decorator

def get_registry():
    return _PART_REGISTRY

def camel_to_snake(name):
    name = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', name).lower()

def auto_register_module(module, prefix: str = ""):
    """
    Scans a module for Shape classes and registers them if they have defaults.
    """
    for name, obj in inspect.getmembers(module):
        if inspect.isclass(obj) and issubclass(obj, ad.Shape) and obj is not ad.Shape and obj is not ad.CompositeShape:
            # Check if it's already registered (by name or object equality logic?)
            # We don't have reverse lookup easily.
            
            # Generate candidate name
            part_name = prefix + camel_to_snake(name)
            
            # Check if we can instantiate it
            try:
                # Inspect __init__ to see if arguments are required?
                # anchorscad datatree classes usually have __init__ generated.
                # If fields have defaults, it's fine.
                # Let's try to instantiate it.
                # Warning: This instantiates the object which might be heavy?
                # Usually Shape instantiation is lightweight (just data), build() is heavy.
                
                # Check for required arguments without defaults
                sig = inspect.signature(obj)
                required_args = [
                    p.name for p in sig.parameters.values() 
                    if p.default == inspect.Parameter.empty and p.name != 'self'
                ]
                
                if not required_args:
                    # Register a factory
                    if part_name not in _PART_REGISTRY:
                        # We capture 'obj' in the closure
                        _PART_REGISTRY[part_name] = lambda cls=obj: cls()
                        # print(f"Auto-registered: {part_name}")
            except Exception as e:
                pass
