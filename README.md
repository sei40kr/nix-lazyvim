# nix-lazyvim

Nix Flake to provide a Nix derivation for [LazyVim](https://github.com/LazyVim/LazyVim).

It wraps Neovim with LazyVim dependencies and a few configurations. It also
isolates the LazyVim configurations and environments from normal Neovim.

- `~/.cache/nvim` -> `~/.cache/lazyvim`
- `~/.config/nvim` -> `~/.config/lazyvim`
- `~/.local/share/nvim` -> `~/.local/share/lazyvim`
- `~/.local/state/nvim` -> `~/.local/state/lazyvim`

## Limitations

- If you override nixpkgs in your Flake, you will need to add nixpkgs which
  provides Neovim 0.9 or higher.
