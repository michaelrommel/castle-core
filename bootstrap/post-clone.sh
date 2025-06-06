#! /usr/bin/env bash

source "${HOME}/.homesick/helper.sh"

get_os() {
	os="$(uname -s)"
	if [ "$os" = Darwin ]; then
		echo "apple-darwin"
	elif [ "$os" = Linux ]; then
		echo "unknown-linux-musl"
	else
		error "unsupported OS: $os"
	fi
}

get_arch() {
	arch="$(uname -m)"
	if [ "$arch" = x86_64 ]; then
		echo "x86_64"
	elif [ "$arch" = aarch64 ] || [ "$arch" = arm64 ]; then
		echo "aarch64"
	else
		error "unsupported architecture: $arch"
	fi
}

echo "Installing basic packages"
if is_mac; then
	desired=(mosh keychain ncurses gawk autoconf automake pkg-config coreutils imagemagick yazi carapace)
	missing=()
	check_brewed "missing" "${desired[@]}"
	if [[ "${#missing[@]}" -gt 0 ]]; then
		echo "(brew) installing ${missing[*]}"
		brew install "${missing[@]}"
	fi
else
	desired=(curl git vim mosh keychain zsh ncurses-bin apt-file
		unzip sysstat net-tools dnsutils bc gawk universal-ctags
		software-properties-common socat)
	missing=()
	check_dpkged "missing" "${desired[@]}"
	if [[ "${#missing[@]}" -gt 0 ]]; then
		echo "(apt) installing ${missing[*]}"
		sudo apt-get -y update
		sudo apt-get -y install "${missing[@]}"
	fi
fi

if [[ ! -d "${HOME}/.oh-my-posh" ]]; then
	echo "Installing oh-my-posh for zsh"
	mkdir -p "${HOME}/.cache"
	mkdir -p "${HOME}/.oh-my-posh"
	export PATH="${HOME}/.oh-my-posh:${PATH}"
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "${HOME}/.oh-my-posh"
fi

if [[ ! -d "${HOME}/.zsh/zsh-autosuggestions" ]]; then
	mkdir -p "${HOME}/.zsh"
	git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/zsh-autosuggestions"
fi

if ! is_mac; then
	# column oriented file manager
	if [[ ! -d "${HOME}/.yazi" ]]; then
		echo "Installing yazi"
		arch="$(get_arch)"
		mkdir -p "${HOME}/bin"
		mkdir -p "${HOME}/.yazi"
		latest=$(curl -s https://api.github.com/repositories/663900193/tags | jq -r ".[0].name")
		echo "Latest release seems to be: ${latest}"
		TMPDIR=$(mktemp -d /tmp/yazi.XXXXXX) || exit 1
		if ! curl -sL "https://github.com/sxyazi/yazi/releases/download/${latest}/yazi-${arch}-unknown-linux-gnu.zip" -o "${TMPDIR}/yazi.zip"; then
			echo "Download of yazi failed. Aborting."
			exit 1
		fi
		cd "${TMPDIR}" || exit
		unzip yazi.zip
		cd "yazi-${arch}-unknown-linux-gnu" || exit
		cp yazi "${HOME}/bin/yazi"
		chmod 755 "${HOME}/bin/yazi"
		cp completions/{ya,yazi}.bash "${HOME}/.yazi/"
		rm -rf "${TMPDIR}"
		echo "done."
	fi
	# smarter "cd"
	if [[ ! -f "${HOME}/bin/zoxide" ]]; then
		echo "Installing zoxide..."
		arch="$(get_arch)"
		mkdir -p "${HOME}/bin"
		latest=$(curl -s https://api.github.com/repositories/245166720/tags | jq -r ".[0].name")
		echo "Latest release seems to be: ${latest}"
		TMPDIR=$(mktemp -d /tmp/zoxide.XXXXXX) || exit 1
		if ! curl -sL "https://github.com/ajeetdsouza/zoxide/releases/download/${latest}/zoxide-${latest#v}-${arch}-unknown-linux-musl.tar.gz" -o "${TMPDIR}/zoxide.tar.gz"; then
			echo "Download failed. Aborting."
			exit 1
		fi
		cd "${TMPDIR}" || exit
		tar xf zoxide.tar.gz
		cp zoxide "${HOME}/bin/zoxide"
		chmod 755 "${HOME}/bin/zoxide"
		rm -rf "${TMPDIR}"
		echo "done."
	fi
	# smarter "cd"
	if [[ ! -f "${HOME}/bin/carapace" ]]; then
		echo "Installing carapace..."
		arch="$(get_arch)"
		if [[ "$arch" == "x86_64" ]]; then
			arch="amd64"
		fi
		mkdir -p "${HOME}/bin"
		latest=$(curl -s https://api.github.com/repositories/257400448/tags | jq -r ".[0].name")
		echo "Latest release seems to be: ${latest}"
		TMPDIR=$(mktemp -d /tmp/carapace.XXXXXX) || exit 1
		if ! curl -sL "https://github.com/carapace-sh/carapace-bin/releases/download/${latest}/carapace-bin_${latest#v}_linux_${arch}.tar.gz" -o "${TMPDIR}/carapace.tar.gz"; then
			echo "Download failed. Aborting."
			exit 1
		fi
		cd "${TMPDIR}" || exit
		tar xf carapace.tar.gz
		cp carapace "${HOME}/bin/carapace"
		chmod 755 "${HOME}/bin/carapace"
		rm -rf "${TMPDIR}"
		echo "done."
	fi
fi

cd "${HOME}" || exit
touch .hushlogin

if is_wsl; then
	# compile the npiperelay program if it is not already existing
	NPR=/mnt/c/ProgramFiles/npiperelay/npiperelay.exe
	if [[ ! -f "${NPR}" ]]; then
		# -d says not to install the poackage
		go get -d github.com/jstarks/npiperelay
		GOOS=windows go build -o ${NPR} github.com/jstarks/npiperelay
	fi
fi

GIT_VERSION=$(git --version | sed -e 's/git version \([0-9]*\.[0-9]*\)\..*/\1/')
#if (($(echo "${GIT_VERSION} < 2.26" | bc -l))); then
if ! satisfied "2.26" "${GIT_VERSION}"; then
	if ! is_mac; then
		source /etc/os-release
		if [[ ${VERSION_CODENAME} == "buster" ]]; then
			echo "Adding buster backports"
			echo "deb http://deb.debian.org/debian buster-backports main" |
				sudo tee /etc/apt/sources.list.d/buster-backports.list
			sudo apt update
			sudo apt install -y -t buster-backports git
		else
			echo "git is outdated, you should build git from source"
			# cd "${HOME}" || exit
			# mkdir -p "${HOME}/software"; cd "${HOME}/software" || exit
			# git clone git://git.kernel.org/pub/scm/git/git.git
			# sudo apt remove -y git
			# cd git || exit
			# make configure
			# ./configure --prefix=/usr
			# make all info
			# sudo make install install-info
		fi
	fi
fi

cd "${HOME}" || exit
if ! is_mac; then
	MYSH=$(getent passwd "${LOGNAME}" | cut -d: -f7)
	if [[ ! $MYSH =~ "zsh" ]]; then
		sudo chsh -s /usr/bin/zsh "${LOGNAME}"
	fi
fi
