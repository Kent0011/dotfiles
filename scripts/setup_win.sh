#!/bin/zsh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
WIN_HOME="/mnt/c/Users/$WIN_USER"

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

copy_to_win() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  elif [ -L "$dst" ]; then
    rm "$dst"
  fi

  cp "$src" "$dst"
  echo "  copied: $dst <- $src"
}

echo "Dotfiles: $DOTFILES_DIR"
echo "Windows Home: $WIN_HOME"
echo ""

echo "[apt]"
sudo apt install -y unzip curl build-essential procps file git zsh
echo ""

echo "[default-shell]"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
  echo "  changing default shell to zsh..."
  sudo chsh -s "$(command -v zsh)" "$USER"
  echo "  done. Restart WSL to take effect."
else
  echo "  already zsh"
fi
echo ""

echo "[homebrew]"
if ! command -v brew &>/dev/null; then
  echo "  installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -d /home/linuxbrew/.linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

BREW_PACKAGES=(
  gh
  lazygit
  starship
  zsh-autosuggestions
  zsh-syntax-highlighting
)
for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "  already installed: $pkg"
  else
    brew install "$pkg"
  fi
done
echo ""

echo "[font]"
FONT_TMP=$(mktemp -d)
FONT_VERSION="3.4.0"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/JetBrainsMono.zip"
echo "  downloading JetBrains Mono Nerd Font v${FONT_VERSION}..."
curl -fsSL "$FONT_URL" -o "$FONT_TMP/JetBrainsMono.zip"
unzip -q "$FONT_TMP/JetBrainsMono.zip" -d "$FONT_TMP/fonts"
WIN_FONTS_DIR="$WIN_HOME/AppData/Local/Microsoft/Windows/Fonts"
mkdir -p "$WIN_FONTS_DIR"
cp "$FONT_TMP/fonts"/*.ttf "$WIN_FONTS_DIR/" 2>/dev/null || true
rm -rf "$FONT_TMP"
echo "  copied to $WIN_FONTS_DIR"
echo "  Note: open $WIN_FONTS_DIR in Explorer and install fonts if not auto-registered"
echo ""

echo "[shell]"
symlink "$DOTFILES_DIR/shell/.zshrc"        "$HOME/.zshrc"
symlink "$DOTFILES_DIR/shell/.bashrc"       "$HOME/.bashrc"
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
symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"

echo ""
echo "[claude]"
symlink "$DOTFILES_DIR/claude/CLAUDE.md"    "$HOME/.claude/CLAUDE.md"
symlink "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
symlink "$DOTFILES_DIR/claude/skills"        "$HOME/.claude/skills"

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
VSCODE_USER_DIR="$WIN_HOME/AppData/Roaming/Code/User"
copy_to_win "$DOTFILES_DIR/editor/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"

echo ""
echo "[zed]"
ZED_DIR="$WIN_HOME/AppData/Roaming/Zed"
copy_to_win "$DOTFILES_DIR/editor/zed/settings.json" "$ZED_DIR/settings.json"
copy_to_win "$DOTFILES_DIR/editor/zed/keymap.json"   "$ZED_DIR/keymap.json"
copy_to_win "$DOTFILES_DIR/editor/zed/tasks.json"    "$ZED_DIR/tasks.json"
copy_to_win "$DOTFILES_DIR/editor/zed/themes/nagi-dark.json" "$ZED_DIR/themes/nagi-dark.json"

echo ""
echo "[ghostty]"
GHOSTTY_DIR="$WIN_HOME/AppData/Roaming/com.mitchellh.ghostty"
copy_to_win "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_DIR/config"

echo ""
echo "Done."
