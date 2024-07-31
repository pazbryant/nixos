#!/bin/sh

# Get a list of existing tmux sessions
sessions=$(tmux list-sessions -F "#S" 2>/dev/null)

# If no sessions are found, notify and exit
if [ -z "$sessions" ]; then
	echo "No tmux sessions found."
	exit 1
fi

# Use fzf to select a session
selected=$(echo "$sessions" | fzf --prompt="Select a tmux session: ")

# Exit if no session was selected
if [ -z "$selected" ]; then
	exit 0
fi

# Switch to the selected tmux session
if [ -n "$TMUX" ]; then
	tmux switch-client -t "$selected"
else
	tmux attach-session -t "$selected"
fi
