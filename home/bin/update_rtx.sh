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

update_rtx() {
	echo "Updating rtx..."
	os="$(get_os)"
	if [[ "${os}" == "macos" ]]; then
		brew install rtx
		RTX=rtx
	else
		arch="$(get_arch)"
		mkdir -p "${HOME}/bin"
		curl -sL "https://rtx.pub/rtx-latest-${os}-${arch}" >"${HOME}/bin/rtx"
		chmod 755 "${HOME}/bin/rtx"
		RTX="${HOME}/bin/rtx"
	fi
	echo "done."
}

update_rtx
