#!/bin/bash
#
# Automated Dotfiles Installation Script
#
# This script sets up a complete development environment with:
# - Neovim with LazyVim
# - LSP servers for Rust, JS/TS, Go, C/C++, HTML/CSS
# - Modern CLI tools (ripgrep, fd, bat, eza, fzf, delta)
# - Git tools (gh, lazygit)
# - Tmux with TPM
# - All dotfile symlinks
#
# Supports: Debian/Ubuntu, macOS, WSL
#
# Usage: ./install.sh [options]
#   --minimal    Install only core dotfiles and neovim
#   --force      Reinstall everything, even if already present
#   --help       Show this help message
#

# Configuration
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
export LOG_FILE="$HOME/.dotfiles-install.log"
MINIMAL=false
FORCE=false

# Ensure scripts directory exists
mkdir -p "$SCRIPTS_DIR"

# Source common functions (auto-detects OS)
source "$SCRIPTS_DIR/common.sh"

# Export variables for sub-scripts
export FORCE
export MINIMAL

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --minimal)
            MINIMAL=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help)
            grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //'
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log_error "This script should NOT be run as root (don't use sudo)"
    log_info "The script will prompt for sudo password when needed"
    exit 1
fi

# ============================================
# Step runner with error tracking
# ============================================

STEP_SUCCESSES=()
STEP_FAILURES=()

run_step() {
    local script="$1"
    local label="$2"
    local critical="${3:-false}"

    if [[ ! -f "$script" ]]; then
        log_warn "Script not found: $script"
        STEP_FAILURES+=("$label (script missing)")
        if [[ "$critical" == "true" ]]; then
            fatal "$label script is missing"
        fi
        return 1
    fi

    log "Running: $label..."
    if bash "$script"; then
        STEP_SUCCESSES+=("$label")
    else
        STEP_FAILURES+=("$label")
        if [[ "$critical" == "true" ]]; then
            fatal "$label failed (critical step)"
        else
            log_warn "$label had errors (non-critical, continuing)"
        fi
        return 1
    fi
}

