import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'src'))

try:
    from parts.pico import create_pico_base_panel
    print("Import successful")
    shape = create_pico_base_panel()
    print("Shape creation successful")
except ImportError as e:
    print(f"ImportError: {e}")
except Exception as e:
    print(f"Error: {e}")
