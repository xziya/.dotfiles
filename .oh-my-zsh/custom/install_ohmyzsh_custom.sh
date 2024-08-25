#!/usr/bin/env bash

dotfiles_repo_dir=$PWD

# Check if ZSH is installed
if [ -d "$ZSH" ]; then
    # Iterate through all subdirectories
    for dir in "${dotfiles_repo_dir}/.oh-my-zsh/custom"; do
        if [ -d "$dir" ]; then
            # Create symlinks in custom plugins directory
            if [ -d "$dir/plugins" ]; then
                for plugin in "$dir/plugins"/*; do
                    if [ -d "$plugin" ]; then
                        ln -s "$plugin" "$ZSH/custom/plugins/$(basename "$plugin")"
                    fi
                done
            fi
            
            # Create symlinks in custom themes directory
            if [ -d "$dir/themes" ]; then
                for theme in "$dir/themes"/*.zsh-theme; do
                    if [ -f "$theme" ]; then
                        ln -s "$theme" "$ZSH/custom/themes/$(basename "$theme")"
                    fi
                done
            fi
        fi
    done
    echo "Symlinks to Oh My Zsh customs created successfully."
else
    echo "ZSH directory not found. Make sure Oh My Zsh is installed."
fi
