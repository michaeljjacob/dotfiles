# Dotfiles

Personal configuration files for Neovim and tmux, designed for easy setup across macOS and Linux.

## Managed dotfiles
- `~/.config/nvim/` (Neovim config)
- `~/.tmux.conf` (tmux config)
- `~/.tmux/` (tmux plugins and extra modules)
- `~/.config/kitty/kitty.conf` (kitty terminal config)

## Setup

The fastest way: run the provided setup script after cloning:
```bash
./install.sh
```

This will automatically update git submodules and symlink all configs to your home directory.

---

Manual method: Clone this repo, then symlink the managed files to your home directory:
Clone this repo, then symlink the managed files to your home directory:
```bash
ln -sf "$PWD/.config/nvim" "$HOME/.config/nvim"
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/.tmux" "$HOME/.tmux"
ln -sf "$PWD/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
```

Or use stow/chezmoi/yadm for automation, if preferred.

## OS compatibility
These dotfiles are compatible with Linux and macOS; OS-specific config is detected inside the config files as needed.
