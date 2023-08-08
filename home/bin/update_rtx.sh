#!/bin/bash

get_os() {
	os="$(uname -s)"
	if [ "$os" = Darwin ]; then
		echo "macos"
	elif [ "$os" = Linux ]; then
		echo "linux"
	else
		error "unsupported OS: $os"
	fi
}

get_arch() {
	arch="$(uname -m)"
	if [ "$arch" = x86_64 ]; then
		echo "x64"
	elif [ "$arch" = aarch64 ] || [ "$arch" = arm64 ]; then
		echo "arm64"
	else
		error "unsupported architecture: $arch"
	fi
}

# https://github.com/jdxcode/rtx/releases/download/v1.35.8/rtx-v1.35.8-linux-x64
update_rtx() {
	echo "Updating rtx..."
	os="$(get_os)"
	if [[ "${os}" == "macos" ]]; then
		brew install rtx
	else
		arch="$(get_arch)"
		mkdir -p "${HOME}/bin"
		if ! curl -sL "https://rtx.pub/rtx-latest-${os}-${arch}" >"${HOME}/bin/rtx"; then
			echo "First download failed."
			latest=$(curl -s https://api.github.com/repos/jdxcode/rtx/tags | jq -r ".[0].name")
			echo "Latest release seems to be: ${latest}"
			if ! curl -sL "https://github.com/jdxcode/rtx/releases/download/${latest}/rtx-${latest}-${os}-${arch}" >"${HOME}/bin/rtx"; then
				echo "Second download failed, too. Aborting."
				exit 1
			fi
		fi
		chmod 755 "${HOME}/bin/rtx"
	fi
	echo "done."
}

update_rtx
