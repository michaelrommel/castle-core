#! /bin/bash

source "${HOME}/.homesick/helper.sh"

if is_wsl; then
	echo "Linking wsl2-relay as ssh-agent"
	# on WSL2 install a shell script with npiperelay as ssh-agent
	cd "${HOME}/bin" || exit
	ln -sf wsl2-relay-agent.sh ssh-agent
fi

echo "Creating current terminfo files"
cd "${HOME}" || exit
/usr/bin/tic -x "${HOME}/.terminfo_src/tmux.terminfo"
if is_wsl; then
	/usr/bin/tic -x "${HOME}/.terminfo_src/mintty.terminfo"
fi
if is_mac; then
	/usr/bin/tic -x "${HOME}/.terminfo_src/xterm-kitty.terminfo"
fi
