{
  description = "Keystone Hardware - Modular computer case design";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "ks-hardware";

          packages = with pkgs; [
            # Python 3.13
            python313

            # Package manager
            uv

            # CAD tools
            openscad-unstable

            # Build dependencies for Python packages
            stdenv.cc.cc.lib
            zlib
            libGL
            libGLU
            xorg.libX11
            xorg.libXext
            xorg.libXrender

            # Development tools
            git
          ];

          shellHook = ''
            # Set up library paths for Python native extensions
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc.lib
              pkgs.zlib
              pkgs.libGL
              pkgs.libGLU
              pkgs.xorg.libX11
              pkgs.xorg.libXext
              pkgs.xorg.libXrender
            ]}:$LD_LIBRARY_PATH"

            # Create virtual environment if it doesn't exist
            if [ ! -d .venv ]; then
              echo "Creating virtual environment..."
              uv venv
            fi

            # Sync dependencies
            echo "Syncing dependencies..."
            uv sync --quiet

            # Activate virtual environment
            source .venv/bin/activate

            echo "Keystone Hardware dev shell ready!"
            echo "Run './bin/test' to run tests"
            echo "Run './bin/render' to generate SCAD/STL files"
          '';
        };
      }
    );
}
