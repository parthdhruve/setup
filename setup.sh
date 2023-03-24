#!/bin/bash

append_source () {
{ echo -n "source " & echo `readlink -f $1`; } >> "$2"
}

append_source ./bash/.bashrc.mine ~/.bash_profile
append_source ./vim/.vimrc.mine ~/.vimrc
