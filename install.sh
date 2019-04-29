#!/usr/bin/env bash

__dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# ensure pre-requisites are installed
for cmd in node yarn go; do
	command -v $cmd >/dev/null 2>&1 || {
		echo $cmd is require but not installed
		exit 1
	}
done

# backup directory
mkdir -p ./_backups

# plugins directory
mkdir -p ./_plugins

# nvim configuration directory
mkdir -p ~/.config/nvim

# download vim-plug manager
curl -fLo _plugins/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# coc.nvim expects known location
ln -sf $PWD/coc-settings.json ~/.config/nvim/coc-settings.json

# hook into vim
echo "source $__dirname/vimrc" >~/.vimrc
