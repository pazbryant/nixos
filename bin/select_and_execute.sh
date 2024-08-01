#!/bin/sh

set -e
set -x

# Base directory containing the scripts
BASE_DIR="$HOME/.dotfiles/bin/rofi"

# Validate if necessary dependencies are installed
check_dependencies() {
  if ! command -v rofi >/dev/null 2>&1 || ! command -v dunstify >/dev/null 2>&1; then
    echo "Error: 'rofi' or 'dunstify' is not installed. Please install both and try again."
    exit 1
  fi
}

# Get the name of the script to execute
select_script() {
  script_list=$(find "$BASE_DIR/")

  if [ -z "$script_list" ]; then
    dunstify "No scripts found in $BASE_DIR"
    exit 1
  fi

  script_names=$(echo "$script_list" | xargs -n 1 basename)
  script_name=$(echo "$script_names" | rofi -dmenu -p "Choose a script:")

  if [ -z "$script_name" ]; then
    dunstify "No script selected"
    exit 1
  fi

  echo "$script_name"
}

# Execute the selected script
run_script() {
  script_name=$1
  "$BASE_DIR/$script_name"
}

# Main function
main() {
  check_dependencies
  script=$(select_script)
  run_script "$script"
}

# Run the main function
main
