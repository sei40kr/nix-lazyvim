{
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    blink-cmp = {
      url = "github:Saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {
      perSystem =
        {
          self',
          pkgs,
          inputs',
          ...
        }:
        {
          packages.default = pkgs.callPackage ./packages/LazyVim {
            inherit (inputs'.blink-cmp.packages) blink-cmp;
          };

          devShells.default = pkgs.callPackage ./dev-shells/LazyVim { LazyVim = self'.packages.default; };
        };

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
