#!/bin/bash
set -eu

cd "$(dirname "$0")"

echo "Updating submodules..."
git submodule update --init --recursive

echo "Symlinking configs..."
mkdir -p "$HOME/.config" "$HOME/.tmux"
ln -sf "$PWD/.config/nvim" "$HOME/.config/nvim"
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/.tmux" "$HOME/.tmux"
ln -sf "$PWD/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

echo "Done!"
