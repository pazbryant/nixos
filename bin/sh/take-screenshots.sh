#!/usr/bin/env sh

DIR="$HOME/Pictures/Screenshots"

save_cropped_clipboard() {
  maim --select "$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
}

save_full_clipboard() {
  maim "$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
}

send_notification() {
  dunstify "Screenshot saved"
}

main() {
  if [ "$1" = "full" ]; then
    save_full_clipboard
  elif [ "$1" = "cropped" ]; then
    save_cropped_clipboard
  fi

  send_notification
}

main "$1"