print_summary() {
    echo ""
    echo "========================================="
    echo " Installation Summary"
    echo "========================================="
    if [[ ${#STEP_SUCCESSES[@]} -gt 0 ]]; then
        echo ""
        echo " Succeeded:"
        for item in "${STEP_SUCCESSES[@]}"; do
            echo "   ✓ $item"
        done
    fi
    if [[ ${#STEP_FAILURES[@]} -gt 0 ]]; then
        echo ""
        echo " Failed:"
        for item in "${STEP_FAILURES[@]}"; do
            echo "   ✗ $item"
        done
        echo ""
        echo " Re-run ./install.sh to retry failed steps."
    fi
    echo "========================================="
}

# ============================================
# Start installation
# ============================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║             Automated Dotfiles Installation                ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Initialize log
echo "Installation started at $(date)" > "$LOG_FILE"

log_info "Detected OS: $OS ${OS_VERSION:-}"
if [[ "$IS_WSL" == true ]]; then
    log_info "Running in WSL"
fi
log_info "Package manager: $PKG_MANAGER"

# Ensure Homebrew on macOS (critical dependency)
if [[ "$OS" == "macos" ]]; then
    ensure_brew || fatal "Homebrew is required on macOS but could not be installed."
fi

# Backup existing configs
if [[ "$FORCE" == true ]] || [[ ! -d "$HOME/.dotfiles-backups" ]]; then
    log "Creating backup of existing configurations..."
    if [[ -f "$DOTFILES_DIR/.claude/skills/backup-and-restore/backup.sh" ]]; then
        "$DOTFILES_DIR/.claude/skills/backup-and-restore/backup.sh" "pre-install-$(date +%Y%m%d-%H%M%S)" || true
    fi
fi

# ============================================
# Run installation scripts in order
# ============================================

log "Starting installation process..."
echo ""

# 1. System dependencies (critical)
run_step "$SCRIPTS_DIR/install-deps.sh" "System dependencies" true

# 2. Neovim (critical)
run_step "$SCRIPTS_DIR/install-neovim.sh" "Neovim" true

# 3. Node.js via fnm (critical — needed for LSP servers)
run_step "$SCRIPTS_DIR/install-node.sh" "Node.js (fnm)" true

# Source fnm in current session so npm is available for later steps
if [[ -d "$HOME/.local/share/fnm" ]]; then
    export FNM_DIR="$HOME/.local/share/fnm"
    export PATH="$FNM_DIR:$PATH"
    eval "$(fnm env --use-on-cd 2>/dev/null)" || true
fi
# Also check brew-installed fnm on macOS
if [[ "$OS" == "macos" ]] && command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd 2>/dev/null)" || true
fi

# 4. Rust (optional — nice to have, not blocking)
run_step "$SCRIPTS_DIR/install-rust.sh" "Rust" false

# Source cargo env so cargo is available for later steps
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# 5. Go (optional)
run_step "$SCRIPTS_DIR/install-go.sh" "Go" false

# Source Go paths for current session
if [[ "$OS" == "macos" ]] && command -v go &> /dev/null; then
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOBIN:$PATH"
elif [ -d "/usr/local/go/bin" ] && /usr/local/go/bin/go version &>/dev/null; then
    export PATH="/usr/local/go/bin:$PATH"
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOBIN:$PATH"
fi

# 6. Create symlinks (critical)
run_step "$SCRIPTS_DIR/create-symlinks.sh" "Dotfile symlinks" true

# Only install optional tools if not minimal install
if [[ "$MINIMAL" == false ]]; then
    # 7. LSP servers
    run_step "$SCRIPTS_DIR/install-lsp-servers.sh" "LSP servers" false

    # 8. Formatters
    run_step "$SCRIPTS_DIR/install-formatters.sh" "Formatters" false

    # 9. Modern CLI tools
    run_step "$SCRIPTS_DIR/install-cli-tools.sh" "CLI tools" false

    # 10. Git tools
    run_step "$SCRIPTS_DIR/install-git-tools.sh" "Git tools" false

    # 11. Nerd Fonts
    run_step "$SCRIPTS_DIR/install-fonts.sh" "Nerd Fonts" false

    # 12. Tmux Plugin Manager (TPM)
    run_step "$SCRIPTS_DIR/install-tmux-plugins.sh" "Tmux plugins" false
fi

# ============================================
# Final setup
# ============================================

log "Running final setup steps..."

# Install vim-plug for legacy vim (if vim directory exists)
if [[ -d "$DOTFILES_DIR/vim" ]]; then
    if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
        log_info "Installing vim-plug for legacy vim..."
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || true
    fi

    # Install vim plugins if vim-plug is available
    if [[ -f "$HOME/.vim/autoload/plug.vim" ]] && command -v vim &> /dev/null; then
        log_info "Installing vim plugins..."
        mkdir -p "$HOME/.vim/tmp"
        vim -es -u "$HOME/.vimrc" +PlugInstall +qall 2>/dev/null || true
    fi
fi

# Make backup/restore scripts executable
chmod +x "$DOTFILES_DIR/.claude/skills/backup-and-restore"/*.sh 2>/dev/null || true

# Print summary
print_summary

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║                ✓ Installation Complete!                    ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

log "Installation completed!"
echo ""
log "Setting up Neovim plugins (this will install LazyVim and all plugins)..."
echo ""

# Launch neovim headless to install all plugins automatically
if command -v nvim &> /dev/null; then
    # Clean up markdown-preview.nvim to ensure fresh build
    MARKDOWN_PREVIEW_DIR="$HOME/.local/share/nvim/lazy/markdown-preview.nvim"
    if [ -d "$MARKDOWN_PREVIEW_DIR" ]; then
        log_info "Cleaning existing markdown-preview.nvim installation..."
        rm -rf "$MARKDOWN_PREVIEW_DIR"
    fi

    log_info "Installing Neovim plugins (this may take 2-3 minutes)..."
    nvim --headless "+Lazy! sync" +qa 2>&1 | tee -a "$LOG_FILE" | grep -E "(Installing|Cloning|✓)" || true

    # Build markdown-preview explicitly to ensure it's ready
    log_info "Building markdown-preview.nvim..."
    nvim --headless "+Lazy build markdown-preview.nvim" +qa 2>&1 | tee -a "$LOG_FILE" || true

    log "✓ Neovim plugins installed and configured"
else
    log_warn "Neovim not found in PATH, skipping plugin installation"
fi

echo ""
echo "Next steps:"
echo "  1. Reload your shell:"
echo -e "     ${BLUE}source ~/.bashrc${NC}"
echo ""
echo "  2. Launch neovim:"
echo -e "     ${BLUE}nvim${NC}"
echo ""
echo "  3. Launch tmux:"
echo -e "     ${BLUE}tmux${NC}"
echo "     (Press Ctrl+a, then I to install plugins)"
echo ""
echo "  4. Check neovim health (if any issues):"
echo -e "     ${BLUE}nvim +checkhealth${NC}"
echo ""
echo "For troubleshooting, check: $LOG_FILE"
echo ""
