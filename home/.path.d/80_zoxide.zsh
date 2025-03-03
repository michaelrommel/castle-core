#! /usr/bin/env zsh

RET=$(zoxide --version 2>/dev/null)
if [[ "$?" -ne 0 ]]; then
	exit 0
fi

eval "$(zoxide init zsh)"
