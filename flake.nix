{
  description = "The Steward's Watch website development environment";

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
          packages = [
            pkgs.sbcl
            pkgs.openssl
            pkgs.gh
          ];

          # System libraries needed by Lisp packages (dexador, woo, etc.)
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.openssl
          ];

          shellHook = ''
            echo "The Steward's Watch dev shell"
            echo ""
            echo "Start the app:"
            echo "  sbcl --eval '(ql:quickload :the-steward-website)' \\"
            echo "       --eval '(the-steward-website:start-app :debug t)'"
          '';
        };
      }
    );
}
