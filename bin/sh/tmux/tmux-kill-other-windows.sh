#!/bin/sh

# Get the current session name
current_session=$(tmux display-message -p "#S")

# Get the current window id
current_window=$(tmux display-message -p "#I")

# Get a list of all windows in the current session except the current one
windows=$(tmux list-windows -t "$current_session" -F "#I" | grep -v "^${current_window}$")

# Kill all other windows
for window in $windows; do
	tmux kill-window -t "${current_session}:${window}"
done

tmux display-message "All windows have been deleted sussecsfully."
