# user specific initialization
[[ -f "${HOME}/.preinitialization.sh" ]] && source "${HOME}/.preinitialization.sh"

# history settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# case insensitive completion - was the only thing I used from oh-my-zsh
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

# start autocompletion
autoload -Uz compinit && compinit

# autosuggestion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_MANUAL_REBIND=true
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=243"
bindkey '^ ' autosuggest-accept
source "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# prompt customization
[[ -f "${HOME}/.oh-my-posh/posh.json" ]] && eval "$(oh-my-posh init zsh --config ${HOME}/.oh-my-posh/posh.json)"

# my personal initialization script 2nd part
[[ -f "${HOME}/.postinitialization.sh" ]] && source "${HOME}/.postinitialization.sh"

