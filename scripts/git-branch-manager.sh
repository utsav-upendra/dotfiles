#!/bin/bash

# Function to get git root directory
get_git_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

# Function to get current branch
get_current_branch() {
    git branch --show-current 2>/dev/null
}

# Enhanced gco function
gco() {
    local git_root=$(get_git_root)
    if [ -z "$git_root" ]; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local current_branch=$(get_current_branch)
    local last_branch_file="$git_root/.git/last_branch.txt"
    
    # Save current branch before switching
    if [ -n "$current_branch" ]; then
        echo "$current_branch" > "$last_branch_file"
    fi
    
    # Execute git checkout with all passed arguments
    git checkout "$@"
}

# Git merge from last branch function
gm() {
    local git_root=$(get_git_root)
    if [ -z "$git_root" ]; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local last_branch_file="$git_root/.git/last_branch.txt"
    
    if [ ! -f "$last_branch_file" ]; then
        echo "Error: No last branch recorded. Use 'gco' to switch branches first."
        return 1
    fi
    
    local last_branch=$(cat "$last_branch_file")
    if [ -z "$last_branch" ]; then
        echo "Error: Last branch file is empty"
        return 1
    fi
    
    # Check if last branch exists
    if ! git show-ref --verify --quiet "refs/heads/$last_branch"; then
        echo "Error: Branch '$last_branch' no longer exists"
        return 1
    fi
    
    echo "Merge branch '$last_branch' into current branch?"
    
    # Create a simple selection menu
    local options=("Yes" "No")
    local selected=0
    
    # Function to display menu
    display_menu() {
        clear
        echo "Merge branch '$last_branch' into $(get_current_branch)?"
        echo ""
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo "→ ${options[$i]}"
            else
                echo "  ${options[$i]}"
            fi
        done
    }
    
    # Handle user input
    while true; do
        display_menu
        
        # Read single character
        read -rsn1 key
        
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key
                case "$key" in
                    '[A') # Up arrow
                        ((selected--))
                        if [ $selected -lt 0 ]; then
                            selected=$((${#options[@]} - 1))
                        fi
                        ;;
                    '[B') # Down arrow
                        ((selected++))
                        if [ $selected -ge ${#options[@]} ]; then
                            selected=0
                        fi
                        ;;
                esac
                ;;
            '') # Enter key
                break
                ;;
            'q'|'Q') # Quit
                echo ""
                echo "Merge cancelled"
                return 0
                ;;
        esac
    done
    
    clear
    if [ $selected -eq 0 ]; then
        echo "Merging '$last_branch' into $(get_current_branch)..."
        git merge "$last_branch"
    else
        echo "Merge cancelled"
    fi
}