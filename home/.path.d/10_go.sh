#! /bin/bash

# Go location
GOPATH=$(readlink -f "${HOME}/software")/go
export GOPATH

if [[ -d "${GOPATH}/bin" && ! "$PATH" == *${GOPATH}/bin* ]]; then
	# path has not yet been added
	export PATH="${GOPATH}/bin:${PATH}"
fi
