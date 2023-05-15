#! /bin/bash

if [[ "${OSRELEASE}" =~ "-microsoft-" ]]; then
	echo "Linking wsl2-relay as ssh-agent"
	# on WSL2 install a shell script with npiperelay as ssh-agent
	cd "${HOME}/bin" || exit
	ln -sf wsl2-relay-agent.sh ssh-agent
fi

echo "Creating current terminfo files"
cd "${HOME}" || exit
#sudo /usr/bin/tic -xe mintty,tmux-256color "${HOME}/.dotfiles/terminfo/terminfo.src"
sudo /usr/bin/tic -x "${HOME}/.terminfo_src/mintty.terminfo"
sudo /usr/bin/tic -x "${HOME}/.terminfo_src/tmux.terminfo"
sudo /usr/bin/tic -x "${HOME}/.terminfo_src/xterm-kitty.terminfo"
