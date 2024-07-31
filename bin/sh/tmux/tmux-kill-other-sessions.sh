#!/bin/sh

# Get the current session name
current_session=$(tmux display-message -p "#S")

# Get a list of all sessions except the current one
sessions=$(tmux list-sessions -F "#S" | grep -v "^${current_session}$")

# Kill all other sessions
for session in $sessions; do
	tmux kill-session -t "$session"
done

tmux display-message "All sessions have been deleted sussecsfully."
