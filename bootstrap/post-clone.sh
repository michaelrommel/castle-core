#! /bin/bash

echo "Installing apt packages"
sudo apt-get -y update
sudo apt-get -y install build-essential autoconf automake pkg-config \
	libevent-dev libncurses5-dev bison byacc curl tmux git vim \
	mosh keychain neofetch zsh ncurses-bin gdebi-core apt-file \
	unzip sysstat net-tools dnsutils asciidoctor \
	python3-pip universal-ctags software-properties-common \
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

# TMUX_VERSION=$(tmux -V)
# if [[ "${TMUX_VERSION}" != "tmux 3.1b" ]]; then
#   echo "Building tmux"
#   mkdir -p "${HOME}/software"; cd "${HOME}/software" || exit
#   git clone https://github.com/tmux/tmux.git
#   cd "${HOME}/software/tmux" || exit
#   git checkout 3.1b
#   sh autogen.sh
#   ./configure && make
#   sudo make install
# fi

echo "Configuring tmux plugins"
mkdir -p "${HOME}/.config/tmux"
cd "${HOME}/.config/tmux" || exit
ln -sf ../../.dotfiles/.config/tmux/tmux.conf .
mkdir -p "${HOME}/.local/share/tmux/plugins"
cd "${HOME}/.local/share/tmux/plugins" || exit
git clone --depth=1 https://github.com/tmux-plugins/tpm "${HOME}/.local/share/tmux/plugins/tpm"
for p in tmux-network-bandwidth tmux-gruvbox tmux-plugin-cpu; do
	ln -s ../../../../.dotfiles/.local/share/tmux/plugins/$p .
done
"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

# echo "Installing Node Version Manager (nvm) and node"
# cd "${HOME}" || exit
# /bin/bash -c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh)"
# export NVM_DIR="$HOME/.nvm"
# # shellcheck source=/dev/null
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# nvm install 'lts/*' --latest-npm

echo "Installing the fast Node Manager (fnm) and node"
cd "${HOME}" || exit
curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash -s -- --skip-shell
ln -sf .dotfiles/.fnm.sh .
source .fnm.sh
fnm install 'lts/*'
fnm default lts-latest

echo "Installing yarn"
cd "${HOME}" || exit
npm install --global yarn

echo "Configuring git"
cd "${HOME}" || exit
ln -sf .dotfiles/.git_template .
ln -sf .dotfiles/.gitconfig .

echo "Preparing coc"
cd "${HOME}" || exit
mkdir -p "${HOME}/.config/coc/extensions"
cd "${HOME}/.config/coc/extensions" || exit
for p in coc-css coc-diagnostic coc-eslint coc-json coc-snippets coc-svelte coc-tailwindcss coc-tsserver; do
	npm install --install-strategy=shallow --ignore-scripts --no-bin-links --no-package-lock --omit=dev $p
done
# if [[ -d "./node_modules/coc-svelte" ]]; then
#   cd "./node_modules/coc-svelte" || exit
#   npm install --save-dev typescript
# fi

# echo "Installing vim configurations"
# cd "${HOME}" || exit
# mkdir -p "${HOME}/.vim/plugins";
# ln -sf .dotfiles/.vimrc .
# curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
#     "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
# cd "${HOME}/.vim" || exit
# ln -sf ../.dotfiles/.vim/coc-settings.json .
# vim -es -u "${HOME}/.vimrc" -i NONE -c "PlugInstall" -c "qa"

echo "Installing fonts"
mkdir -p "${HOME}/.local/share"
cd "${HOME}/.local/share" || exit
ln -sf ../../.dotfiles/.local/share/fonts/ .
fc-cache -f

echo "Updating neovim"
sudo apt-get install ninja-build gettext cmake unzip curl
cd "${HOME}" || exit
mkdir -p "${HOME}/software/"
cd "${HOME}/software/" || exit
git clone https://github.com/neovim/neovim neovim_src
cd neovim_src || exit
git checkout stable
make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${HOME}/software/neovim"
make install

echo "Installing rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="${HOME}/.cargo/bin:${PATH}"

echo "Installing tree-sitter cli"
cargo install tree-sitter-cli

echo "Installing neovim configurations"
mkdir -p "${HOME}/.config/miro"
cd "${HOME}/.config/miro" || exit
ln -sf ../../.dotfiles/.config/miro/init.lua .
ln -sf ../../.dotfiles/.config/miro/lua/ .
ln -sf ../../.dotfiles/.config/miro/after/ .

echo "Installing shellcheck"
mkdir -p "${HOME}/software"
cd "${HOME}/software" || exit
scversion="stable" # or "v0.4.7", or "latest"
curl -sL "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJ
sudo cp "shellcheck-${scversion}/shellcheck" /usr/bin/

echo "Installing asciidoctor extensions"
# cargo install --version 0.4.2 svgbob_cli
# for specific version use: sudo gem install --version 2.0.4 asciidoctor-diagram
if [[ "${http_proxy}" != "" ]]; then
	OPTS=" --http-proxy ${http_proxy}"
fi
sudo gem install "${OPTS}" asciidoctor-diagram
sudo gem install "${OPTS}" asciidoctor-pdf

cd "${HOME}" || exit
sudo chsh -s /usr/bin/zsh "$(whoami)"
