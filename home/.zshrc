# user specific initialization
[[ -f "${HOME}/.preinitialization.sh" ]] && source "${HOME}/.preinitialization.sh"

# case insensitive completion - was the only thing I used from oh-my-zsh
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

# start autocompletion
autoload -Uz compinit && compinit

# my personal initialization script 2nd part
[[ -f "${HOME}/.postinitialization.sh" ]] && source "${HOME}/.postinitialization.sh"

# prompt customization
[[ -f "${HOME}/.posh.json" ]] && eval "$(oh-my-posh init zsh --config ${HOME}/.posh.json)"

