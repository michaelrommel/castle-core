#! /bin/bash

echo "Installing apt packages"
sudo apt-get -y update
sudo apt-get -y install bison byacc curl git vim \
	mosh keychain neofetch zsh ncurses-bin gdebi-core apt-file \
	unzip sysstat net-tools dnsutils \
	universal-ctags software-properties-common \
	bc dh-autoreconf libcurl4-gnutls-dev libexpat1-dev \
	gawk gettext libz-dev libssl-dev install-info || exit

[[ -x "/usr/bin/uname" ]] && UNAME="/usr/bin/uname"
[[ -x "/bin/uname" ]] && UNAME="/bin/uname"

OSRELEASE=$("${UNAME}" -r)
if [[ "${OSRELEASE}" =~ "-microsoft-" ]]; then
	# on WSL2 install golang to be able to compile npiperelay
	sudo apt-get -y install golang socat
fi

echo "Installing zsh with theme p10k / bash fallback aliases"
cd "${HOME}" || exit
sh -c "$(curl -fsSL \
	https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) \
  --unattended"
echo "Installing powerlevel10k for zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
	"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

cd "${HOME}" || exit
touch .hushlogin

if [[ "${OSRELEASE}" =~ "-microsoft-" ]]; then
	# compile the npiperelay program if it is not already existing
	NPR=/mnt/c/ProgramFiles/npiperelay/npiperelay.exe
	if [[ ! -f "${NPR}" ]]; then
		# -d says not to install the poackage
		go get -d github.com/jstarks/npiperelay
		GOOS=windows go build -o ${NPR} github.com/jstarks/npiperelay
	fi
	# on WSL2 install a shell script with npiperelay as ssh-agent
	cd "${HOME}/bin" || exit
	ln -sf wsl2-relay-agent.sh ssh-agent
fi

echo "Creating current terminfo files"
cd "${HOME}" || exit
#sudo /usr/bin/tic -xe mintty,tmux-256color "${HOME}/.dotfiles/terminfo/terminfo.src"
sudo /usr/bin/tic -x "${HOME}/.dotfiles/terminfo/mintty.terminfo"
sudo /usr/bin/tic -x "${HOME}/.dotfiles/terminfo/tmux.terminfo"
sudo /usr/bin/tic -x "${HOME}/.dotfiles/terminfo/xterm-kitty.terminfo"

GIT_VERSION=$(git --version | sed -e 's/git version \([0-9]*\.[0-9]*\)\..*/\1/')
if (($(echo "${GIT_VERSION} < 2.26" | bc -l))); then
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

echo "Configuring git"
cd "${HOME}" || exit
ln -sf .dotfiles/.git_template .
ln -sf .dotfiles/.gitconfig .

cd "${HOME}" || exit
sudo chsh -s /usr/bin/zsh "$(whoami)"
