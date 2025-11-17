#!/bin/bash

export ST_HOME=${ST_HOME:-~/shelltools}
export ST_USER_HOME=${ST_USER_HOME:-~/.shelltools}
mkdir -p $ST_HOME
mkdir -p $ST_USER_HOME
mkdir -p $ST_USER_HOME/bookmarks

touch $ST_USER_HOME/env

. $ST_USER_HOME/env

export PATH=$PATH:$ST_HOME/bin/

##### COLORS #####

cK='\033[0;30m' # Black
cR='\033[0;31m' # Red
cG='\033[0;32m' # Green
cY='\033[0;33m' # Yellow
cB='\033[0;34m' # Blue
cP='\033[0;35m' # Purple
cC='\033[0;36m' # Cyan
cW='\033[0;37m' # White

bK='\033[1;30m' # Black
bR='\033[1;31m' # Red
bG='\033[1;32m' # Green
bY='\033[1;33m' # Yellow
bB='\033[1;34m' # Blue
bP='\033[1;35m' # Purple
bC='\033[1;36m' # Cyan
bW='\033[1;37m' # White

c0='\033[0m' # Re

#### PREPARE ####

unalias 1 &>/dev/null
unalias 2 &>/dev/null
unalias 3 &>/dev/null
unalias 4 &>/dev/null
unalias 5 &>/dev/null
unalias 6 &>/dev/null
unalias 7 &>/dev/null
unalias 8 &>/dev/null
unalias d &>/dev/null

#### FUNCTIONS ####

