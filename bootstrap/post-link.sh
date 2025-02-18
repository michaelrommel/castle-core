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
for t in tmux mintty xterm-ghostty wezterm xterm-kitty; do 
	if is_mac; then
		if ! infocmp ${t} 2>/dev/null 1>&2; then
			sudo /usr/bin/tic -x "${HOME}/.terminfo_src/${t}.terminfo" 2>/dev/null
		fi
	else
		/usr/bin/tic -x "${HOME}/.terminfo_src/${t}.terminfo" 2>/dev/null
	fi
done
