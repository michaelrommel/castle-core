# user specific initialization
[[ -f "${HOME}/.preinitialization.sh" ]] && source "${HOME}/.preinitialization.sh"

# history settings
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt extended_history

# use up to search history for lines beginning with the same pattern
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
autoload -Uz complist
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-beginning-search
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-beginning-search
# make Ctrl-K and Ctrl-J act like Up and Down
bindkey -M viins ^K up-line-or-beginning-search
bindkey -M viins ^J down-line-or-beginning-search
bindkey -M vicmd ^K up-line-or-beginning-search
bindkey -M vicmd ^J down-line-or-beginning-search
bindkey -M viins ^U backward-word
bindkey -M viins ^D forward-word

# Change cursor shape for different vi modes.
_fix_cursor() {
	echo -ne '\e[6 q'
}
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
		[[ $1 = 'block' ]]; then
		echo -ne '\e[2 q'
	elif [[ ${KEYMAP} == main ]] ||
		[[ ${KEYMAP} == viins ]] ||
		[[ ${KEYMAP} = '' ]] ||
		[[ $1 = 'beam' ]]; then
		_fix_cursor
	fi
}
zle -N zle-keymap-select
# function zle-line-init() {
#     zle -K viins
#     echo -ne "\e[5 q"
# }
# zle -N zle-line-init
precmd_functions+=(_fix_cursor)

# case insensitive completion - was the only thing I used from oh-my-zsh
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
# shellcheck disable=SC2296
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}" "ma=48;5;4;38;5;255"
# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
# General styling
zstyle ':completion:*:corrections'   format '%F{green}  %d (errors: %e)  %f'
zstyle ':completion:*:descriptions'  format '%F{blue}  %d  %f'
zstyle ':completion:*:messages'      format '%B%F{magenta}  %U%d%u  %f%b'
zstyle ':completion:*:warnings'      format '%B%F{red} %Uno matches found%u %f%b'

# Kill
# shellcheck disable=SC2016
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids menu

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

# start autocompletion
autoload -Uz compinit && compinit

# autosuggestion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_MANUAL_REBIND=true
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=243"
bindkey '^ ' autosuggest-accept
# shellcheck disable=SC1094
source "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# prompt customization
# shellcheck disable=SC2086
[[ -f "${HOME}/.oh-my-posh/posh.json" ]] && eval "$(oh-my-posh init zsh --config ${HOME}/.oh-my-posh/posh.json)"

# my personal initialization script 2nd part
[[ -f "${HOME}/.postinitialization.sh" ]] && source "${HOME}/.postinitialization.sh"
