#!/usr/bin/env bash

set_line() {
    READLINE_LINE=$1
    READLINE_POINT=${#1}
}

handle_jmenu() {
    IFS=';' read -r -a parts <<< "$1"

    #printf '%s\n' "${parts[@]}"

    local item_type=${parts[0]}
    local cmd=""

    case $item_type in

        "command")
            set_line "${parts[1]}"
            ;;

        "audio_only_stream")
            set_line "mpv --no-video ${parts[2]}"
            ;;

        "audio_stream")
            set_line "mpv ${parts[2]}"
            ;;

    esac
}

jmenu() {
    local selected=$(~/.config/jmenu/provider.sh| fzf --delimiter=";" --with-nth=2)
    local fzf_result=$?

    if [ "$fzf_result" -eq "0" ]; then
        handle_jmenu "$selected"
    fi
}

bind -x '"\ej": jmenu'
