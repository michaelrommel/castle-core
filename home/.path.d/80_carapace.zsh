#! /usr/bin/env zsh

if carapace --version >/dev/null 2>&1; then
	export CARAPACE_BRIDGES='zsh,bash'
	export CARAPACE_EXCLUDES='kill'
	zstyle ':completion:*' format $'\e[2;37m%d\e[m'
	zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
	autoload -Uz compinit && compinit
	source <(carapace _carapace)
	# source <(~/.local/share/mise/installs/go/1.24.2/bin/carapace _carapace)
fi
