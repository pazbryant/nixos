#!/usr/bin/env sh

set -x
set -e

get_current_layout() {
  setxkbmap -query | rg layout | awk '{print $2}'
}

send_notification() {
  current_layout=$1
  dunstify "Keyboard" "$current_layout"
}

switch_layout() {
  current_layout=$(get_current_layout)
  if [ "$current_layout" = "bryant-dvorak" ]; then
    setxkbmap bryant-dvorak-itl
  else
    setxkbmap bryant-dvorak
  fi
  new_layout=$(get_current_layout)
  send_notification "$new_layout"
}

switch_layout
