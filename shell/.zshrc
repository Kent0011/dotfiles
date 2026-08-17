#### Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#### starship
eval "$(starship init zsh)"

#### autosuggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#### fast syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#### History search with arrow keys #####
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

#### Make word deletion stop at path separators, etc.
WORDCHARS=''

#### Apply hidden sources (ignored by Git; e.g., secrets or machine-specific)
#### It recursively reads all .zsh files in the hidden/
HIDDEN_ALIASES_DIR="$HOME/.config/zsh/hidden"
if [ -d "$HIDDEN_ALIASES_DIR" ]; then
  for f in "$HIDDEN_ALIASES_DIR"/*.zsh(N); do
    if [ -r "$f" ] && [ -f "$f" ]; then
      source "$f"
    fi
  done
fi

## PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

## Command auto-completion
autoload -Uz compinit
compinit

## Alias
alias g="git"
alias gb="git branch"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gp="git pull"

alias c="claude"

alias d="docker"
alias d-c="docker compose"
alias dup="docker compose up"
alias ddown="docker compose down"
alias dps="docker compose ps"
alias dbuild="docker compose build"

alias k="kubectl"
alias tf="terraform"
alias m="make"
alias pubkey="cat ~/.ssh/id_ed25519.pub"
alias a="alias"
