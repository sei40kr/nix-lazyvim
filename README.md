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

## 🆚 Differences from Standard LazyVim

This Nix package differs from a standard LazyVim installation in several key ways:

### 🗂️ Isolated Runtime Directories

To avoid conflicts with existing Neovim installations, all runtime directories are isolated:

| Directory Type | Standard Neovim       | nix-lazyvim              |
| -------------- | --------------------- | ------------------------ |
| **Executable** | `nvim`                | `lazyvim`                |
| **Cache**      | `~/.cache/nvim`       | `~/.cache/lazyvim`       |
| **Config**     | `~/.config/nvim`      | `~/.config/lazyvim`      |
| **Data**       | `~/.local/share/nvim` | `~/.local/share/lazyvim` |
| **State**      | `~/.local/state/nvim` | `~/.local/state/lazyvim` |

### 🔧 Pre-installed Components

Several components are pre-installed to ensure a smooth experience without requiring build tools:

- **All Tree-sitter language parsers** - Installed upfront since building them requires a C compiler
- **Essential plugins** - Pre-built to avoid compilation during setup:
  - [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax parsing
  - [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) - Fast fuzzy finder
- **jsregexp** - Required for [LuaSnip](https://github.com/L3MON4D3/LuaSnip) snippet engine

### ⚡ Update Limitations

- **Pre-installed components** (Tree-sitter parsers, core plugins) can only be updated by updating your Nixpkgs channel
- **No automatic updates** via `:Lazy update` for these components

### 🪨 Luarocks Support

Luarocks integration is disabled by default.
While none of the plugins installed by LazyVim require Luarocks for dependency resolution, some plugins include rockspec files that would cause lazy.nvim to search for Luarocks during installation.
This would result in build failures when Luarocks is not found, so we've disabled it to ensure a smooth installation experience.

### 🛠️ Mason.nvim Behavior

- **No automatic tool installation** - [mason.nvim](https://github.com/williamboman/mason.nvim) won't install language servers, debug adapters, or other external tools automatically
- **Manual installation required** - You'll need to install these tools through your system package manager or Nix configuration

### 🚀 Setup Differences

- **No bootstrap required** - `lazy.nvim` is already set up and ready to use
- **Limited customization** - Some `lazy.nvim` setup options cannot be customized since the plugin manager is pre-configured

## Limitations

- If you override nixpkgs in your Flake, you will need to add nixpkgs which
  provides Neovim 0.9 or higher.
