#!/usr/bin/env bash

version="1.0"

set -e

# Determine install directory
ST_HOME="$(cd "$(dirname "$0")" && pwd)"

# Init block to be inserted into rc files
init_block="### Shell tools initialization ###
export ST_HOME=\"$ST_HOME\"
source \$ST_HOME/shelltools.sh
##################################"

# Target RC files
rc_files=(
  "$HOME/.bashrc"
  "$HOME/.zshrc"
)

insert_block() {
  local file="$1"

  # Create file if it doesn't exist
  [ -f "$file" ] || touch "$file"

  # Remove any previous ShellTools init block
  sed -i '/### Shell tools initialization ###/,/##################################/d' "$file"

  # Append the new block
  echo -e "$init_block" >> "$file"

  echo "Added initialization block to: $file"
}

echo "Installing ShellTools..."
echo

for file in "${rc_files[@]}"; do
  insert_block "$file"
done

# Fancy ASCII banner
cat <<EOF

 SSSSS   H   H  EEEEE  L      L     TTTTTTT  OOO   OOO  L      SSSSS
 S       H   H  E      L      L        T    O   O O   O L      S
 SSSSS   HHHHH  EEEE   L      L        T    O   O O   O L      SSSSS
     S   H   H  E      L      L        T    O   O O   O L          S
 SSSSS   H   H  EEEEE  LLLLL  LLLLL    T     OOO   OOO  LLLLL  SSSSS
                                                             $version

EOF

echo "Installation complete."
echo "Please restart your terminal, or run:"
echo "   source ~/.bashrc  # if using Bash"
echo "   source ~/.zshrc   # if using Zsh"
echo
