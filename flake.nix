{
  description = "Keystone Hardware - Modular computer case design";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cadeng.url = "github:ncrmro/cadeng";

    lfs-s3-src = {
      url = "github:nicolas-graves/lfs-s3/0.2.1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, cadeng, lfs-s3-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lfs-s3 = pkgs.buildGoModule {
          pname = "lfs-s3";
          version = "0.2.1";
          src = lfs-s3-src;
          vendorHash = "sha256-CRHfPj5gQ54WA+2LjkLIHta7br03TZ4svfkbcezfUOE=";
          meta.mainProgram = "lfs-s3";
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "ks-hardware";

          packages = [
            # CADeng server (compiled binary, provides `cadeng` CLI)
            cadeng.packages.${system}.default

            # Python 3.13
            pkgs.python313

            # Package manager
            pkgs.uv

            # CAD tools (wrapped openscad with EGL headless support)
            cadeng.packages.${system}.openscad

            # Build dependencies for Python packages
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
            pkgs.libGL
            pkgs.libGLU
            pkgs.xorg.libX11
            pkgs.xorg.libXext
            pkgs.xorg.libXrender

            # Development tools
            pkgs.git
            pkgs.git-lfs
            lfs-s3
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
            echo "Run 'cadeng' to start the gallery server"
          '';
        };
      }
    );
}
