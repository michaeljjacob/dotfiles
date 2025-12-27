# Dotfiles

Personal configuration files for Neovim and tmux, designed for easy setup across macOS and Linux.

## Managed dotfiles
- `~/.config/nvim/` (Neovim config)
- `~/.config/kitty/kitty.conf` (kitty terminal config)
- `~/.config/ghostty/config` (Ghostty terminal config)
- `~/.tmux.conf` (tmux config)
- `~/.tmux/` (tmux plugins and extra modules)
- `~/tmux/init/*.sh` (tmux session bootstrap scripts)

## Development tmux initialization

Custom tmux session setups live in `tmux-config/tmux/init/`.
For example, launch the workspace via `~/tmux/lucidity.sh` after stowing, or run it directly from `tmux-config/tmux/init/`.

## Setup

Install GNU Stow first (macOS: `brew install stow`; Debian/Ubuntu: `sudo apt install stow`).

From the repo root:
```bash
./install.sh
```
This updates git submodules, cleans legacy links pointing at this repo, and restows the managed packages into your home directory.

Manual stow, if you prefer:
```bash
stow -t "$HOME/.config" -R .config
stow -t "$HOME" -R tmux-config
stow -t "$HOME/.tmux" -R .tmux
```
Use `stow -n` for a dry run before applying; remove any legacy links in `$HOME` if you see conflicts.

## OS compatibility
These dotfiles are compatible with Linux and macOS; OS-specific config is detected inside the config files as needed.
