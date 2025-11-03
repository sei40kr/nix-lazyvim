{
  inputs = {
    nixpkgs.url = "nixpkgs/release-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-parts,
      nixpkgs,
      nvim-treesitter-main,
      ...
    }@inputs:
    let
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {
      perSystem =
        {
          pkgs,
          self',
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [ nvim-treesitter-main.overlays.default ];
          };

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
