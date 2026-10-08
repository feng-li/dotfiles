# Emit OSC locally so Mosh does not need to transport terminal control strings.
# Also guard direct sourcing from scripts or noninteractive shells.
[[ -o interactive ]] || return 0

typeset -gA REMOTE_BG=(
    carbon '#183529'
    precisiontower '#2e003e'
    spark '#17324d'
    ti '#422818'
)

_remote_background_osc() {
    if [[ -n $TMUX ]]; then
        printf '\ePtmux;\e\e]%s\a\e\\' "$1"
    else
        printf '\e]%s\a' "$1"
    fi
}

_remote_background_run() {
    local transport=$1
    shift
    local -a arguments=("$@")
    local arg host='' machine color previous=${_REMOTE_BACKGROUND_CURRENT:-}
    local skip=0 no_color=0 options=1

    # Inspect options without changing the arguments passed to the executable.
    while (( $# )); do
        arg=$1
        shift
        if (( skip )); then
            skip=0
            continue
        fi
        if (( options )) && [[ $arg == -- ]]; then
            options=0
            continue
        fi
        if (( options )) && [[ $arg == -* ]]; then
            if [[ $transport == ssh ]]; then
                case $arg in
                    -G|-V|-Q|-N|-f|-n|-T|-O*|-W*|-s) no_color=1 ;;
                esac
                # An argument-taking option may follow clustered flags (-vvp).
                if [[ $arg == -[^-]* && $arg[-1] == [BbcDEeFIiJLlmOoPpQRSWw] ]]; then
                    skip=1
                fi
            else
                case $arg in
                    -p|-c|--port|--client|--server|--ssh|--predict|--bind-server|--experimental-remote-ip)
                        skip=1 ;;
                    --help|--version) no_color=1 ;;
                esac
            fi
            continue
        fi
        host=$arg
        # Remote commands and noninteractive SSH do not change the background.
        (( $# )) && no_color=1
        break
    done

    if [[ -z $host || ! -t 1 ]] || (( no_color )); then
        if [[ $transport == ssh ]]; then
            TERM=xterm-256color command ssh "${arguments[@]}"
        else
            command mosh "${arguments[@]}"
        fi
        return $?
    fi

    machine=${${host##*@}:l}
    machine=${machine%%.*}
    color=${REMOTE_BG[$machine]:-#303030}
    local _REMOTE_BACKGROUND_CURRENT=$color
    local result=0
    _remote_background_osc "11;$color"
    {
        if [[ $transport == ssh ]]; then
            TERM=xterm-256color command ssh "${arguments[@]}"
        else
            command mosh "${arguments[@]}"
        fi
        result=$?
    } always {
        if [[ -n $previous ]]; then
            _remote_background_osc "11;$previous"
        else
            _remote_background_osc 111
        fi
    }
    return $result
}

# Remove an old alias when loading this file into an existing shell.
unalias ssh mosh 2>/dev/null
function ssh { _remote_background_run ssh "$@" }
function mosh { _remote_background_run mosh "$@" }

# Retain the previous explicit interface for existing muscle memory.
remote() {
    case $1 in
        ssh|mosh) _remote_background_run "$@" ;;
        *) print -u2 'Usage: remote {ssh|mosh} [options] host'; return 2 ;;
    esac
}
