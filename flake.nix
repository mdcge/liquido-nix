{
  description = "ratpac-two";

  inputs = {
    nixpkgs    .url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.liquido-ratpac = pkgs.callPackage ./packages/liquido-ratpac.nix {};
        packages.default = self.packages.${system}.liquido-ratpac;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.liquido-ratpac ];
          packages = [ self.packages.${system}.liquido-ratpac ];
        };
      });
}
