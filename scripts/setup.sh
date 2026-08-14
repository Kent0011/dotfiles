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

  ln -sfn "$src" "$dst"
  echo "  linked: $dst -> $src"
}

echo "Dotfiles: $DOTFILES_DIR"
echo ""

echo "[homebrew]"
BREW_PACKAGES=(
  gh
  starship
  zsh-autosuggestions
  zsh-syntax-highlighting
  derailed/k9s/k9s
  awscli
  hashicorp/tap/terraform
)
CASK_PACKAGES=(
  font-jetbrains-mono-nerd-font
  google-cloud-sdk
)
for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "  already installed: $pkg"
  else
    brew install "$pkg"
  fi
done
for pkg in "${CASK_PACKAGES[@]}"; do
  if brew list --cask "$pkg" &>/dev/null; then
    echo "  already installed: $pkg"
  else
    brew install --cask "$pkg"
  fi
done
echo ""

echo "[shell]"
symlink "$DOTFILES_DIR/shell/.zshrc"       "$HOME/.zshrc"
symlink "$DOTFILES_DIR/shell/.bashrc"      "$HOME/.bashrc"
symlink "$DOTFILES_DIR/shell/starship.toml" "$HOME/.config/starship.toml"

echo ""
echo "[git]"
symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

echo ""
echo "[gh]"
symlink "$DOTFILES_DIR/gh/config.yml" "$HOME/.config/gh/config.yml"

echo ""
echo "[vim]"
symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

echo ""
echo "[ssh]"
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
  echo "  generated: $HOME/.ssh/id_ed25519"
else
  echo "  already exists: $HOME/.ssh/id_ed25519.pub"
fi
symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"

echo ""
echo "[claude]"
symlink "$DOTFILES_DIR/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"
symlink "$DOTFILES_DIR/claude/settings.json"  "$HOME/.claude/settings.json"
symlink "$DOTFILES_DIR/claude/skills"         "$HOME/.claude/skills"

echo ""
echo "[codex]"
symlink "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"

if [ -L "$HOME/.codex/skills" ]; then
  rm "$HOME/.codex/skills"
fi
mkdir -p "$HOME/.codex/skills"
for skill in "$DOTFILES_DIR/claude/skills"/*/; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  dst="$HOME/.codex/skills/$name"
  rm -rf "$dst"
  cp -R "$skill" "$dst"
  echo "  copied: $dst <- $skill"
done

echo ""
echo "[vscode]"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
symlink "$DOTFILES_DIR/editor/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"

echo ""
echo "[zed]"
ZED_DIR="$HOME/.config/zed"
symlink "$DOTFILES_DIR/editor/zed/settings.json" "$ZED_DIR/settings.json"
symlink "$DOTFILES_DIR/editor/zed/keymap.json"   "$ZED_DIR/keymap.json"
symlink "$DOTFILES_DIR/editor/zed/tasks.json"    "$ZED_DIR/tasks.json"
symlink "$DOTFILES_DIR/editor/zed/themes/nagi-dark.json" "$ZED_DIR/themes/nagi-dark.json"

echo ""
echo "[ghostty]"
symlink "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

echo ""
echo "Done."
