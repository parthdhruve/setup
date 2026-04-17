#!/bin/bash

append_source () {
{ echo -n "source " & echo `readlink -f $1`; } >> "$2"
}

# Set default shell to zsh
set_default_shell () {
  local zsh_path=$(which zsh)
  if [ -z "$zsh_path" ]; then
    echo "Error: zsh is not installed"
    return 1
  fi
  
  # Check if zsh is already the default shell
  if [ "$SHELL" = "$zsh_path" ]; then
    echo "zsh is already the default shell"
  else
    chsh -s "$zsh_path"
    echo "Default shell changed to zsh"
  fi
}

set_default_shell

append_source ./bash/.bashrc.mine ~/.bash_profile
append_source ./vim/.vimrc.mine ~/.vimrc
