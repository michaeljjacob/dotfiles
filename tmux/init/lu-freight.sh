#!/bin/bash
session="lu_freight"
project_dir="$HOME/dev/lu-freight"

SESSIONEXISTS=$(tmux list-sessions | grep $session)

if [ "$SESSIONEXISTS" ]; then
  echo "Session $session already exists. Attaching..."
  tmux attach-session -t $session
  exit 0
fi

tmux new-session -d -s $session -c $project_dir

# Root window
root="root"
tmux rename-window -t $session $root
tmux send-keys -t $session:$root 'nvim' C-m
tmux split-window -v -p 20 -t $session:$root -c $project_dir

# Webapp API window
webapp_api="webapp-api"
webapp_api_path="$project_dir/supabase/functions/webapp-api"
tmux new-window -t $session -n $webapp_api -c $webapp_api_path
tmux send-keys -t $session:$webapp_api 'nvim' C-m
tmux split-window -v -p 20 -t $session:$webapp_api -c $webapp_api_path

# Webapp Project window
webapp="webapp"
webapp_path="$project_dir/projects/webapp"
tmux new-window -t $session -n $webapp -c $webapp_path
tmux send-keys -t $session:$webapp 'nvim' C-m
tmux split-window -v -p 20 -t $session:$webapp -c $webapp_path

tmux attach-session -t $session
