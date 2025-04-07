while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -*)
            export key="${key#-}"
            export key="${key//-/}"
            eval "$key=\"$2\""
            shift
            ;;
        *)
            ;;
    esac
    shift
done
