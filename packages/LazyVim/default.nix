{ lib
, fd
, neovim-unwrapped
, neovimUtils
, python3
, ripgrep
, runCommandLocal
, vimPlugins
, wrapNeovimUnstable
}:

let
  neovimConfigured = wrapNeovimUnstable neovim-unwrapped (neovimUtils.makeNeovimConfig {
    extraMakeWrapperArgs = lib.escapeShellArgs [
      "--set"
      "NVIM_APPNAME"
      "lazyvim"
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        # For telescope.nvim
        fd
        ripgrep
      ])
    ];
    plugins = [ vimPlugins.lazy-nvim ] ++ vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    customRC = ''
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          {
            "mason.nvim",
            opts_extend = {},
            opts = {
              ensure_installed = {},
            },
          },
          {
            dir = "${vimPlugins.nvim-treesitter.withAllGrammars.outPath}",
            name = "nvim-treesitter",
            opts_extend = {},
            opts = {
              ensure_installed = {},
              parser_install_dir = vim.fn.stdpath("data") .. "/nvim-treesitter/parsers",
            },
            pin = true,
            optional = true,
          },
          {
            dir = "${vimPlugins.telescope-fzf-native-nvim.outPath}",
            name = "telescope-fzf-native.nvim",
            pin = true,
            optional = true,
          },
          { import = "plugins" },
        },
        performance = {
          reset_packpath = false,
          rtp = {
            reset = false,
            disabled_plugins = {
              "gzip",
              -- "matchit",
              -- "matchparen",
              -- "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';
    extraName = "-LazyVim";
  });
in
runCommandLocal "LazyVim"
{
  buildInputs = [
    neovimConfigured
    fd
    ripgrep
  ];

  meta = with lib; {
    description = "Neovim config for the lazy";
    homepage = "https://lazyvim.org";
    license = licenses.apsl20;
    platforms = platforms.all;
    mainProgram = "lazyvim";
  };
} ''
  install -Dm755 ${neovimConfigured}/bin/nvim $out/bin/lazyvim
''
