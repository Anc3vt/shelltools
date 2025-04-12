#!/bin/bash

# Функция для проверки наличия флага
check_flag() {
    local flag=$1
    if [[ " ${flags[@]} " =~ " ${flag} " ]]; then
        return 0  # Флаг найден
    else
        return 1  # Флаг не найден
    fi
}

# Функция для получения значения аргумента по флагу
get_argument() {
    local flag=$1
    local value=""
    for ((i=0; i<${#args[@]}; i++)); do
        if [[ "${args[$i]}" == "--$flag" ]]; then
            value="${args[$((i+1))]}"
            break
        fi
    done
    echo "$value"
}

# Функция для парсинга аргументов
parse_args() {
    args=()
    flags=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --*)
                flag="${1/--/}"
                flags+=("$flag")
                if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                    args+=("$1" "$2")
                    shift
                else
                    args+=("$1")
                fi
                ;;
            *)
                args+=("$1")
                ;;
        esac
        shift
    done
}

# Подключение
parse_args "$@"