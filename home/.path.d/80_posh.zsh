#! /usr/bin/zsh

ARCH=$(uname -m)
OS=$(uname -o)

if [[ ! "${OS}" == "Darwin" ]]; then
	if [[ -d "${HOME}/.oh-my-posh" && ! ":${PATH}:" == *:${HOME}/.oh-my-posh:* ]]; then
		# path has not yet been added
		export PATH="${HOME}/.oh-my-posh:${PATH}"
	fi
fi