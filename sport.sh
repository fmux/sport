#!/bin/bash
REPEATS=${1:-6}
N=${2:-12}
PAUSE=${3:-20}
EXERCISES=(
    "Pillar Bridge Frontal"
    "Pillar Bridge Lateral"
    "Beckenlift"
    "Crunch"
    "T's & Y's"
    "Reverse Dips"
    "Kniebeuge"
)

function beep {
    local i
    for (( i=1; i <= ${1:-1}; i++ )); do
        paplay /usr/share/sounds/freedesktop/stereo/bell.oga
    done
}

function header {
    tput clear
    local i
    for (( i=0; i < $count; i++ )); do
        if [[ -n "$1" && "$i" -eq "$1" ]]; then
            tput bold
            printf " ● "
        else
            tput sgr0
            printf " ○ "
        fi
        echo "${EXERCISES[$i]}"
    done
    echo
}

function progress {
    tput sc
    local i
    for (( i=0; i <= $1; i++ )); do
        local j=$(($1-$i))
        if [[ "$j" -lt 3 ]]; then
            beep
        fi
        if [[ "$i" -gt 0 ]]; then
            sleep 1
        fi
        tput rc
        printf "["
        for (( k=0; k < $i; k++ )); do
            printf "█"
        done
        for (( k=0; k < $j; k++ )); do
            printf "▒"
        done
        printf "]"
    done
}

function main {
    header

    for i in {1..5}; do
        beep
        sleep 1
    done

    local i
    for (( i=0; i < $count; i++)); do
        header $i
        local j
        for (( j=1; j <= $REPEATS; j++ )); do
            echo -n "${j}/${REPEATS} "
            beep 2
            progress $N
            beep 2
            echo -n " break "
            progress $PAUSE
            echo
        done
        echo
    done
}

tput civis
function finish {
  tput cnorm
}
trap finish EXIT

count=0
for exercise in "${EXERCISES[@]}"; do
    ((count++))
done

main
