#! /usr/bin/env zsh

RET=$(carapace --version 2>/dev/null)
if [[ "$?" -eq 0 ]]; then
	export CARAPACE_BRIDGES='zsh,bash'
	zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
	zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
	source <(carapace _carapace)
fi
