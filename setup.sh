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

# Install vim-plug and plugins
install_vim_plugins () {
  local plug_path="$HOME/.vim/autoload/plug.vim"
  
  # Install vim-plug if not already installed
  if [ ! -f "$plug_path" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$plug_path" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug installed"
  else
    echo "vim-plug is already installed"
  fi
  
  # Install/update plugins
  vim +PlugInstall +qall 2>/dev/null
  echo "Vim plugins installed"
}

# Install Homebrew if not already installed
install_homebrew () {
  if command -v brew &> /dev/null; then
    echo "Homebrew is already installed"
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed"
  fi
  
  # Evaluate Homebrew environment
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
}

# Install Homebrew packages and casks from Brewfile
install_brew_packages () {
  # Check if brew is installed
  if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed"
    return 1
  fi
  
  local brewfile="./Brewfile"
  if [ ! -f "$brewfile" ]; then
    echo "Error: $brewfile not found"
    return 1
  fi
  
  echo "Installing Homebrew packages from Brewfile..."
  brew bundle install --file "$brewfile"
}

# Setup symlinks for app configurations
setup_symlinks () {
  # Karabiner
  local karabiner_src="$(cd ./karabiner && pwd)/karabiner.json"
  local karabiner_dest="$HOME/.config/karabiner/karabiner.json"
  
  mkdir -p "$HOME/.config/karabiner"
  if [ -L "$karabiner_dest" ]; then
    echo "Karabiner symlink already exists"
  elif [ -f "$karabiner_dest" ]; then
    echo "Warning: $karabiner_dest exists and is not a symlink. Backing up to $karabiner_dest.bak"
    mv "$karabiner_dest" "$karabiner_dest.bak"
    ln -s "$karabiner_src" "$karabiner_dest"
  else
    ln -s "$karabiner_src" "$karabiner_dest"
    echo "Karabiner symlink created"
  fi
  
  # iTerm2 DynamicProfiles
  local iterm2_src="$(cd ./iterm2 && pwd)/profiles.json"
  local iterm2_dest="$HOME/Library/Application Support/iTerm2/DynamicProfiles/profiles.json"
  
  mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  if [ -L "$iterm2_dest" ]; then
    echo "iTerm2 symlink already exists"
  elif [ -f "$iterm2_dest" ]; then
    echo "Warning: $iterm2_dest exists and is not a symlink. Backing up to $iterm2_dest.bak"
    mv "$iterm2_dest" "$iterm2_dest.bak"
    ln -s "$iterm2_src" "$iterm2_dest"
  else
    ln -s "$iterm2_src" "$iterm2_dest"
    echo "iTerm2 symlink created"
  fi
}

set_default_shell

append_source ./zsh/.zprofile.mine ~/.zprofile
append_source ./zsh/.zshrc.mine ~/.zshrc
append_source ./vim/.vimrc.mine ~/.vimrc

install_homebrew
install_vim_plugins
install_brew_packages
setup_symlinks
