{ callPackage
, curl
, fd
, fetchFromGitHub
, git
, gnutar
, gzip
, lazygit
, lib
, makeWrapper
, neovim
, ripgrep
, runCommand
, stdenv
, unzip
, vimPlugins
, wget
}:

let
  neovim_configured = neovim.override {
    configure = {
      customRC = ''
        lua <<EOF
          require("config.lazy")
        EOF
      '';
      packages.myVimPackage.start = [
        vimPlugins.lazy-nvim
        # nvim-treesitter builds & installs grammars and this works poorly on
        # NixOS. So we include all grammars in the package.
        # FIXME: LazyVim cannot find the grammars
        vimPlugins.nvim-treesitter.withAllGrammars
      ];
    };
  };
in
runCommand "lazyvim"
{
  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    neovim_configured
    git
    lazygit
    # mason.nvim
    curl
    gzip
    gnutar
    unzip
    wget
    # telescope.nvim
    fd
    ripgrep
  ];

  meta = with lib; {
    description = "Neovim config for the lazy";
    homepage = "https://github.com/LazyVim/LazyVim";
    platforms = platforms.linux;
  };
} ''
  makeWrapper ${neovim_configured}/bin/nvim $out/bin/lazyvim \
              --set NVIM_APPNAME lazyvim \
              --prefix PATH : ${lib.makeBinPath [ git lazygit curl gzip gnutar unzip wget fd ripgrep ]}
''
