# nix-lazyvim

Nix Flake to provide a Nix derivation for [LazyVim](https://github.com/LazyVim/LazyVim).

It wraps Neovim with LazyVim dependencies and a few configurations. It also
isolates the LazyVim configurations and environments from normal Neovim.

- `~/.cache/nvim` -> `~/.cache/lazyvim`
- `~/.config/nvim` -> `~/.config/lazyvim`
- `~/.local/share/nvim` -> `~/.local/share/lazyvim`
- `~/.local/state/nvim` -> `~/.local/state/lazyvim`

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

## Limitations

- If you override nixpkgs in your Flake, you will need to add nixpkgs which
  provides Neovim 0.9 or higher.
