#!/usr/bin/env sh

set -x

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
LAST_WALLPAPER_FILE="$HOME/.fehbg"

list_folders() {
  find "$WALLPAPER_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;
}

list_files_in_folder() {
  find "$WALLPAPER_DIR/$1" -type f -exec basename {} \;
}

select_folder() {
  list_folders | rofi -dmenu -i -p "Select wallpaper folder"
}

select_wallpaper() {
  list_files_in_folder "$1" | rofi -dmenu -i -p "Select Wallpaper"
}

main(){
  SELECTED_FOLDER=$(select_folder)
  
  [ -z "$SELECTED_FOLDER" ] && {
    echo "No folder selected. Exiting."
    exit 1
  }
  
  WALLPAPERS=$(list_files_in_folder "$SELECTED_FOLDER")
  
  [ -z "$WALLPAPERS" ] && {
    echo "No wallpapers found in the selected folder. Exiting."
    exit 1
  }
  
  SELECTED_WALLPAPER=$(select_wallpaper "$SELECTED_FOLDER")
  
  [ -z "$SELECTED_WALLPAPER" ] && {
    echo "No wallpaper selected. Exiting."
    exit 1
  }
  
  feh --bg-fill "$WALLPAPER_DIR/$SELECTED_FOLDER/$SELECTED_WALLPAPER"
  
  sed -i "s|^feh --bg-fill '.*'|feh --bg-fill \
    '$WALLPAPER_DIR/$SELECTED_FOLDER/$SELECTED_WALLPAPER'|" \
    "$LAST_WALLPAPER_FILE"
  
  dunstify "New wallpaper:" "$SELECTED_WALLPAPER"
}

main
