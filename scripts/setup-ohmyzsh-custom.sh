#!/bin/bash

# ============================================
# Oh My Zsh Custom Configuration Setup Script
# ============================================
# This script creates a well-organized custom directory structure
# for Oh My Zsh with separate files for aliases, functions, etc.
#
# Usage: ./setup-ohmyzsh-custom.sh [--dry-run]
# ============================================

set -e  # Exit on error

# Dry-run mode (set to 1 to simulate without creating files)
DRY_RUN=0

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dry-run]"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if script has execute permissions
check_executable() {
    local script_path="${BASH_SOURCE[0]}"
    
    # Only check if we can determine the script path
    if [[ -f "$script_path" ]]; then
        if [[ ! -x "$script_path" ]]; then
            echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${YELLOW}⚠  NOTICE: Script is not executable${NC}"
            echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            echo "This script will run normally, but for future use, make it executable:"
            echo ""
            echo -e "  ${BLUE}chmod +x $(basename "$script_path")${NC}"
            echo ""
            echo "Then you can run it directly as:"
            echo ""
            echo -e "  ${BLUE}./$(basename "$script_path")${NC}"
            echo ""
            echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            sleep 2  # Give user time to read the message
        fi
    fi
}

# Custom directory path
CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Configuration file path (repo only)
CONFIG_FILE="$(dirname "${BASH_SOURCE[0]}")/ohmyzsh-custom.conf"

# Default configuration values
DEFAULT_EDITOR="code --wait"
DEFAULT_BROWSER="open"
PYTHON_PKG_MANAGER="pip3"
NODE_PKG_MANAGER="npm"
PHP_PKG_MANAGER="composer"

# Plugin lists (space-separated)
GIT_PLUGINS="git git-extras git-flow"
DOCKER_PLUGINS="docker docker-compose"
DEV_PLUGINS="laravel composer npm yarn"
SYSTEM_PLUGINS="brew sudo"
AZURE_PLUGINS="azure"

# Custom variables
CUSTOM_ALIASES=""
CUSTOM_FUNCTIONS=""
CUSTOM_ENV_VARS=""

# Completion settings
ENABLE_UV_COMPLETION=true
ENABLE_DOCKER_COMPLETION=true
ENABLE_KUBECTL_COMPLETION=false
ENABLE_HELM_COMPLETION=false

# Load configuration from file
load_configuration() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
    
    print_info "Loading configuration from: $CONFIG_FILE"
    source "$CONFIG_FILE"
    print_success "Configuration loaded successfully"
}

# Get plugin descriptions
get_plugin_description() {
    local plugin=$1
    case $plugin in
        git) echo "Git aliases and functions | Built-in" ;;
        git-extras) echo "Extra git utilities | https://github.com/tj/git-extras" ;;
        git-flow) echo "Git-flow branching model support | https://github.com/nvie/gitflow" ;;
        docker) echo "Docker aliases and completions | Built-in" ;;
        docker-compose) echo "Docker Compose aliases | Built-in" ;;
        laravel) echo "Laravel artisan aliases | Built-in" ;;
        composer) echo "PHP Composer aliases | Built-in" ;;
        npm) echo "NPM command aliases | Built-in" ;;
        yarn) echo "Yarn package manager aliases | Built-in" ;;
        brew) echo "Homebrew aliases | Built-in" ;;
        sudo) echo "ESC ESC to prefix last command with sudo | Built-in" ;;
        azure) echo "Azure CLI aliases and completions | Built-in" ;;
        python) echo "Python aliases and functions | Built-in" ;;
        pip) echo "Python pip aliases | Built-in" ;;
        uv) echo "Fast Python package installer | https://github.com/astral-sh/uv" ;;
        vscode) echo "VS Code helper functions | Built-in" ;;
        zsh-autosuggestions) echo "Fish-like autosuggestions | https://github.com/zsh-users/zsh-autosuggestions" ;;
        zsh-syntax-highlighting) echo "Fish-like syntax highlighting | https://github.com/zsh-users/zsh-syntax-highlighting" ;;
        *) echo "Custom plugin" ;;
    esac
}

