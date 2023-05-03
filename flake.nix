{
  inputs = {
    nixpkgs.url = "nixpkgs/master";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) genAttrs;
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      pkgs' = genAttrs systems (system: import nixpkgs { inherit system; });
    in
    {
      packages = genAttrs systems (system:
        let pkgs = pkgs'.${system};
        in
        rec {
          LazyVim = pkgs.callPackage ./packages/LazyVim { };
        });
    };
}
