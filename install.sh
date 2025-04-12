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
        rc_file="$HOME/.bash_profile"
        ;;
esac

sed -i '/### Shell tools initialization ###/,/##################################/d' "$rc_file"

echo "" >> "$rc_file"
echo "$init_lines" >> "$rc_file"

version=$(cat $ST_HOME/shelltools-version.txt)

echo
echo "
 SSSSS   H   H  EEEEE  L      L     TTTTTTT  OOO   OOO  L      SSSSS
 S       H   H  E      L      L        T    O   O O   O L      S
 SSSSS   HHHHH  EEEE   L      L        T    O   O O   O L      SSSSS
     S   H   H  E      L      L        T    O   O O   O L          S
 SSSSS   H   H  EEEEE  LLLLL  LLLLL    T     OOO   OOO  LLLLL  SSSSS
                                                                  $version
"
echo "ShellTools $version installed. Initialization lines added to $rc_file"
echo "Please re-login to your shell for the changes to take effect."
echo
