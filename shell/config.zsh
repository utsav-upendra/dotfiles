#!/bin/zsh

# Dotfiles Shell Configuration
# This file is sourced by .zshrc to load all custom functions and aliases

# Get the directory where this script is located
DOTFILES_DIR="${0:A:h:h}"

# Enhanced kill_port function with better error handling
function kill_port() {
  if [ -z "$1" ]; then
    echo "Usage: kill_port <port>"
    return 1
  fi

  PORT=$1

  # Find the process using the specified port
  PID=$(lsof -t -i:$PORT)

  if [ -z "$PID" ]; then
    echo "No process found running on port $PORT"
    return 1
  fi

  # Kill the process
  kill -9 $PID
  if [ $? -ne 0 ]; then
    echo "Failed to kill process $PID on port $PORT"
    return 1
  fi

  echo "Successfully killed process $PID on port $PORT"
}

# Docker nuclear cleanup alias
alias docker-nuclear="$DOTFILES_DIR/scripts/nuclear.sh"

# Unalias oh-my-zsh git aliases if they exist to avoid conflicts
unalias gco 2>/dev/null || true
unalias gm 2>/dev/null || true

# Source git branch manager functions (gco and gm)
source "$DOTFILES_DIR/scripts/git-branch-manager.sh"

# Additional aliases for convenience
alias kp="kill_port"  # Short alias for kill_port