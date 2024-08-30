{
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {
      perSystem = { pkgs, self', ... }: {
        packages.LazyVim = pkgs.callPackage ./packages/LazyVim { };

        devShells.LazyVim = pkgs.callPackage ./dev-shells/LazyVim {
          inherit (self'.packages) LazyVim;
        };
      };

      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    };
}
