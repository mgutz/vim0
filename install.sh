#!/usr/bin/env bash

mkdir -p ./_tmp
mkdir -p ./_bundles

curl -fLo _bundles/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
