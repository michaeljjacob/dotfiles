#!/bin/bash
session="lucidity"
project_dir="$HOME/dev/lucidity"

SESSIONEXISTS=$(tmux list-sessions | grep $session)

if [ "$SESSIONEXISTS" ]; then
  echo "Session $session already exists. Attaching..."
  tmux attach-session -t $session
  exit 0
fi

tmux new-session -d -s $session -c $project_dir

# Setup the root window
root="root"
tmux rename-window -t $session $root

tmux send-keys -t $session:$root 'nvim' C-m

tmux split-window -v -p 20 -t $session:$root -c $project_dir
tmux send-keys -t $session:$root.1 'cd ~/lucidity' C-m

# Setup the functions window
functions="functions"
functions_path="$project_dir/supabase/functions"
tmux new-window -t $session -n $functions -c $functions_path
tmux send-keys -t $session:$functions 'nvim' C-m
tmux split-window -v -p 20 -t $session:$functions -c $functions_path

# Setup the web-app window
web_app="web-app"
web_app_path="$project_dir/projects/web-app"
tmux new-window -t $session -n $web_app -c $web_app_path
tmux send-keys -t $session:$web_app 'nvim' C-m
tmux split-window -v -p 20 -t $session:$web_app -c $web_app_path

# Setup the lu-scan window
lu_scan="lu-scan"
lu_scan_path="$project_dir/projects/lu-scan"
tmux new-window -t $session -n $lu_scan -c $lu_scan_path
tmux send-keys -t $session:$lu_scan 'nvim' C-m
tmux split-window -v -p 20 -t $session:$lu_scan -c $lu_scan_path

# Attach to the session
tmux attach-session -t $session