setv() {
    VARS_FILE="$ST_USER_HOME/env"

    if [[ $# -ne 1 || "$1" != *=* ]]; then
        echo "Usage: setv VAR_NAME=VALUE"
        return 1
    fi

    VAR_PAIR="$1"
    VAR_NAME="${VAR_PAIR%%=*}"
    VAR_VALUE="${VAR_PAIR#*=}"

    touch "$VARS_FILE"
    sed -i "/^export $VAR_NAME=/d" "$VARS_FILE"
    echo "export $VAR_NAME='$VAR_VALUE'" >> "$VARS_FILE"
    export "$VAR_NAME=$VAR_VALUE"

	tmp=$(cat $VARS_FILE | sort)
	echo $tmp > $VARS_FILE
}

getv() {
    VARS_FILE="$ST_USER_HOME/env"
    [ -f "$VARS_FILE" ] && . "$VARS_FILE"

    if [[ $# -ne 1 ]]; then
        cat "$VARS_FILE"
        return 1
    fi

	 eval "echo \$$1"
}

unsetv() {
    VARS_FILE="$ST_USER_HOME/env"

    if [[ $# -ne 1 ]]; then
        echo "Usage: unsetv VAR_NAME"
        return 1
    fi

    VAR_NAME="$1"
    sed -i "/^export $VAR_NAME=/d" "$VARS_FILE"
    unset "$VAR_NAME"
}

_st_env_complete_vars() {
    local curr="${COMP_WORDS[COMP_CWORD]}"
    local VARS_FILE="$ST_USER_HOME/env"
    local vars=()

    [ -f "$VARS_FILE" ] && vars=($(grep '^export ' "$VARS_FILE" | cut -d' ' -f2 | cut -d'=' -f1))

    COMPREPLY=( $(compgen -W "${vars[*]}" -- "$curr") )
}

complete -F _st_env_complete_vars getv
complete -F _st_env_complete_vars unsetv

_setv_complete_vars() {
    local curr="${COMP_WORDS[COMP_CWORD]}"
    local VARS_FILE="$ST_USER_HOME/env"
    local vars=()

    [ -f "$VARS_FILE" ] && vars=($(grep '^export ' "$VARS_FILE" | cut -d' ' -f2 | cut -d'=' -f1))

    if [[ "$curr" == *=* ]]; then
        COMPREPLY=()
    else
        COMPREPLY=( $(compgen -W "${vars[*]/%/=}" -- "$curr") )
        compopt -o nospace 2>/dev/null
    fi
}
complete -F _setv_complete_vars setv

###########

mark() {
  echo "$PWD" > "$ST_USER_HOME/bookmarks/$1"
}

deletemark() {
  local target="$ST_USER_HOME/bookmarks/$1"
  local name="$1"

  if [[ -z "$name" ]]; then
    echo "Usage: deletemark <markname>"
    return 1
  fi

  if [[ -f "$target" ]]; then
    rm -f "$target"
    echo "Deleted mark '$name'"
  else
    echo "Mark '$name' not found"
    return 1
  fi
}



jump() {
  local target="$ST_USER_HOME/bookmarks/$1"
  [[ -f "$target" ]] && cd "$(cat "$target")" || echo "Mark '$1' not found"
}

marks() {
  cd "$ST_USER_HOME/bookmarks"
  grep -r .
}

J() {
    local dir bookmarks selected
    bookmarks="$ST_USER_HOME/bookmarks"

    # если нет закладок — выход
    [[ -d "$bookmarks" ]] || { echo "No bookmarks"; return 1; }

    # формируем список "name → path"
    selected=$(ls "$bookmarks" 2>/dev/null | while read -r name; do
        [[ -f "$bookmarks/$name" ]] && echo "$name → $(cat "$bookmarks/$name")"
    done | fzf --ansi --height=40% --reverse --prompt="Bookmarks > ")

    [[ -z "$selected" ]] && return 1  # ESC or empty

    # выделяем имя закладки (левую часть до " → ")
    local name="${selected%% →*}"
    local target="$bookmarks/$name"

    [[ -f "$target" ]] && cd "$(cat "$target")"
}


export CDHISTORYDIR=$ST_USER_HOME

G() {
  local dir
  [[ -f "$CDHISTORYDIR/cd_history_long" ]] || return

  tac "$ST_USER_HOME/cd_history_long" | awk '!seen[$0]++' | tac > "$ST_USER_HOME/cd_history_long.tmp" \
      && mv "$ST_USER_HOME/cd_history_long.tmp" "$ST_USER_HOME/cd_history_long"

  export CDH_NOLOG=1

  # Форматируем вывод для fzf с улучшенной подсветкой
  local formatted
  formatted=$(awk -v home="$HOME" '
    {
      original = $0;
      gsub(home, "~");  # заменяем $HOME на ~

      if (original ~ "^/mnt/c/") {
        # Windows paths - голубой
        sub("^/mnt/c/", "\033[36m/mnt/c/\033[0m");
      } else if (original ~ "^/home/" && original != home "/") {
        # Другие home директории - зеленый
        sub("^~?/home/[^/]+/", "\033[32m&\033[0m");
      } else if (original ~ "^/opt/") {
        # System software - желтый
        sub("^/opt/", "\033[33m/opt/\033[0m");
      } else if (original ~ "^/var/") {
        # Variable data - magenta
        sub("^/var/", "\033[35m/var/\033[0m");
      } else if (original ~ "^/tmp/") {
        # Temp files - яркий magenta
        sub("^/tmp/", "\033[95m/tmp/\033[0m");
      } else if (original ~ "^/etc/") {
        # Config files - яркий cyan
        sub("^/etc/", "\033[96m/etc/\033[0m");
      } else if (original ~ "^/usr/") {
        # User programs - bright blue
        sub("^/usr/", "\033[94m/usr/\033[0m");
      }

      print $0;
    }' "$CDHISTORYDIR/cd_history_long")

  dir=$(echo -e "$formatted" | fzf \
    --ansi \
    --height=50% \
    --reverse \
    --cycle \
    --no-clear \
    --preview 'ls -A --color=auto {}' \
    --preview-window=right:20%:wrap:cycle)

  if [[ -n "$dir" ]]; then
    dir="${dir/#\~/$HOME}"
    cd "$dir"
  fi

  unset CDH_NOLOG
}



cd() {
  builtin cd "$@" || return
  [[ "$OLDPWD" == "$PWD" ]] && return
  [[ -n "$CDH_NOLOG" ]] && return

  local dir_file="$CDHISTORYDIR/cd_history"
  local long_file="$CDHISTORYDIR/cd_history_long"

  mkdir -p "$(dirname "$dir_file")"
  touch "$dir_file" "$long_file"

  { echo "$PWD"; cat "$dir_file"; } | awk '!seen[$0]++' | head -n10 > "$dir_file.tmp" && mv "$dir_file.tmp" "$dir_file"

  awk -v new="$PWD" -v max=1000 '
    BEGIN { print new; seen[new]=1 }
    !seen[$0]++ { print $0 }
    NR<max
  ' "$long_file" > "$long_file.tmp" && mv "$long_file.tmp" "$long_file"
}



get_raw_history() {
  tail "$ST_USER_HOME/cd_history" -n9 | head -n8
}

d() {
  get_raw_history |  nl -v1 -nln -w1 -s' ' > $ST_USER_HOME/tmp_numbering
  cat $ST_USER_HOME/tmp_numbering
  rm -f $ST_USER_HOME/tmp_numbering
}

st_go() {
  touch "$ST_USER_HOME/cd_history"

  local index=$1
  local dir
  dir=$(get_raw_history | sed -n "${index}p")
  [[ -n "$dir" ]] && cd "$dir" || return
}

1() { st_go 1; }
2() { st_go 2; }
3() { st_go 3; }
4() { st_go 4; }
5() { st_go 5; }
6() { st_go 6; }
7() { st_go 7; }
8() { st_go 8; }

###########################

f() {
  find ./ -iname "*$1*"
}

f1() {
	f "*$1" | head -n1
}

g() {
  grep -rinI --color "$@"
}

fvim() {
  find ./ -name "*$1*" -exec bash -c "grep -rinI '$2' >> /dev/null && vim {}" \;
}

mvnver() {
  N=$1

  [[ -z "$N" ]] && N=20

  head pom.xml -n$N | grep --color -E "groupId|<version|artifactId"
}

mvnless() {
  mvn clean install | grep -E --color "(SUCCESS|FAILURE|Building)"
}

fdate() {
  date +"%Y-%m-%d_%H-%M-%S"
}

cdw() {
    local win="$1"

    win="${win//\\//}"
    local drive="${win%%:*}"
    drive="${drive:l}"   # lower-case
    local rest="${win#*:}"
    local linux="/mnt/$drive$rest"

    cd "$linux" || {
        echo "Unable to cd to $linux"
        return 1
    }
}

