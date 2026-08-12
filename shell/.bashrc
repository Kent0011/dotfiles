#### Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

#### starship
eval "$(starship init bash)"

## PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH="/opt/homebrew/opt/php@8.4/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/s33785/google-cloud-sdk/path.bash.inc' ]; then . '/Users/s33785/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/s33785/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/s33785/google-cloud-sdk/completion.bash.inc'; fi

eval "$(nodenv init -)"
export PATH="$HOME/go/bin:$PATH"

## kubectl completion
source <(kubectl completion bash)
