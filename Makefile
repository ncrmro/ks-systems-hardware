.PHONY: cad test render help

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  cad     Start cadeng gallery server"
	@echo "  test    Run tests"
	@echo "  render  Generate SCAD/STL files"

# Start cadeng gallery server
cad:
	nix develop --command cadeng

# Run tests
test:
	nix develop --command ./bin/test

# Generate SCAD/STL files
render:
	nix develop --command ./bin/render
