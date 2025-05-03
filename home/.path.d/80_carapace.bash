#! /usr/bin/env zsh

RET=$(carapace --version 2>/dev/null)
if [[ "$?" -eq 0 ]]; then
	export CARAPACE_BRIDGES='zsh,bas'
	source <(carapace _carapace)
fi
