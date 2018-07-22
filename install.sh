#!/bin/bash

cp .bashrc ~/.bashrc
cp .bash_aliases ~/.bash_aliases
cp ssh_config ~/.ssh/config
cp .gitconfig ~/.gitconfig

echo "Done. Please reload .bashrc by typing . ~/.bashrc (or rc if scripts were executed at least once before)"
