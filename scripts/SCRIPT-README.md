# Oh My Zsh Custom Configuration Setup

Quick setup script to create organized Oh My Zsh custom configuration files.

## Quick Start

### Step 1: Make the script executable

**Required first step:**

```bash
chmod +x setup-ohmyzsh-custom.sh
```

### Step 2: Test with dry-run (optional but recommended)

```bash
./setup-ohmyzsh-custom.sh --dry-run
```

This shows what would be created without making any changes.

### Step 3: Run the script

```bash
./setup-ohmyzsh-custom.sh
```

## Alternative Method (No chmod needed)

If you get "permission denied", you can run it with bash:

```bash
# Test first with dry-run
bash setup-ohmyzsh-custom.sh --dry-run

# Then run for real
bash setup-ohmyzsh-custom.sh
```

## Common Error

```bash
❯ ./setup-ohmyzsh-custom.sh
zsh: permission denied: ./setup-ohmyzsh-custom.sh
```

**Solution:** Run `chmod +x setup-ohmyzsh-custom.sh` first, then try again.

## Options

### `--dry-run`

Simulate the script without creating any files. Perfect for:
- Previewing what will be created
- Testing the script safely
- Reviewing the file structure before committing

```bash
./setup-ohmyzsh-custom.sh --dry-run
```

In dry-run mode:
- No files or directories are created
- No confirmation prompt is shown
- All operations show `[DRY RUN]` prefix
- Exit codes and error checking work normally

## What This Script Does

### 1. Verifies Your Environment

- ✅ Checks Oh My Zsh is installed
- ✅ Verifies all configured plugins exist
- ✅ Compares your .zshrc plugins with config file
- ⚠️ Warns about mismatches between .zshrc and config

### 2. Creates Organized Config Files

```
~/.oh-my-zsh/custom/
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
├── .env.secret             # Sensitive credentials (chmod 600)
├── .gitignore              # Git ignore rules
└── README.md               # Documentation
```

### 3. Provides Educational Output

- 📚 Explains each plugin with descriptions and URLs
- 📋 Shows best practices for .zshrc organization
- 🔄 Describes .zshrc vs .zprofile differences
- 📝 Generates ready-to-copy plugins=() array
- ⚡ Tips on keeping shell startup fast

## What You'll See

The script provides comprehensive output including:

### Plugin Verification
```
ℹ Verifying Oh My Zsh plugins...
✓ All configured plugins are installed
```

If plugins are missing:
```
✗ The following plugins are not installed:
  - zsh-autosuggestions: Fish-like autosuggestions | https://github.com/zsh-users/zsh-autosuggestions
  
  To fix this, either:
  1. Install missing plugins (instructions provided)
  2. Remove them from scripts/ohmyzsh-custom.conf
```

### Plugin Comparison

Compares your .zshrc with the config file:
```
⚠ Plugin configuration mismatch detected!

ℹ Plugins in ~/.zshrc but NOT in config file:
  - some-plugin
  
ℹ Plugins in config file but NOT in ~/.zshrc:
  - another-plugin
```

### Suggested Plugins Array

Generates a ready-to-copy plugins array:
```bash
plugins=(
    git                            # Git aliases and functions | Built-in
    docker                         # Docker aliases and completions | Built-in
    zsh-autosuggestions           # Fish-like autosuggestions | https://github.com/...
    zsh-syntax-highlighting       # Fish-like syntax highlighting | https://github.com/...
)
```

### Best Practices Guide

Shows comprehensive tips on:
- Keeping .zshrc lean
- When to use plugins vs functions vs aliases
- File organization by number prefix
- .zshrc vs .zprofile differences

## After Running

**IMPORTANT:** Reload your shell to apply changes:

```bash
source ~/.zshrc
```

The script will remind you multiple times to do this!

## Documentation

See [oh-my-zsh-setup-guide.md](oh-my-zsh-setup-guide.md) for complete installation instructions and configuration details.
