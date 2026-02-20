# Oh My Zsh + Powerlevel10k Setup Guide
**For macOS Tahoe (26.2) and Later**

A comprehensive guide for installing and configuring Oh My Zsh with Powerlevel10k theme, optimized for development teams working with PHP, Python, Docker, Azure, Git, iTerm2, and VS Code.

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Backup Your Current Configuration](#backup-your-current-configuration)
3. [Install Oh My Zsh](#install-oh-my-zsh)
4. [Install Powerlevel10k Theme](#install-powerlevel10k-theme)
5. [Configure Plugins](#configure-plugins)
6. [Configure Powerlevel10k](#configure-powerlevel10k)
7. [Restore Custom Configurations](#restore-custom-configurations)
8. [Security Best Practices](#security-best-practices)
9. [Verification](#verification)
10. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software
- **macOS Tahoe (26.2)** or later
- **iTerm2** (recommended) or Terminal.app
- **Homebrew** package manager
- **Git** (comes pre-installed on macOS)

### Install Homebrew (if not already installed)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install iTerm2 (if not already installed)
```bash
brew install --cask iterm2
```

---

## Backup Your Current Configuration

**⚠️ IMPORTANT: Always backup before making changes!**

### 1. Create a backup directory
```bash
mkdir -p ~/.config-backups/$(date +%Y%m%d_%H%M%S)
```

### 2. Backup your current .zshrc
```bash
cp ~/.zshrc ~/.config-backups/$(date +%Y%m%d_%H%M%S)/.zshrc.backup
```

### 3. Verify backup was created
```bash
ls -la ~/.config-backups/$(date +%Y%m%d_%H%M%S)/
```

**📝 Note:** Your current .zshrc contains:
- `compinit` initialization (Oh My Zsh will handle this)
- Local environment sourcing from `~/.local/bin/env`
- UV shell completion for Python package management

We'll integrate these after Oh My Zsh installation.

---

## Install Oh My Zsh

### 1. Verify installation source integrity

Before running the install script, verify the repository:

```bash
# Check the official repository
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | head -20
```

### 2. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**What this does:**
- Clones the repository to `~/.oh-my-zsh`
- Backs up your existing `.zshrc` to `.zshrc.pre-oh-my-zsh`
- Creates a new `.zshrc` with default Oh My Zsh configuration
- Changes your default shell to Zsh (if not already)

### 3. Verify installation

```bash
# Check Oh My Zsh version
omz version

# Check installation directory
ls -la ~/.oh-my-zsh
```

---

## Install Powerlevel10k Theme

### 1. Install recommended fonts (Meslo Nerd Font)

Powerlevel10k requires a Nerd Font for proper icon display.

```bash
# Download and install Meslo Nerd Font
# Note: The homebrew/cask-fonts tap has been deprecated
# Fonts are now available directly in homebrew-cask
brew install font-meslo-lg-nerd-font
```

### 2. Configure iTerm2 to use the font

1. Open **iTerm2 → Preferences** (⌘+,)
2. Navigate to **Profiles → Text**
3. Under **Font**, click **Change Font**
4. Select **MesloLGS NF** (or **MesloLGS Nerd Font**)
5. Set size to **12** or **13** for optimal readability
6. Close preferences

### 3. Install Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 4. Set Powerlevel10k as your theme

Edit your `.zshrc`:

```bash
nano ~/.zshrc
```

Find the line that says `ZSH_THEME="robbyrussell"` and change it to:

```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Save and exit (Ctrl+O, Enter, Ctrl+X in nano).

### 5. Reload your shell

```bash
source ~/.zshrc
```

**🎨 The Powerlevel10k configuration wizard will launch automatically.**

We'll come back to configure this after setting up plugins.

---

## Configure Plugins

### 1. Install additional plugins

Oh My Zsh comes with many built-in plugins, but we need to install two popular community plugins:

#### Install zsh-autosuggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

#### Install zsh-syntax-highlighting
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 2. Configure plugins in .zshrc

Edit your `.zshrc`:

```bash
nano ~/.zshrc
```

Find the `plugins=` line and replace it with:

```bash
plugins=(
    git
    docker
    docker-compose
    python
    pip
    azure
    vscode
    zsh-autosuggestions
    zsh-syntax-highlighting
)
```

**Plugin descriptions:**
- **git**: Provides git aliases and functions (e.g., `gst` for `git status`, `gco` for `git checkout`)
- **docker**: Docker command completions
- **docker-compose**: Docker Compose command completions
- **python**: Python-related aliases and functions
- **pip**: pip command completions
- **azure**: Azure CLI completions
- **vscode**: VS Code integration (opens files/folders with `code` command)
- **zsh-autosuggestions**: Suggests commands as you type based on history
- **zsh-syntax-highlighting**: Highlights commands in real-time (must be last)

**⚠️ Order matters:** `zsh-syntax-highlighting` should be the last plugin in the list.

---

## Configure Powerlevel10k

### 1. Run the configuration wizard

If the wizard didn't run automatically, launch it manually:

```bash
p10k configure
```

### 2. Configuration recommendations for dev teams

When going through the wizard, here are recommended choices for maximum readability:

#### **Prompt Style**
- **Lean** or **Rainbow** - Both work well for showing directory paths
- For teams with many projects, **Rainbow** style provides better visual separation

#### **Character Set**
- **Unicode** (recommended for modern terminals)

#### **Show Current Time**
- **24-hour format** (useful for logs and debugging)

#### **Prompt Separators**
- **Slanted** or **Round** (easier to read in long paths)

#### **Prompt Heads**
- **Sharp** or **Blurred** (personal preference)

#### **Prompt Tails**
- **Flat** or **Slanted**

#### **Prompt Height**
- **Two lines** (recommended for long directory paths)
  - Top line: Directory path, git branch, git status
  - Bottom line: Command input

#### **Prompt Connection**
- **Disconnected** or **Dotted** (cleaner look)

#### **Prompt Frame**
- **No frame** or **Left** (reduces clutter)

#### **Connection & Frame Color**
- **Lightest** or **Dark** (better contrast)

#### **Prompt Spacing**
- **Sparse** (more breathing room)

#### **Icons**
- **Many icons** (visual indicators for git, docker, etc.)

#### **Prompt Flow**
- **Concise** (less clutter)

#### **Enable Transient Prompt**
- **Yes** (previous commands become minimal, saving screen space)

#### **Instant Prompt Mode**
- **Verbose** (shows loading info) or **Quiet** (cleaner)

### 3. Optimize for directory path and Git branch readability

After running the wizard, edit the Powerlevel10k configuration:

```bash
nano ~/.p10k.zsh
```

Find and modify these settings for better readability:

```bash
# Show full directory path (not truncated)
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=0

# Or limit to last N directories for very long paths
# typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
# typeset -g POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"

# Git branch - make it prominent
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
typeset -g POWERLEVEL9K_VCS_FOREGROUND=76  # Bright green for visibility

# Show git status clearly
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=178
```

---

## Restore Custom Configurations

### Option 1: Automated Setup (Recommended)

We've created an automated script (`setup-ohmyzsh-custom.sh`) that sets up all the custom configuration files for you.

#### Run the setup script

**⚠️ IMPORTANT: Downloaded/copied scripts are not executable by default**

When you download or copy this script, it won't have execute permissions. You have **two options**:

**Option A: Make it executable first (recommended)**

```bash
# REQUIRED: Make the script executable
chmod +x setup-ohmyzsh-custom.sh

# Test with dry-run first (recommended)
./setup-ohmyzsh-custom.sh --dry-run

# Now run it for real
./setup-ohmyzsh-custom.sh
```

**Option B: Run with bash (no chmod needed)**

```bash
# Test with dry-run first (recommended)
bash setup-ohmyzsh-custom.sh --dry-run

# Run with bash - works without execute permission
bash setup-ohmyzsh-custom.sh

# The script will show a reminder to use chmod +x for next time
```

**If downloading from a repository:**

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/CGB37/dotfiles/main/shell/setup-ohmyzsh-custom.sh -o setup-ohmyzsh-custom.sh

# Make it executable (REQUIRED for ./ execution)
chmod +x setup-ohmyzsh-custom.sh

# Test with dry-run first
./setup-ohmyzsh-custom.sh --dry-run

# Run it for real
./setup-ohmyzsh-custom.sh
```

**What the script does:**
- ✅ Checks if Oh My Zsh is installed
- ✅ **Verifies all configured plugins are installed**
- ✅ **Compares your .zshrc plugins with the config file**
- ✅ **Warns about plugin mismatches**
- ✅ Creates all custom .zsh files with starter configurations
- ✅ Sets up proper file permissions (chmod 600 for .env.secret)
- ✅ Backs up any existing files before creating new ones
- ✅ Creates .gitignore and README.md
- ✅ **Generates a suggested plugins=() array with descriptions**
- ✅ **Provides educational output about shell configuration best practices**
- ✅ **Explains .zshrc vs .zprofile differences**
- ✅ Provides a summary of created files
- ✅ Warns you if the script isn't executable (only when run with `bash`)
- ✅ Supports `--dry-run` mode to preview changes without creating files

**The script will:**

1. **Verify all plugins listed in `ohmyzsh-custom.conf` are installed**
   - If missing, it will show installation instructions
   - Lists each plugin with description and source URL

2. **Compare your .zshrc plugins with the config file**
   - Warns if plugins are in .zshrc but not in config
   - Warns if plugins are in config but not in .zshrc
   - Helps keep configurations in sync

3. **Generate a suggested plugins=() array**
   - Ready to copy into your .zshrc
   - Includes inline comments for each plugin
   - Shows URLs for custom plugins

4. **Display best practices**
   - How to keep .zshrc lean
   - When to use plugins vs functions vs aliases
   - Explanation of .zshrc vs .zprofile
   - File organization by number prefix

After running the script, skip to step 5 below to reload your configuration.

**💡 Understanding Script Permissions (Important!)**

Shell scripts need **execute permission** to run directly with `./script.sh`:

```bash
# Without execute permission
./setup-ohmyzsh-custom.sh
# ❌ Result: "zsh: permission denied"
# The script never runs, so you see nothing

# Fix: Add execute permission FIRST
chmod +x setup-ohmyzsh-custom.sh
./setup-ohmyzsh-custom.sh
# ✅ Runs successfully
```

**Alternative: Use `bash` to run without execute permission:**

```bash
# This works without chmod +x
bash setup-ohmyzsh-custom.sh
# ✅ Runs successfully AND shows a reminder to use chmod +x
```

**Why doesn't the script just add its own execute permission?**  
Because a script without execute permission can't run to add its own permission - it's a catch-22! That's why we provide two methods: use `chmod +x` first, or use `bash script.sh` instead.

### Option 2: Manual Setup

If you prefer to create the files manually or want to understand what's being created:

### Understanding Oh My Zsh Custom Directory

Oh My Zsh automatically sources any `.zsh` files in `~/.oh-my-zsh/custom/` in **alphabetical order**. This allows you to keep your `.zshrc` clean and organize configurations by purpose.

### Recommended Custom Directory Structure

```bash
~/.oh-my-zsh/custom/
├── 00-environment.zsh      # General environment variables
├── 01-paths.zsh            # PATH modifications
├── 10-aliases-general.zsh  # General system aliases
├── 11-aliases-git.zsh      # Git-specific aliases
├── 12-aliases-docker.zsh   # Docker/Docker Compose aliases
├── 13-aliases-azure.zsh    # Azure CLI aliases
├── 14-aliases-dev.zsh      # Development tool aliases
├── 20-functions.zsh        # Custom shell functions
├── 30-completions.zsh      # Custom completions
├── 99-local.zsh            # Machine-specific overrides
└── .env.secret             # Sensitive credentials (git-ignored)
```

**Naming Convention:**
- **00-09**: Environment and PATH setup (loaded first)
- **10-19**: Aliases organized by category
- **20-29**: Functions and utilities
- **30-39**: Completions and tool integrations
- **99**: Machine-specific configs (loaded last, can override)

### 1. Create the custom configuration files

#### Create environment variables file

```bash
cat > ~/.oh-my-zsh/custom/00-environment.zsh << 'EOF'
# ============================================
# General Environment Variables
# ============================================
# Non-sensitive environment configurations

# Default editors
export EDITOR="code --wait"
export VISUAL="code --wait"

# Development preferences
export PYTHONDONTWRITEBYTECODE=1  # Prevent Python from writing .pyc files

# Locale settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
EOF
```

#### Create PATH modifications file

```bash
cat > ~/.oh-my-zsh/custom/01-paths.zsh << 'EOF'
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
```

**📝 Note about this configuration:**
- **Homebrew support**: Handles both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`) Macs
- **PHP via Homebrew**: If you installed PHP with `brew install php`, it will be in Homebrew's bin directory
- **Python via Homebrew**: If you installed Python with `brew install python`, it will be in Homebrew's bin directory  
- **Python user packages**: Automatically finds packages installed with `pip install --user` regardless of Python version (3.11, 3.12, 3.13, etc.)
- **Version agnostic**: Will work when you upgrade Python versions without manual updates

#### Create general aliases file

```bash
cat > ~/.oh-my-zsh/custom/10-aliases-general.zsh << 'EOF'
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
EOF
```

#### Create Git aliases file

```bash
cat > ~/.oh-my-zsh/custom/11-aliases-git.zsh << 'EOF'
# ============================================
# Git Aliases (Beyond Oh My Zsh defaults)
# ============================================

# Enhanced git aliases
alias gcm='git checkout main || git checkout master'
alias gcd='git checkout develop'
alias gclean='git clean -fd'
alias gpf='git push --force-with-lease'
alias gundo='git reset --soft HEAD~1'

# Git log with prettier format
alias glg='git log --graph --oneline --decorate --all'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Quick status
alias gs='git status -sb'
EOF
```

#### Create Docker aliases file

```bash
cat > ~/.oh-my-zsh/custom/12-aliases-docker.zsh << 'EOF'
# ============================================
# Docker & Docker Compose Aliases
# ============================================

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'

# Docker cleanup
alias dclean='docker system prune -af'
alias dcleanv='docker system prune -af --volumes'

# Docker Compose shortcuts
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'
alias dcrestart='docker-compose restart'
alias dcrebuild='docker-compose up -d --build'
EOF
```

#### Create Azure aliases file

```bash
cat > ~/.oh-my-zsh/custom/13-aliases-azure.zsh << 'EOF'
# ============================================
# Azure CLI Aliases
# ============================================

# Azure shortcuts
alias azlogin='az login'
alias azaccount='az account show'
alias azlist='az account list --output table'
alias azset='az account set --subscription'

# Azure DevOps
alias azrepos='az repos list --output table'
alias azpipelines='az pipelines list --output table'
EOF
```

#### Create development tools aliases file

```bash
cat > ~/.oh-my-zsh/custom/14-aliases-dev.zsh << 'EOF'
# ============================================
# Development Tools Aliases
# ============================================

# Python
alias python='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# PHP
alias phpunit='vendor/bin/phpunit'
alias artisan='php artisan'
alias composer-update='composer update --no-interaction --prefer-dist --optimize-autoloader'

# VS Code
alias c='code .'
alias cn='code -n'

# Directory shortcuts (customize for your team's projects)
# alias projects='cd ~/Projects'
# alias work='cd ~/Work'
EOF
```

#### Create custom functions file

```bash
cat > ~/.oh-my-zsh/custom/20-functions.zsh << 'EOF'
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
    git add -A && git commit -m "$1" && git push
}

# Find process by name
psg() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# Create a backup of a file
backup() {
    cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}
EOF
```

#### Create completions file

```bash
cat > ~/.oh-my-zsh/custom/30-completions.zsh << 'EOF'
# ============================================
# Custom Completions
# ============================================

# UV Python package manager shell completion
# https://docs.astral.sh/uv/getting-started/installation/
if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion zsh)"
fi

# Add other custom completions here
# Example: AWS CLI
# if command -v aws_completer >/dev/null 2>&1; then
#     complete -C aws_completer aws
# fi
EOF
```

#### Create machine-specific overrides file

```bash
cat > ~/.oh-my-zsh/custom/99-local.zsh << 'EOF'
# ============================================
# Machine-Specific Configurations
# ============================================
# This file is for configurations specific to this machine
# It's loaded last, so it can override any previous settings

# Example: Source local shell environment if it exists
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Machine-specific aliases
# alias myserver='ssh user@myserver.com'

# Machine-specific environment variables
# export CUSTOM_VAR="value"
EOF
```

### 2. Create secure secrets file

```bash
# Create secrets file with restricted permissions
touch ~/.oh-my-zsh/custom/.env.secret
chmod 600 ~/.oh-my-zsh/custom/.env.secret
```

Add your sensitive credentials to `.env.secret`:

```bash
# Example content for ~/.oh-my-zsh/custom/.env.secret
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
export AZURE_TENANT_ID="your-tenant-id"
export GITHUB_TOKEN="your-github-token"
export OPENAI_API_KEY="your-api-key"
```

Then source it from `00-environment.zsh`:

```bash
echo '' >> ~/.oh-my-zsh/custom/00-environment.zsh
echo '# Load secrets (if file exists)' >> ~/.oh-my-zsh/custom/00-environment.zsh
echo '[ -f "$ZSH_CUSTOM/.env.secret" ] && source "$ZSH_CUSTOM/.env.secret"' >> ~/.oh-my-zsh/custom/00-environment.zsh
```

### 3. Update .zshrc to be minimal

Your `.zshrc` should now be very clean and only contain Oh My Zsh configuration:

```bash
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    docker
    docker-compose
    python
    pip
    azure
    vscode
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

**That's it!** All custom configurations are now in the `custom/` directory and automatically loaded.

### 4. Version control your custom directory

Create a `.gitignore` in the custom directory:

```bash
cat > ~/.oh-my-zsh/custom/.gitignore << 'EOF'
# Ignore sensitive files
.env.secret
*.secret

# Ignore downloaded plugins (they should be installed via git clone)
plugins/zsh-autosuggestions/
plugins/zsh-syntax-highlighting/

# Ignore themes (they should be installed separately)
themes/powerlevel10k/

# Allow specific custom files
!*.zsh
!.gitignore
EOF
```

Now you can version control your custom configurations:

```bash
cd ~/.oh-my-zsh/custom
git init
git add .
git commit -m "Initial custom oh-my-zsh configuration"
# Optionally push to a private repo
```

### 5. Reload your configuration

### 5. Reload your configuration

```bash
source ~/.zshrc
```

Or simply close and reopen your terminal.

### 6. Verify custom configurations loaded

```bash
# Check if custom files are being sourced
echo "Custom configs loaded successfully"

# Test an alias from 10-aliases-general.zsh
ll

# Test a function from 20-functions.zsh
type mkcd

# Check if environment variables are set
echo $EDITOR
```

### Benefits of This Approach

✅ **Clean .zshrc** - Only Oh My Zsh core configuration  
✅ **Organized** - Easy to find and edit specific configurations  
✅ **Portable** - Can version control and share with team  
✅ **Secure** - Secrets kept separate and git-ignored  
✅ **Maintainable** - Load order controlled via numeric prefixes  
✅ **Flexible** - Easy to enable/disable configs by renaming files  
✅ **Team-friendly** - Colleagues can use same structure

---

## Security Best Practices

### 1. Environment Variables and Secrets

**❌ NEVER store secrets directly in `.zshrc` or custom `.zsh` files**

Use the secure secrets file we created in the custom directory:

**Location:** `~/.oh-my-zsh/custom/.env.secret`

Add sensitive variables to this file:

```bash
# Edit the secrets file
nano ~/.oh-my-zsh/custom/.env.secret
```

Example content:

```bash
# Azure credentials
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
export AZURE_TENANT_ID="your-tenant-id"

# API keys
export GITHUB_TOKEN="your-github-token"
export OPENAI_API_KEY="your-api-key"

# Database credentials (for local development only)
export DB_PASSWORD="local-dev-password"
```

**Ensure proper permissions:**

```bash
chmod 600 ~/.oh-my-zsh/custom/.env.secret
```

This file is already being sourced from `00-environment.zsh`, so changes take effect after reloading your shell.

### 2. Version control your custom configurations

If you version control your dotfiles, ensure sensitive files are ignored:

```bash
# The custom directory already has a .gitignore created earlier
# Verify it's set up correctly
cat ~/.oh-my-zsh/custom/.gitignore
```

Should contain:

```
# Ignore sensitive files
.env.secret
*.secret

# Ignore downloaded plugins
plugins/zsh-autosuggestions/
plugins/zsh-syntax-highlighting/

# Ignore themes
themes/powerlevel10k/

# Allow specific custom files
!*.zsh
!.gitignore
```

If you want a global gitignore for all repositories:

```bash
cat > ~/.gitignore_global << 'EOF'
# Environment files with secrets
.env.secret
.env.local
*.secret
*_secret

# SSH keys
id_rsa
id_ed25519
*.pem

# Azure
.azure/

# VS Code workspace
.vscode/settings.json
EOF

# Configure git to use it
git config --global core.excludesfile ~/.gitignore_global
```

### 3. File permissions

Ensure proper permissions on sensitive files:

```bash
# Your .zshrc should be readable only by you
chmod 600 ~/.zshrc
chmod 600 ~/.env.secret
chmod 600 ~/.ssh/id_*
```

### 4. Plugin security

Only install plugins from trusted sources:

- ✅ Official Oh My Zsh plugins (built-in)
- ✅ Well-maintained community plugins with many stars/contributors
- ✅ Plugins from verified organizations (zsh-users)
- ❌ Avoid unknown or poorly maintained plugins

### 5. Regular updates

Keep your tools updated for security patches:

```bash
# Update Oh My Zsh
omz update

# Update Powerlevel10k
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

# Update plugins
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull

# Update Homebrew and packages
brew update && brew upgrade
```

**💡 Tip:** Add this to your calendar as a monthly task.

### 6. Shell history security

Prevent sensitive commands from being saved to history:

Add to your `.zshrc`:

```bash
# Don't save commands that start with a space
setopt HIST_IGNORE_SPACE

# Usage: Prefix sensitive commands with a space
#  aws configure  # This won't be saved to history
```

---

## Verification

### 1. Verify Oh My Zsh installation

```bash
# Check version
omz version

# List installed plugins
omz plugin list

# Check theme
echo $ZSH_THEME
```

### 2. Verify Powerlevel10k

```bash
# Check if Powerlevel10k is loaded
echo $POWERLEVEL9K_MODE

# Test prompt rendering
p10k configure
```

### 3. Test plugins

```bash
# Git plugin - try git aliases
gst  # Should show git status

# Docker plugin - test autocompletion
docker <TAB>  # Should show completions

# Python plugin - test autocompletion
python<TAB>  # Should show python, python3, etc.

# Azure plugin - test autocompletion
az <TAB>  # Should show az commands

# VS Code plugin
code .  # Should open current directory in VS Code

# Autosuggestions - type a previous command
# You should see gray suggestions appear as you type

# Syntax highlighting - type a command
# Valid commands should appear in green, invalid in red
```

### 4. Verify custom configurations

```bash
# Check custom directory structure
ls -la ~/.oh-my-zsh/custom/*.zsh

# Test general aliases
ll  # Should list files in long format
..  # Should go up one directory

# Test git aliases
gs  # Should show git status in short format

# Test docker aliases
dps  # Should show docker ps

# Test custom functions
type mkcd  # Should show the function definition
type extract  # Should show the function definition

# Test environment variables
echo $EDITOR  # Should show 'code --wait'

# Check if uv completion is loaded (if uv is installed)
uv --help | head -1
```

---

## Troubleshooting

### Fonts not displaying correctly

**Problem:** Icons appear as squares or question marks

**Solution:**
1. Ensure you installed the Nerd Font: `brew install --cask font-meslo-lg-nerd-font`
2. Restart iTerm2 completely
3. Verify font in iTerm2: Preferences → Profiles → Text → Font = "MesloLGS NF"
4. Run `p10k configure` again

### Plugins not working

**Problem:** Plugin commands or completions don't work

**Solution:**
```bash
# Reload completions
rm -f ~/.zcompdump*
exec zsh

# Or rebuild completions
omz reload
```

### Slow shell startup

**Problem:** Shell takes a long time to open

**Solution:**
1. Enable Powerlevel10k instant prompt (if not already enabled)
2. Remove unnecessary plugins
3. Profile your startup time:
```bash
# Add to top of .zshrc for testing
zmodload zsh/zprof

# Add to bottom of .zshrc
zprof
```

### Git status slow in large repositories

**Problem:** Prompt is slow when in large Git repos

**Solution:**
Edit `~/.p10k.zsh` and add:

```bash
# Disable git status in large repos
typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=4096
```

### Colors look wrong

**Problem:** Colors don't match expected appearance

**Solution:**
1. Check iTerm2 color scheme: Preferences → Profiles → Colors
2. Try a different color preset (e.g., "Solarized Dark" or "Tango Dark")
3. Restart iTerm2

### Permission denied errors

**Problem:** Cannot execute certain commands

**Solution:**
```bash
# Fix .zshrc permissions
chmod 644 ~/.zshrc

# Fix Oh My Zsh directory permissions
chmod -R 755 ~/.oh-my-zsh
```

### Setup script won't run

**Problem:** `./setup-ohmyzsh-custom.sh` shows "Permission denied"

```bash
❯ ./setup-ohmyzsh-custom.sh
zsh: permission denied: ./setup-ohmyzsh-custom.sh
```

**Root cause:** Downloaded/copied scripts don't have execute permission by default.

**Solution Option 1 - Add execute permission (recommended):**
```bash
# Make it executable
chmod +x setup-ohmyzsh-custom.sh

# Now run it
./setup-ohmyzsh-custom.sh
```

**Solution Option 2 - Run with bash (no chmod needed):**
```bash
# This works without execute permission
bash setup-ohmyzsh-custom.sh

# The script will show a reminder to use chmod +x for future use
```

**Why can't the script detect and fix its own permissions?**  
Because a script without execute permission can't run in the first place - it's a catch-22. The `check_executable()` function inside the script only works when you run it with `bash`, not with `./`

---

## Quick Reference: Custom Directory

### Directory Structure
```
~/.oh-my-zsh/custom/
├── 00-environment.zsh      # Environment variables
├── 01-paths.zsh            # PATH modifications  
├── 10-aliases-general.zsh  # General aliases
├── 11-aliases-git.zsh      # Git aliases
├── 12-aliases-docker.zsh   # Docker aliases
├── 13-aliases-azure.zsh    # Azure aliases
├── 14-aliases-dev.zsh      # Development aliases
├── 20-functions.zsh        # Shell functions
├── 30-completions.zsh      # Custom completions
├── 99-local.zsh            # Machine-specific configs
└── .env.secret             # Sensitive credentials
```

### How to Add New Configurations

1. **New alias:** Add to appropriate `XX-aliases-*.zsh` file
2. **New function:** Add to `20-functions.zsh`
3. **New completion:** Add to `30-completions.zsh`
4. **New environment variable (non-secret):** Add to `00-environment.zsh`
5. **New secret:** Add to `.env.secret`

### How to Disable a Configuration

Rename the file to add `.disabled` extension:

```bash
# Disable git aliases
mv ~/.oh-my-zsh/custom/11-aliases-git.zsh ~/.oh-my-zsh/custom/11-aliases-git.zsh.disabled

# Reload shell
source ~/.zshrc
```

### How to Share Configurations with Team

```bash
# Initialize git repo in custom directory (if not already done)
cd ~/.oh-my-zsh/custom
git init
git add *.zsh .gitignore
git commit -m "Team shell configuration"

# Push to private company repo
git remote add origin git@github.com:yourcompany/zsh-config.git
git push -u origin main
```

Team members can then clone and symlink:

```bash
# Clone team config
git clone git@github.com:yourcompany/zsh-config.git ~/zsh-team-config

# Backup existing custom directory
mv ~/.oh-my-zsh/custom ~/.oh-my-zsh/custom.backup

# Symlink team config
ln -s ~/zsh-team-config ~/.oh-my-zsh/custom

# Create personal .env.secret
touch ~/.oh-my-zsh/custom/.env.secret
chmod 600 ~/.oh-my-zsh/custom/.env.secret
```

---

## Additional Resources

### Documentation
- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh Plugins List](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)

### Useful Git Aliases (provided by git plugin)

Common aliases you can now use:
- `gst` - `git status`
- `ga` - `git add`
- `gcmsg` - `git commit -m`
- `gp` - `git push`
- `gl` - `git pull`
- `gco` - `git checkout`
- `gcb` - `git checkout -b`
- `gba` - `git branch -a`
- `glg` - `git log --stat`
- `gd` - `git diff`

Full list: Run `alias | grep git` to see all git aliases

### Recommended Additional Plugins

Consider adding these plugins as your workflow evolves:

- **`aws`** - AWS CLI completions (if you use AWS in addition to Azure)
- **`kubectl`** - Kubernetes completions
- **`terraform`** - Terraform completions
- **`composer`** - PHP Composer completions
- **`npm`** - NPM completions
- **`yarn`** - Yarn completions

---

## Maintenance

### Update all components monthly

```bash
# Update Oh My Zsh
omz update

# Update Powerlevel10k
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

# Update plugins
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull
```

### Backup your configuration

```bash
# Backup .zshrc and Powerlevel10k config
cp ~/.zshrc ~/Dropbox/.zshrc.backup  # Or your preferred cloud storage
cp ~/.p10k.zsh ~/Dropbox/.p10k.zsh.backup
```

---

## Summary

You now have a powerful, developer-optimized shell environment with:

✅ **Oh My Zsh** - Framework for managing Zsh configuration  
✅ **Powerlevel10k** - Fast, customizable prompt with excellent Git integration  
✅ **Essential plugins** - Git, Docker, Python, Azure, VS Code, and more  
✅ **Smart autocompletion** - Context-aware suggestions and syntax highlighting  
✅ **Organized custom configs** - Clean .zshrc with modular custom directory  
✅ **Security best practices** - Proper secret management and file permissions  
✅ **Highly readable prompts** - Optimized for teams with many projects  
✅ **Team-shareable** - Version-controlled custom configurations

**Next steps:**
1. Customize aliases and functions in `~/.oh-my-zsh/custom/` for your workflow
2. Add team-specific configurations to custom directory
3. Share custom directory with team via private git repository
4. Explore additional Oh My Zsh plugins as needed

---

**Created:** 2026-01-31  
**macOS Version:** Tahoe (26.2)  
**Guide Version:** 1.0

---

## License

This guide is provided as-is for educational and professional use. Feel free to modify and share with your team.
