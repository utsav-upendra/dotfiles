# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository containing utility scripts and shell configuration for development environment management. The repository provides convenience scripts and functions for common development tasks.

## Shell Configuration Setup

The repository includes automatic loading of functions and aliases via:
- `shell/config.zsh` - Main configuration file that loads all custom functions and aliases
- Integration: Add `source ~/Projects/dotfiles/shell/config.zsh` to your `.zshrc`

## Available Scripts and Functions

### Port Management
- `kill_port <port>` function - Enhanced port killing with better error handling
  - Usage: `kill_port 3000` or alias `kp 3000`
  - Available automatically after sourcing config
- `scripts/killport.zsh <port_number>` - Standalone zsh script
  - Usage: `./scripts/killport.zsh 3000`

### Docker Management
- `docker-nuclear` alias - Complete Docker environment cleanup
  - Removes ALL containers, images, volumes, networks, and build cache
  - Interactive confirmation required
  - Usage: `docker-nuclear`
- Direct script: `scripts/nuclear.sh`

### Git Branch Management
- `gco` function - Enhanced git checkout with branch tracking
  - Tracks the previous branch for later merging
  - Usage: `gco branch-name` or `gco -b new-branch`
- `gm` function - Interactive merge from last branch
  - Merges the previously checked out branch into current branch
  - Interactive menu for confirmation
  - Usage: `gm`

## Script Execution

Scripts can be executed in multiple ways:
1. Via loaded functions/aliases (after sourcing config.zsh)
2. Directly if executable: `./scripts/scriptname.sh`
3. Via interpreter: `bash scripts/scriptname.sh` or `zsh scripts/scriptname.zsh`

## Repository Structure

```
dotfiles/
├── scripts/
│   ├── killport.zsh         # Standalone port management utility
│   ├── nuclear.sh           # Docker cleanup utility
│   └── git-branch-manager.sh # Git branch functions (gco, gm)
├── shell/
│   └── config.zsh           # Main shell configuration file
├── CLAUDE.md                # This documentation file
└── .gitignore              # Git ignore file
```

## Development Notes

- All utility scripts are in the `scripts/` directory
- Shell configuration and aliases are in `shell/config.zsh`
- Functions and aliases are automatically available after sourcing the config
- The repository uses bash and zsh shell scripting
- Git branch manager tracks branch switching history in `.git/last_branch.txt`