# Read plugins from .zshrc
read_zshrc_plugins() {
    local zshrc="$HOME/.zshrc"
    if [[ ! -f "$zshrc" ]]; then
        return 1
    fi
    
    # Extract plugins array from .zshrc
    awk '/^plugins=\(/,/^\)/ {print}' "$zshrc" | 
        grep -v '^plugins=(' | 
        grep -v '^)' | 
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | 
        grep -v '^#' | 
        grep -v '^$'
}

# Compare .zshrc plugins with config
compare_zshrc_plugins() {
    local all_config_plugins="$GIT_PLUGINS $DOCKER_PLUGINS $DEV_PLUGINS $SYSTEM_PLUGINS $AZURE_PLUGINS"
    local zshrc_plugins=()
    local config_plugins_array=()
    
    # Read plugins from .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        while IFS= read -r plugin; do
            [[ -n "$plugin" ]] && zshrc_plugins+=("$plugin")
        done < <(read_zshrc_plugins)
    fi
    
    # Convert config plugins to array
    for plugin in $all_config_plugins; do
        config_plugins_array+=("$plugin")
    done
    
    # Check for mismatches
    local in_zshrc_not_config=()
    local in_config_not_zshrc=()
    
    # Find plugins in .zshrc but not in config
    for plugin in "${zshrc_plugins[@]}"; do
        local found=0
        for config_plugin in "${config_plugins_array[@]}"; do
            if [[ "$plugin" == "$config_plugin" ]]; then
                found=1
                break
            fi
        done
        if [[ $found -eq 0 ]]; then
            in_zshrc_not_config+=("$plugin")
        fi
    done
    
    # Find plugins in config but not in .zshrc
    for plugin in "${config_plugins_array[@]}"; do
        local found=0
        for zshrc_plugin in "${zshrc_plugins[@]}"; do
            if [[ "$plugin" == "$zshrc_plugin" ]]; then
                found=1
                break
            fi
        done
        if [[ $found -eq 0 ]]; then
            in_config_not_zshrc+=("$plugin")
        fi
    done
    
    # Report findings
    if [[ ${#in_zshrc_not_config[@]} -gt 0 ]] || [[ ${#in_config_not_zshrc[@]} -gt 0 ]]; then
        echo ""
        print_warning "Plugin configuration mismatch detected!"
        echo ""
        
        if [[ ${#in_zshrc_not_config[@]} -gt 0 ]]; then
            print_info "Plugins in ~/.zshrc but NOT in config file:"
            for plugin in "${in_zshrc_not_config[@]}"; do
                echo "  - $plugin"
            done
            echo ""
        fi
        
        if [[ ${#in_config_not_zshrc[@]} -gt 0 ]]; then
            print_info "Plugins in config file but NOT in ~/.zshrc:"
            for plugin in "${in_config_not_zshrc[@]}"; do
                echo "  - $plugin"
            done
            echo ""
        fi
        
        print_info "Recommendation: Keep $CONFIG_FILE and ~/.zshrc plugins in sync"
        echo ""
    fi
}

# Generate suggested plugins array
generate_suggested_plugins() {
    local all_plugins="$GIT_PLUGINS $DOCKER_PLUGINS $DEV_PLUGINS $SYSTEM_PLUGINS $AZURE_PLUGINS"
    
    print_header "Suggested plugins=() for ~/.zshrc"
    
    echo "# Copy this to your ~/.zshrc file:"
    echo ""
    echo "plugins=("
    
    for plugin in $all_plugins; do
        local description=$(get_plugin_description "$plugin")
        printf "    %-30s # %s\n" "$plugin" "$description"
    done
    
    echo ")"
    echo ""
}

# Verify that required plugins are installed
verify_plugins() {
    local missing_plugins=()
    local all_plugins="$GIT_PLUGINS $DOCKER_PLUGINS $DEV_PLUGINS $SYSTEM_PLUGINS $AZURE_PLUGINS"
    
    print_info "Verifying Oh My Zsh plugins..."
    
    for plugin in $all_plugins; do
        local plugin_path=""
        
        # Check built-in plugins
        if [[ -d "$HOME/.oh-my-zsh/plugins/$plugin" ]]; then
            continue
        fi
        
        # Check custom plugins
        if [[ -d "$CUSTOM_DIR/plugins/$plugin" ]]; then
            continue
        fi
        
        # Plugin not found
        missing_plugins+=("$plugin")
    done
    
    if [[ ${#missing_plugins[@]} -gt 0 ]]; then
        print_error "The following plugins are not installed:"
        for plugin in "${missing_plugins[@]}"; do
            local description=$(get_plugin_description "$plugin")
            echo "  - $plugin: $description"
        done
        echo ""
        print_info "To fix this, either:"
        echo "  1. Install missing plugins (e.g., for zsh-autosuggestions):"
        echo "     git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
        echo ""
        echo "  2. Remove them from $CONFIG_FILE"
        echo ""
        exit 1
    fi
    
    print_success "All configured plugins are installed"
    
    # Compare with .zshrc
    compare_zshrc_plugins
}

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Check if Oh My Zsh is installed
check_ohmyzsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_error "Oh My Zsh is not installed. Please install it first."
        exit 1
    fi
    print_success "Oh My Zsh installation found"
}

# Backup existing files
backup_existing() {
    local file=$1
    if [[ -f "$file" ]]; then
        if [[ $DRY_RUN -eq 1 ]]; then
            print_warning "[DRY RUN] Would backup: $(basename $file)"
        else
            local backup="${file}.backup-$(date +%Y%m%d-%H%M%S)"
            cp "$file" "$backup"
            print_warning "Backed up existing file: $(basename $file) → $(basename $backup)"
        fi
    fi
    return 0
}

# Create custom directory if it doesn't exist
create_custom_dir() {
    if [[ ! -d "$CUSTOM_DIR" ]]; then
        if [[ $DRY_RUN -eq 1 ]]; then
            print_success "[DRY RUN] Would create directory: $CUSTOM_DIR"
        else
            mkdir -p "$CUSTOM_DIR"
            print_success "Created custom directory: $CUSTOM_DIR"
        fi
    else
        print_info "Custom directory already exists: $CUSTOM_DIR"
    fi
}

# Create 00-environment.zsh
create_environment_file() {
    local file="$CUSTOM_DIR/00-environment.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 00-environment.zsh"
        return 0
    fi
    
    cat > "$file" << EOF
# ============================================
# General Environment Variables
# ============================================
# Non-sensitive environment configurations

# Default editors
export EDITOR="$DEFAULT_EDITOR"
export VISUAL="$DEFAULT_EDITOR"
export BROWSER="$DEFAULT_BROWSER"

# Development preferences
export PYTHONDONTWRITEBYTECODE=1  # Prevent Python from writing .pyc files

# Locale settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Load secrets (if file exists)
[ -f "$ZSH_CUSTOM/.env.secret" ] && source "$ZSH_CUSTOM/.env.secret"
EOF
    
    print_success "Created: 00-environment.zsh"
}

# Create 01-paths.zsh
create_paths_file() {
    local file="$CUSTOM_DIR/01-paths.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 01-paths.zsh"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# ============================================
# PATH Modifications
# ============================================

# Homebrew (Apple Silicon)
if [[ -d "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Homebrew (Intel)
if [[ -d "/usr/local/bin" ]]; then
    export PATH="/usr/local/bin:$PATH"
fi

# User local bin
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Composer global packages (PHP)
if [[ -d "$HOME/.composer/vendor/bin" ]]; then
    export PATH="$HOME/.composer/vendor/bin:$PATH"
fi

# Python user base (pip install --user)
# Dynamically find the latest Python version directory
if [[ -d "$HOME/Library/Python" ]]; then
    PYTHON_USER_BIN=$(find "$HOME/Library/Python" -maxdepth 2 -name "bin" -type d 2>/dev/null | sort -V | tail -1)
    if [[ -n "$PYTHON_USER_BIN" ]]; then
        export PATH="$PYTHON_USER_BIN:$PATH"
    fi
fi
EOF
    
    print_success "Created: 01-paths.zsh"
}

# Create 10-aliases-general.zsh
create_general_aliases() {
    local file="$CUSTOM_DIR/10-aliases-general.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 10-aliases-general.zsh"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# ============================================
# General System Aliases
# ============================================

# List files
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System utilities
alias reload='source ~/.zshrc'
alias zshconfig='code ~/.zshrc'
alias ohmyzsh='code ~/.oh-my-zsh'
alias customconfig='code ~/.oh-my-zsh/custom'

# Common typos
alias sl='ls'
alias gerp='grep'
alias grpe='grep'

# Quick edits
alias hosts='sudo nano /etc/hosts'

# IP addresses
alias localip="ipconfig getifaddr en0"
alias publicip="curl -s https://api.ipify.org"

# Clipboard (macOS)
alias pbcopy='pbcopy'
alias pbpaste='pbpaste'
EOF
    
    print_success "Created: 10-aliases-general.zsh"
}

# Create 11-aliases-git.zsh
create_git_aliases() {
    local file="$CUSTOM_DIR/11-aliases-git.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 11-aliases-git.zsh"
        return 0
    fi
    
    cat > "$file" << EOF
# ============================================
# Git Aliases (Beyond Oh My Zsh defaults)
# ============================================
# Plugins: $GIT_PLUGINS
# Note: Oh My Zsh git plugin already provides many aliases
# See: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git

# Branch management
alias gcm='git checkout main || git checkout master'
alias gcd='git checkout develop'
alias gcb='git checkout -b'
alias gbd='git branch -d'
alias gbD='git branch -D'

# Enhanced operations
alias gclean='git clean -fd'
alias gpf='git push --force-with-lease'
alias gundo='git reset --soft HEAD~1'
alias gamend='git commit --amend --no-edit'

# Git log with prettier format
alias glg='git log --graph --oneline --decorate --all'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glast='git log -1 HEAD --stat'

# Quick status
alias gs='git status -sb'
alias gss='git status'

# Stash operations
alias gstl='git stash list'
alias gsta='git stash apply'
alias gstp='git stash pop'
alias gstd='git stash drop'

# Diff operations
alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff'

# Pull and rebase
alias gpr='git pull --rebase'
alias gup='git pull --rebase --autostash'

# Show files in last commit
alias changed='git diff --name-only HEAD~1'
EOF
    
    print_success "Created: 11-aliases-git.zsh"
}

# Create 12-aliases-docker.zsh
create_docker_aliases() {
    local file="$CUSTOM_DIR/12-aliases-docker.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 12-aliases-docker.zsh"
        return 0
    fi
    
    cat > "$file" << EOF
# ============================================
# Docker & Docker Compose Aliases
# ============================================
# Plugins: $DOCKER_PLUGINS

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'

# Docker cleanup
alias dclean='docker system prune -af'
alias dcleanv='docker system prune -af --volumes'
alias drmi='docker rmi $(docker images -q -f dangling=true)'
alias drmv='docker volume rm $(docker volume ls -q -f dangling=true)'

# Docker Compose shortcuts
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'
alias dcrestart='docker-compose restart'
alias dcrebuild='docker-compose up -d --build'
alias dcstop='docker-compose stop'
alias dcstart='docker-compose start'
alias dcps='docker-compose ps'

# Docker stats
alias dstats='docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"'

# Remove all stopped containers
alias drm='docker rm $(docker ps -a -q)'

# Remove all untagged images
alias drmi-untagged='docker rmi $(docker images | grep "^<none>" | awk "{print $3}")'
EOF
    
    print_success "Created: 12-aliases-docker.zsh"
}

# Create 13-aliases-azure.zsh
create_azure_aliases() {
    local file="$CUSTOM_DIR/13-aliases-azure.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 13-aliases-azure.zsh"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# ============================================
# Azure CLI Aliases
# ============================================

# Azure shortcuts
alias az='az'
alias azlogin='az login'
alias azlogout='az logout'
alias azaccount='az account show'
alias azlist='az account list --output table'
alias azset='az account set --subscription'

# Azure DevOps
alias azrepos='az repos list --output table'
alias azpipelines='az pipelines list --output table'
alias azruns='az pipelines runs list --output table'

# Azure resources
alias azgroups='az group list --output table'
alias azvms='az vm list --output table'
alias azapps='az webapp list --output table'

# Azure Kubernetes
alias azaks='az aks list --output table'
alias azakscreds='az aks get-credentials --resource-group'

# Azure Storage
alias azstorageaccounts='az storage account list --output table'

# Quick subscription switch
alias azdev='az account set --subscription "Development"'
alias azprod='az account set --subscription "Production"'
alias azstaging='az account set --subscription "Staging"'

# Note: Update subscription names above to match your organization's naming
EOF
    
    print_success "Created: 13-aliases-azure.zsh"
}

# Create 14-aliases-dev.zsh
create_dev_aliases() {
    local file="$CUSTOM_DIR/14-aliases-dev.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 14-aliases-dev.zsh"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# ============================================
# Development Tools Aliases
# ============================================

# Python
alias python='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'
alias deactivate='deactivate'
alias pipreqs='pip freeze > requirements.txt'
alias pipinstall='pip install -r requirements.txt'

# PHP
alias phpunit='vendor/bin/phpunit'
alias artisan='php artisan'
alias composer-update='composer update --no-interaction --prefer-dist --optimize-autoloader'
alias composer-install='composer install --no-interaction --prefer-dist --optimize-autoloader'

# Laravel specific
alias art='php artisan'
alias mfs='php artisan migrate:fresh --seed'
alias tinker='php artisan tinker'

# Node.js / npm
alias npmi='npm install'
alias npms='npm start'
alias npmt='npm test'
alias npmb='npm run build'
alias npmw='npm run watch'
alias npmc='npm run clean'

# Yarn
alias yi='yarn install'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yw='yarn watch'

# VS Code
alias c='code .'
alias cn='code -n'
alias co='code'

# Directory shortcuts (customize for your team's projects)
# Uncomment and modify these for your specific project structure
# alias projects='cd ~/Projects'
# alias work='cd ~/Work'
# alias repos='cd ~/Repositories'

# Quick server starts
alias serve='python3 -m http.server 8000'
alias phpserve='php -S localhost:8000'

# Database
alias dbdump='mysqldump -u root -p'
alias dbrestore='mysql -u root -p'

# SSH
alias sshconfig='code ~/.ssh/config'
EOF
    
    print_success "Created: 14-aliases-dev.zsh"
}

# Create 20-functions.zsh
create_functions_file() {
    local file="$CUSTOM_DIR/20-functions.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 20-functions.zsh"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# ============================================
# Custom Shell Functions
# ============================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick git commit with message
qcommit() {
    if [ -z "$1" ]; then
        echo "Usage: qcommit 'commit message'"
        return 1
    fi
    git add -A && git commit -m "$1" && git push
}

# Find process by name
psg() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# Create a backup of a file
backup() {
    if [ -z "$1" ]; then
        echo "Usage: backup <file>"
        return 1
    fi
    cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}

# Kill process on port (macOS/Linux)
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    lsof -ti:$1 | xargs kill -9
}

# Create a new git repository and push to GitHub
gitinit() {
    if [ -z "$1" ]; then
        echo "Usage: gitinit <repository-name>"
        return 1
    fi
    
    git init
    git add .
    git commit -m "Initial commit"
    git branch -M main
    echo "# $1" > README.md
    git add README.md
    git commit -m "Add README"
    
    echo "Repository initialized. Create a GitHub repo and run:"
    echo "git remote add origin git@github.com:yourusername/$1.git"
    echo "git push -u origin main"
}

# Update all: Homebrew, Oh My Zsh, and custom plugins
update-all() {
    echo "Updating Homebrew..."
    brew update && brew upgrade
    
    echo "\nUpdating Oh My Zsh..."
    omz update
    
    echo "\nUpdating Powerlevel10k..."
    git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
    
    echo "\nUpdating zsh-autosuggestions..."
    git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull
    
    echo "\nUpdating zsh-syntax-highlighting..."
    git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull
    
    echo "\n✓ All updates complete!"
}

# Show disk usage of current directory
dusage() {
    du -sh * | sort -h
}

# Create a new Laravel project
new-laravel() {
    if [ -z "$1" ]; then
        echo "Usage: new-laravel <project-name>"
        return 1
    fi
    composer create-project laravel/laravel "$1"
    cd "$1"
}

# Docker: Enter running container
denter() {
    if [ -z "$1" ]; then
        echo "Usage: denter <container-name-or-id>"
        return 1
    fi
    docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Docker: Stop and remove all containers
dstopall() {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
}
EOF
    
    print_success "Created: 20-functions.zsh"
}

# Create 30-completions.zsh
create_completions_file() {
    local file="$CUSTOM_DIR/30-completions.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 30-completions.zsh"
        return 0
    fi
    
    cat > "$file" << EOF
# ============================================
# Custom Completions
# ============================================

# UV Python package manager shell completion
# https://docs.astral.sh/uv/getting-started/installation/
if command -v uv >/dev/null 2>&1 && [[ "$ENABLE_UV_COMPLETION" == "true" ]]; then
    eval "$(uv generate-shell-completion zsh)"
fi

# GitHub CLI completion
if command -v gh >/dev/null 2>&1; then
    eval "$(gh completion -s zsh)"
fi

# Azure CLI completion (if not already enabled by plugin)
# if command -v az >/dev/null 2>&1; then
#     autoload -U +X bashcompinit && bashcompinit
#     source $(brew --prefix)/etc/bash_completion.d/az
# fi

# Add other custom completions here
# Example: AWS CLI
# if command -v aws_completer >/dev/null 2>&1; then
#     complete -C aws_completer aws
# fi
EOF
    
    print_success "Created: 30-completions.zsh"
}

# Create 99-local.zsh
create_local_file() {
    local file="$CUSTOM_DIR/99-local.zsh"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: 99-local.zsh"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# ============================================
# Machine-Specific Configurations
# ============================================
# This file is for configurations specific to this machine
# It's loaded last, so it can override any previous settings

# Example: Source local shell environment if it exists
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Machine-specific aliases
# alias myserver='ssh user@myserver.com'
# alias vpn='sudo openvpn --config ~/vpn/config.ovpn'

# Machine-specific environment variables
# export CUSTOM_VAR="value"

# Project-specific shortcuts for this machine
# alias client1='cd ~/Projects/Client1'
# alias client2='cd ~/Projects/Client2'

# Local development database
# export DB_HOST="localhost"
# export DB_PORT="3306"
# export DB_DATABASE="local_dev"
# export DB_USERNAME="root"
EOF
    
    print_success "Created: 99-local.zsh"
}

# Create .env.secret
create_env_secret() {
    local file="$CUSTOM_DIR/.env.secret"
    
    if [[ -f "$file" ]]; then
        print_warning ".env.secret already exists, skipping to preserve secrets"
        return
    fi
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: .env.secret (chmod 600)"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# ============================================
# Sensitive Environment Variables
# ============================================
# NEVER commit this file to version control!
# This file should be in .gitignore

# Azure credentials
# export AZURE_CLIENT_ID="your-client-id"
# export AZURE_CLIENT_SECRET="your-client-secret"
# export AZURE_TENANT_ID="your-tenant-id"

# API keys
# export GITHUB_TOKEN="your-github-token"
# export OPENAI_API_KEY="your-api-key"

# Database credentials (for local development)
# export DB_PASSWORD="local-dev-password"

# Other secrets
# export SECRET_KEY="your-secret-key"
EOF
    
    chmod 600 "$file"
    print_success "Created: .env.secret (chmod 600)"
}

# Create .gitignore
create_gitignore() {
    local file="$CUSTOM_DIR/.gitignore"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: .gitignore"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# Ignore sensitive files
.env.secret
*.secret
.env.local

# Ignore downloaded plugins (should be installed via git clone)
plugins/zsh-autosuggestions/
plugins/zsh-syntax-highlighting/

# Ignore themes (should be installed separately)
themes/powerlevel10k/

# Ignore example and cache files
example.zsh
*.zwc
*.zwc.old

# Allow specific custom files
!*.zsh
!.gitignore
!README.md
EOF
    
    print_success "Created: .gitignore"
}

# Create README for custom directory
create_readme() {
    local file="$CUSTOM_DIR/README.md"
    backup_existing "$file"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_success "[DRY RUN] Would create: README.md"
        return 0
    fi
    
    cat > "$file" << 'EOF'
# Oh My Zsh Custom Configuration

This directory contains organized custom configurations for Oh My Zsh.

## Structure

```
├── 00-environment.zsh      # Environment variables
├── 01-paths.zsh            # PATH modifications
├── 10-aliases-general.zsh  # General system aliases
├── 11-aliases-git.zsh      # Git aliases
├── 12-aliases-docker.zsh   # Docker aliases
├── 13-aliases-azure.zsh    # Azure CLI aliases
├── 14-aliases-dev.zsh      # Development tool aliases
├── 20-functions.zsh        # Custom shell functions
├── 30-completions.zsh      # Custom completions
├── 99-local.zsh            # Machine-specific configs
└── .env.secret             # Sensitive credentials (git-ignored)
```

## Usage

All `.zsh` files are automatically sourced by Oh My Zsh in alphabetical order.

### Adding New Configurations

1. **New alias**: Add to appropriate `XX-aliases-*.zsh` file
2. **New function**: Add to `20-functions.zsh`
3. **New completion**: Add to `30-completions.zsh`
4. **New environment variable**: Add to `00-environment.zsh` (non-secret) or `.env.secret` (secret)

### Disabling a Configuration

Rename the file to add `.disabled` extension:

```bash
mv 11-aliases-git.zsh 11-aliases-git.zsh.disabled
source ~/.zshrc
```

## Security

- Never commit `.env.secret` to version control
- Keep sensitive data only in `.env.secret`
- Review `.gitignore` before committing

## Team Sharing

You can version control this directory and share with your team:

```bash
git init
git add *.zsh .gitignore README.md
git commit -m "Team shell configuration"
git remote add origin git@github.com:yourcompany/zsh-config.git
git push -u origin main
```

Team members can clone and use:

```bash
git clone git@github.com:yourcompany/zsh-config.git ~/zsh-team-config
ln -s ~/zsh-team-config ~/.oh-my-zsh/custom
```
EOF
    
    print_success "Created: README.md"
}

# Show best practices
show_best_practices() {
    print_header "Shell Configuration Best Practices"
    
    echo "📋 Keep Your .zshrc Lean:"
    echo "  • Your .zshrc should primarily load Oh My Zsh and set the theme"
    echo "  • List plugins in the plugins=() array"
    echo "  • Avoid defining aliases, functions, or exports directly in .zshrc"
    echo "  • Instead, use the custom directory structure this script creates"
    echo ""
    
    echo "🔌 Plugins:"
    echo "  • Only load plugins you actually use (each adds startup time)"
    echo "  • Order doesn't matter in the plugins=() array"
    echo "  • Custom plugins go in: $CUSTOM_DIR/plugins/"
    echo "  • This script verifies plugins exist before referencing them"
    echo ""
    
    echo "⚡ Aliases vs Functions:"
    echo "  • Aliases: Simple command shortcuts (e.g., alias ll='ls -lah')"
    echo "  • Functions: More complex logic with parameters and conditionals"
    echo "  • Keep aliases in 1X-aliases-*.zsh files"
    echo "  • Keep functions in 2X-functions*.zsh files"
    echo ""
    
    echo "📁 File Organization:"
    echo "  • 00-0X: Environment variables and PATH modifications"
    echo "  • 10-1X: Aliases (general, git, docker, etc.)"
    echo "  • 20-2X: Functions (complex shell logic)"
    echo "  • 30-3X: Completions (tab-completion configs)"
    echo "  • 99: Local overrides (machine-specific, loaded last)"
    echo ""
}

# Show .zshrc vs .zprofile explanation
show_shell_config_explanation() {
    print_header "Understanding Shell Configuration Files"
    
    echo "📄 .zshrc (This is what you'll use most):"
    echo "  • Loaded for INTERACTIVE shells (when you open a terminal)"
    echo "  • Contains aliases, functions, completions, prompts"
    echo "  • Sources Oh My Zsh and custom directory files"
    echo "  • Reloaded with: source ~/.zshrc"
    echo ""
    
    echo "📄 .zprofile (Use sparingly):"
    echo "  • Loaded for LOGIN shells (initial login, SSH sessions)"
    echo "  • Runs BEFORE .zshrc"
    echo "  • Best for environment variables needed by all programs"
    echo "  • Example: PATH modifications, JAVA_HOME, etc."
    echo ""
    
    echo "💡 Best Practice:"
    echo "  • Put everything in .zshrc and the custom directory"
    echo "  • Only use .zprofile for system-wide environment setup"
    echo "  • macOS: .zprofile runs on every new terminal window"
    echo ""
}

# Summary of created files
show_summary() {
    print_header "Setup Complete!"
    
    echo "Created the following files in $CUSTOM_DIR:"
    echo ""
    echo "  Environment & Paths:"
    echo "    • 00-environment.zsh"
    echo "    • 01-paths.zsh"
    echo ""
    echo "  Aliases:"
    echo "    • 10-aliases-general.zsh"
    echo "    • 11-aliases-git.zsh"
    echo "    • 12-aliases-docker.zsh"
    echo "    • 13-aliases-azure.zsh"
    echo "    • 14-aliases-dev.zsh"
    echo ""
    echo "  Functions & Completions:"
    echo "    • 20-functions.zsh"
    echo "    • 30-completions.zsh"
    echo ""
    echo "  Local & Security:"
    echo "    • 99-local.zsh"
    echo "    • .env.secret (chmod 600)"
    echo ""
    echo "  Documentation:"
    echo "    • .gitignore"
    echo "    • README.md"
    echo ""
    
    print_info "Configuration:"
    echo "    • scripts/ohmyzsh-custom.conf (plugin whitelist & settings)"
    echo ""
    
    # Show best practices
    show_best_practices
    
    # Show shell config explanation
    show_shell_config_explanation
    
    # Generate suggested plugins array
    generate_suggested_plugins
    
    print_info "Next steps:"
    echo "  1. Review and customize the files in: $CUSTOM_DIR"
    echo "  2. Edit scripts/ohmyzsh-custom.conf to customize plugins and settings"
    echo "  3. Update your ~/.zshrc plugins=() array (see suggested array above)"
    echo "  4. Add your secrets to: $CUSTOM_DIR/.env.secret"
    echo -e "  5. 🔄 RELOAD YOUR SHELL: ${BLUE}source ~/.zshrc${NC}"
    echo "  6. (Optional) Version control: cd $CUSTOM_DIR && git init"
    echo ""
    
    print_warning "⚠ Remember to add your actual secrets to .env.secret!"
    echo ""
    echo -e "${GREEN}✓${NC} ✨ Don't forget to run: ${GREEN}source ~/.zshrc${NC}"
}

# Main execution
main() {
    # Check if script has execute permissions
    check_executable
    
    print_header "Oh My Zsh Custom Configuration Setup"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        print_warning "DRY RUN MODE - No files will be created"
    fi
    
    print_info "This script will create organized custom configuration files"
    print_info "Target directory: $CUSTOM_DIR"
    echo ""
    
    if [[ $DRY_RUN -eq 0 ]]; then
        read -p "Continue? (y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Setup cancelled"
            exit 1
        fi
    fi
    
    echo ""
    check_ohmyzsh
    create_custom_dir
    
    # Load configuration and verify plugins
    load_configuration
    verify_plugins
    
    print_header "Creating Configuration Files"
    
    create_environment_file
    create_paths_file
    create_general_aliases
    create_git_aliases
    create_docker_aliases
    create_azure_aliases
    create_dev_aliases
    create_functions_file
    create_completions_file
    create_local_file
    create_env_secret
    create_gitignore
    create_readme
    
    show_summary
}

# Run main function
main
