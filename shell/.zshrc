#### Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

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
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH="/opt/homebrew/opt/php@8.4/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

## Command auto-completion
autoload -Uz compinit
compinit

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/s33785/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/s33785/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/s33785/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/s33785/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(nodenv init -)"
export PATH="$HOME/go/bin:$PATH"

## Alias
alias g="git"
alias gb="git branch"
alias c="claude"
alias d="docker"
alias k="kubectl"
