#!/bin/bash

shell_name=$(basename "$SHELL")
script_dir=$(dirname "$(realpath "$0")")

init_lines="### Shell tools initialization ###
export ST_HOME=$script_dir
source \$ST_HOME/stinit.sh
##################################"

case "$shell_name" in
    bash)
        rc_file="$HOME/.bashrc"
        ;;
    zsh)
        rc_file="$HOME/.zshrc"
        ;;
    fish)
        rc_file="$HOME/.config/fish/config.fish"
        ;;
    *)
        # Для других оболочек, например, Git Bash
        rc_file="$HOME/.bash_profile"
        ;;
esac

sed -i '/### Shell tools initialization ###/,/##################################/d' "$rc_file"

echo "" >> "$rc_file"
echo "$init_lines" >> "$rc_file"

echo "Shell tools initialization added to $rc_file"

