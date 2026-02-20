# Oh My Zsh Setup Project - AI Coding Agent Instructions

## Project Overview

This is a **shell configuration automation project** that creates an organized, team-shareable Oh My Zsh custom configuration structure. The main artifact is `setup-ohmyzsh-custom.sh`, which generates 12+ modular configuration files in `~/.oh-my-zsh/custom/`.

**Target users:** Development teams using macOS, working with PHP/Laravel, Python, Docker, Azure, Git, VS Code.

**Platform:** This repository targets macOS. Examples, commands, and paths (Homebrew, `ipconfig getifaddr en0`, `lsof`) assume macOS; do not run the setup script unmodified on Windows. Linux may work with adjustments, but verify paths first.

## Architecture & Structure

### Numbered File Naming Convention (Critical Pattern)

All generated config files use **numeric prefixes** (00-99) to control Oh My Zsh loading order:
- `00-XX`: Environment setup (variables, paths)  
- `10-XX`: Aliases (general, git, docker, azure, dev)  
- `20-XX`: Functions  
- `30-XX`: Completions  
- `99-XX`: Local overrides

**Why this matters:** Oh My Zsh loads `.zsh` files alphabetically. Paths must load before aliases that depend on them; local configs should override earlier settings.

### File Generation Pattern

The script uses here-documents (`cat > "$file" << 'EOF'`) to generate each config file. Key aspects:
- Always call `backup_existing "$file"` before creating
- Use **single-quoted EOF** (`'EOF'`) to prevent variable expansion in generated files
- Generated files contain literal `$HOME`, `$ZSH_CUSTOM` that evaluate at runtime

Example:
```bash
create_environment_file() {
    local file="$CUSTOM_DIR/00-environment.zsh"
    backup_existing "$file"
    
    cat > "$file" << 'EOF'
export EDITOR="code --wait"
[ -f "$ZSH_CUSTOM/.env.secret" ] && source "$ZSH_CUSTOM/.env.secret"
EOF
    
    print_success "Created: 00-environment.zsh"
}
```

## Key Development Workflows

### Testing the Script

**CRITICAL:** The script modifies user's actual `~/.oh-my-zsh/custom/` directory. Always test with:

```bash
# Make executable (required first time)
chmod +x scripts/setup-ohmyzsh-custom.sh

# Run from scripts directory
cd scripts
./setup-ohmyzsh-custom.sh
```

**Do NOT** use `bash setup-ohmyzsh-custom.sh` for testing—it bypasses the executable check feature.

### Verification Commands

After running the script:
```bash
# List created files
ls -la ~/.oh-my-zsh/custom/*.zsh

# Check .env.secret permissions (must be 600)
ls -l ~/.oh-my-zsh/custom/.env.secret

# Test loading
source ~/.zshrc
```

### Adding New Generated Files

When adding a new config file to the script:

1. Create a `create_XXX_file()` function following the pattern
2. Add the function call to `main()` in alphabetical order
3. Update `show_summary()` to list the new file
4. Add corresponding section to `scripts/SCRIPT-README.md`

## Project-Specific Conventions

### Color Output System

Uses ANSI escape codes with semantic functions:
```bash
print_success "Message"  # Green ✓
print_error "Message"    # Red ✗
print_warning "Message"  # Yellow ⚠
print_info "Message"     # Blue ℹ
print_header "Title"     # Blue with separator lines
```

Always use these instead of raw `echo` for user-facing messages.

### Backup Strategy

The `backup_existing()` function creates timestamped backups:
```bash
backup_existing "$file"  # Creates file.backup-20260131-143052
```

This runs automatically before every file creation. Don't skip it.

### Security Patterns

- `.env.secret` gets `chmod 600` immediately after creation
- All secret examples are commented out with `#`
- `.gitignore` explicitly excludes `.env.secret` and `*.secret`
- Main script includes `set -e` to exit on errors

## Common Development Tasks

### Modifying Generated Aliases

To add new aliases to a category (e.g., Docker):
1. Edit the heredoc in `create_docker_aliases()`
2. Maintain the comment structure for readability
3. Group related aliases together
4. Test by running script and checking generated file

### Extending for New Tools

To add support for a new tool (e.g., Terraform):

1. Create `create_terraform_aliases()` function with number prefix (e.g., 15)
2. Generate `15-aliases-terraform.zsh`
3. Add to `main()`, `show_summary()`, and documentation
4. Follow existing alias naming patterns from other files

### Documentation Updates

Keep synchronized:
- `scripts/SCRIPT-README.md` - Quick start guide
- `docs/oh-my-zsh-powerlevel10k-setup-guide.md` - Comprehensive setup
- Generated `README.md` in custom directory

## Integration Points

### UV Python Package Manager

The `30-completions.zsh` template includes UV completion detection:
```bash
if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion zsh)"
fi
```

Pattern: Check command existence before generating completions.

### External Local Environment

The `99-local.zsh` template sources `~/.local/bin/env`:
```bash
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
```

This allows integration with external tools without modifying versioned configs.

### Powerlevel10k Theme

Documentation references Powerlevel10k but the script doesn't install it—this is deliberate. The script focuses on **custom config structure**, not theme installation.

### Plugin Management (Important)

This project separates configuration generation from plugin/theme installation. The `setup-ohmyzsh-custom.sh` script creates modular config files only; installing external plugins and themes is handled separately so teams can manage those repos independently.

Common pattern (macOS): clone plugins/themes into `${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}`.

Examples:

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Notes:

- The `update-all()` helper in `20-functions.zsh` expects plugins/themes to exist under `${ZSH_CUSTOM}` and performs `git -C` pulls into those directories.
- Keep plugin installation separate from generated configurations so plugin updates and management remain explicit.

## Dependencies & Assumptions

- **Oh My Zsh must be pre-installed** (script checks with `check_ohmyzsh()`)
- Custom directory path: `${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}`
- macOS-specific commands: `lsof`, `ipconfig getifaddr en0`
- Homebrew paths: `/opt/homebrew/bin` (Apple Silicon), `/usr/local/bin` (Intel)

## Common Pitfalls

1. **Forgetting single quotes on EOF**: Using `<< EOF` instead of `<< 'EOF'` causes premature variable expansion
2. **Not making script executable**: Users often forget `chmod +x`, so script has a friendly notice
3. **Overwriting secrets**: `create_env_secret()` skips if file exists to preserve user secrets
4. **Path ordering**: Adding a new `0X-` file can break if paths load after aliases that need them

## Editing Guidelines

- **Preserve backwards compatibility**: Users have existing custom directories
- **Maintain alphabetical loading**: Respect the numeric prefix system
- **Test actual shell loading**: Changes must work in a real Zsh session, not just as text files
- **Keep examples commented**: Generated files should be safe to use as-is without exposing secrets
