{
  inputs = {
    nixpkgs.url = "nixpkgs/release-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {
      perSystem =
        { pkgs, self', ... }:
        {
          packages.default = pkgs.callPackage ./packages/LazyVim { };

          devShells.default = pkgs.callPackage ./dev-shells/LazyVim { LazyVim = self'.packages.default; };
        };

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
