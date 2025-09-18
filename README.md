# nix-lazyvim

Nix Flake to provide a Nix derivation for [LazyVim](https://github.com/LazyVim/LazyVim).

> [!IMPORTANT]
> LazyVim v15 requires Neovim v0.11.2 or later. As of 2025/09/25, the stable
> Nixpkgs release includes Neovim v0.11.1, which is incompatible with LazyVim v15.
>
> You must use an unstable Nixpkgs channel that provides Neovim v0.11.2+. Here's how
> to override the nixpkgs input:
>
> ```nix
> {
>   inputs = {
>     nixpkgs-unstable.url = "nixpkgs/nixos-unstable";  # or "nixpkgs/master"
>
>     lazyvim = {
>       url = "github:sei40kr/nix-lazyvim";
>       inputs.nixpkgs.follows = "nixpkgs-unstable";
>     };
>   };
> }
> ```
>
> Alternatively, you can override `neovim-unwrapped` specifically:
>
> ```nix
> (inputs.lazyvim.packages.${system}.default.override {
>   inherit (pkgs.unstable) neovim-unwrapped;
> })
> ```

## Get Started

1. Fork and clone [LazyVim/starter](https://github.com/LazyVim/starter) to `~/.config/lazyvim`:

   ```sh
   git clone https://github.com/LazyVim/starter.git ~/.config/lazyvim
   ```

1. Remove the contents of `~/.config/lazyvim/init.lua`.
1. Run LazyVim:

   ```sh
   nix flake run github:sei40kr/nix-lazyvim
   ```

1. Or you can use it from your Nix Flake configuration:

   ```nix
   {
     inputs = {
       nixpkgs.url = "nixpkgs/master";

       lazyvim = {
         url = "github:sei40kr/nix-lazyvim";
         inputs.nixpkgs.follows = "nixpkgs";
       };
     };
   }
   ```

   ```nix
   { lib, inputs, ...}:

   {
     config.environment.systemPackages = [
       inputs.lazyvim.packages.x86_64-linux.default
     ];
   }
   ```

## Differences from Normal LazyVim

- The executable and runtime directories are isolated from Neovim:

  |            | Normal Neovim         | nix-lazyvim              |
  | ---------- | --------------------- | ------------------------ |
  | Executable | `nvim`                | `lazyvim`                |
  | Cache      | `~/.cache/nvim`       | `~/.cache/lazyvim`       |
  | Config     | `~/.config/nvim`      | `~/.config/lazyvim`      |
  | Data       | `~/.local/share/nvim` | `~/.local/share/lazyvim` |
  | State      | `~/.local/state/nvim` | `~/.local/state/lazyvim` |

- All Treesitter language parsers are pre-installed.
  - Because nvim-treesitter requires a C compiler to build language parsers.
- [jsregexp](https://github.com/kmarius/jsregexp) is pre-installed (for [LuaSnip](https://github.com/L3MON4D3/LuaSnip)).
- By same reason, some plugins are pre-installed:
  - [lazy.nvim](https://github.com/folke/lazy.nvim)
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  - [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- You can't update pre-installed Treesitter language parsers and plugins.
  You can only update them by updating Nixpkgs.
- [mason.nvim](https://github.com/williamboman/mason.nvim) won't automatically install external editor tools (such as language servers, debug adapters, etc).
  So you need to install them manually.
- You don't need to bootstrap lazy.nvim.
  - On the other hand, you can't customize the options to setup lazy.nvim.

## Limitations

- If you override nixpkgs in your Flake, you will need to add nixpkgs which
  provides Neovim 0.9 or higher.
