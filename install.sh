#!/bin/bash
set -eu

cd "$(dirname "$0")"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is required (brew install stow | sudo apt install stow)" >&2
  exit 1
fi

echo "Updating submodules..."
git submodule update --init --recursive

mkdir -p "$HOME/.config" "$HOME/.tmux"

# Clean legacy links pointing to this repo to avoid stow conflicts
legacy_targets=(
  "$HOME/.tmux.conf"
  "$HOME/.tmux"
  "$HOME/.config/kitty/kitty.conf"
  "$HOME/.config/nvim"
  "$HOME/.config/ghostty"
)
for target in "${legacy_targets[@]}"; do
  if [ -L "$target" ]; then
    link_target=$(readlink "$target")
    case "$link_target" in
      "$PWD"/*)
        echo "Removing legacy link $target -> $link_target"
        rm "$target"
        ;;
    esac
  fi
done

echo "Stowing configs..."
stow -t "$HOME/.config" -R .config
stow -t "$HOME" -R tmux-config
stow -t "$HOME/.tmux" -R .tmux

echo "Done!"

