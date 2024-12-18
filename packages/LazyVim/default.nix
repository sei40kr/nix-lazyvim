{
  lib,
  fd,
  fzf,
  neovim-unwrapped,
  nodejs,
  python3,
  ripgrep,
  runCommandLocal,
  vimPlugins,
  wrapNeovimUnstable,
}:

let
  luaEnv = neovim-unwrapped.lua.withPackages (
    ps: with ps; [
      # For LuaSnip
      jsregexp
    ]
  );
  neovimConfigured = wrapNeovimUnstable neovim-unwrapped {
    extraName = "-LazyVim";
    wrapperArgs =
      [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath [
          # For fzf-lua
          fzf
          # For fzf-lua & telescope.nvim
          fd
          ripgrep
        ])
      ]
      ++ [
        "--prefix"
        "LUA_PATH"
        ";"
        (neovim-unwrapped.lua.pkgs.luaLib.genLuaPathAbsStr luaEnv)
      ]
      ++ [
        "--prefix"
        "LUA_CPATH"
        ";"
        (neovim-unwrapped.lua.pkgs.luaLib.genLuaCPathAbsStr luaEnv)
      ]
      ++ [
        "--set"
        "NVIM_APPNAME"
        "lazyvim"
      ];
    luaRcContent = ''
      vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/nvim-treesitter/parsers")

      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          {
            "copilot.lua",
            opts = {
              copilot_node_command = "${nodejs}/bin/node",
            },
            optional = true,
          },
          {
            "mason.nvim",
            opts_extend = {},
            opts = {
              ensure_installed = {},
            },
          },
          {
            "LuaSnip",
            build = "",
            optional = true,
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
    plugins = [
      {
        plugin = vimPlugins.lazy-nvim;
        optional = false;
      }
      {
        plugin = vimPlugins.nvim-treesitter.withAllGrammars;
        optional = false;
      }
    ];
  };
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
  }
  ''
    install -Dm755 ${neovimConfigured}/bin/nvim $out/bin/lazyvim
  ''
