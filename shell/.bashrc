#### Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#### starship
eval "$(starship init bash)"

#### Make word deletion stop at path separators, etc.
WORDCHARS=''

#### Apply hidden sources (ignored by Git; e.g., secrets or machine-specific)
HIDDEN_ALIASES_DIR="$HOME/.config/zsh/hidden"
if [ -d "$HIDDEN_ALIASES_DIR" ]; then
  for f in "$HIDDEN_ALIASES_DIR"/*.zsh; do
    [ -r "$f" ] && [ -f "$f" ] && source "$f"
  done
fi

## PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
