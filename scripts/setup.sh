#!/bin/zsh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

symlink() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -sf "$src" "$dst"
  echo "  linked: $dst -> $src"
}

echo "Dotfiles: $DOTFILES_DIR"
echo ""

echo "[shell]"
symlink "$DOTFILES_DIR/shell/.zshrc"  "$HOME/.zshrc"
symlink "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"

echo ""
echo "[ssh]"
symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"

echo ""
echo "[claude]"
symlink "$DOTFILES_DIR/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"
symlink "$DOTFILES_DIR/claude/settings.json"  "$HOME/.claude/settings.json"

echo ""
echo "[vscode]"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
symlink "$DOTFILES_DIR/editor/vscode/setting.json" "$VSCODE_USER_DIR/settings.json"

echo ""
echo "Done."
