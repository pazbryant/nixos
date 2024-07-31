#!/usr/bin/sh

stop_polybar() {
    killall -q polybar
    while pgrep -u $UID -x polybar >/dev/null; do
        sleep 1
    done
}

start_polybar() {
    for monitor in $(polybar --list-monitors | cut -d":" -f1); do
        $monitor polybar --reload mainbar-bspwm &
    done
}

main() {
    stop_polybar
    start_polybar
}

main
