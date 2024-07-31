#!/bin/sh

if [ $# -eq 1 ]; then
  selected="$1"
else
  selected=$(fd --min-depth 1 \
    --max-depth 1 \
    --type d . \
    ~/Documents/github/ \
    ~/Documents/github/codeeditors/ \
    ~/Documents/github/examples/ \
    ~/Documents/github/royal/ \
    ~/Documents/github/forks/ \
    ~/mega/personal/pc/ \
    ~/mega/work/ \
    ~/Downloads/ | fzf)
fi

if [ -z "$selected" ]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [ -z "$TMUX" ] && [ -z "$tmux_running" ]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"

selected_path="/home/bryant/Documents/github/notes/"

if [ "$selected" = "$selected_path" ]; then
  tmux send-keys "nvim Todo.md" Enter
fi
