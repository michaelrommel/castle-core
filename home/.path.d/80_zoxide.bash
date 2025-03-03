#! /usr/bin/env zsh

RET=$(zoxide --version 2>/dev/null)
if [[ "$?" -eq 0 ]]; then
	eval "$(zoxide init bash)"
fi
