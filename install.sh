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
# Usage: ./install.sh [options]
#   --minimal    Install only core dotfiles and neovim
#   --force      Reinstall everything, even if already present
#   --help       Show this help message
#

set -e  # Exit on error

# Configuration
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
export LOG_FILE="$HOME/.dotfiles-install.log"
MINIMAL=false
FORCE=false

# Ensure scripts directory exists
mkdir -p "$SCRIPTS_DIR"

# Source common functions
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

# Detect OS
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi

    # Check if WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        IS_WSL=true
    else
        IS_WSL=false
    fi

    log_info "Detected OS: $OS ${OS_VERSION:-}"
    if [[ "$IS_WSL" == true ]]; then
        log_info "Running in WSL"
    fi
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log_error "This script should NOT be run as root (don't use sudo)"
    log_info "The script will prompt for sudo password when needed"
    exit 1
fi

# Start installation
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║        Automated Dotfiles Installation                    ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Initialize log
echo "Installation started at $(date)" > "$LOG_FILE"

detect_os

# Backup existing configs
if [[ "$FORCE" == true ]] || [[ ! -d "$HOME/.dotfiles-backups" ]]; then
    log "Creating backup of existing configurations..."
    if [[ -f "$DOTFILES_DIR/.claude/skills/backup-and-restore/backup.sh" ]]; then
        "$DOTFILES_DIR/.claude/skills/backup-and-restore/backup.sh" "pre-install-$(date +%Y%m%d-%H%M%S)" || true
    fi
fi

# Run installation scripts in order
log "Starting installation process..."
echo ""

# 1. System dependencies
if [[ -f "$SCRIPTS_DIR/install-deps.sh" ]]; then
    bash "$SCRIPTS_DIR/install-deps.sh" || log_error "Failed to install system dependencies"
fi

# 2. Neovim
if [[ -f "$SCRIPTS_DIR/install-neovim.sh" ]]; then
    bash "$SCRIPTS_DIR/install-neovim.sh" || log_error "Failed to install Neovim"
fi

# 3. Node.js (fnm)
if [[ -f "$SCRIPTS_DIR/install-node.sh" ]]; then
    bash "$SCRIPTS_DIR/install-node.sh" || log_error "Failed to install Node.js"
fi

# 4. Rust
if [[ -f "$SCRIPTS_DIR/install-rust.sh" ]]; then
    bash "$SCRIPTS_DIR/install-rust.sh" || log_error "Failed to install Rust"
fi

# 5. Go
if [[ -f "$SCRIPTS_DIR/install-go.sh" ]]; then
    bash "$SCRIPTS_DIR/install-go.sh" || log_error "Failed to install Go"
    # Source Go paths for current session
    if [ -d "/usr/local/go/bin" ]; then
        export PATH="/usr/local/go/bin:$PATH"
        export GOPATH="$HOME/go"
        export GOBIN="$GOPATH/bin"
        export PATH="$GOBIN:$PATH"
    fi
fi

# 6. Create symlinks
if [[ -f "$SCRIPTS_DIR/create-symlinks.sh" ]]; then
    bash "$SCRIPTS_DIR/create-symlinks.sh" || log_error "Failed to create symlinks"
fi

# Only install optional tools if not minimal install
if [[ "$MINIMAL" == false ]]; then
    # 7. LSP servers
    if [[ -f "$SCRIPTS_DIR/install-lsp-servers.sh" ]]; then
        bash "$SCRIPTS_DIR/install-lsp-servers.sh" || log_warn "Some LSP servers may not have installed"
    fi

    # 8. Formatters
    if [[ -f "$SCRIPTS_DIR/install-formatters.sh" ]]; then
        bash "$SCRIPTS_DIR/install-formatters.sh" || log_warn "Some formatters may not have installed"
    fi

    # 9. Modern CLI tools
    if [[ -f "$SCRIPTS_DIR/install-cli-tools.sh" ]]; then
        bash "$SCRIPTS_DIR/install-cli-tools.sh" || log_warn "Some CLI tools may not have installed"
    fi

    # 10. Git tools
    if [[ -f "$SCRIPTS_DIR/install-git-tools.sh" ]]; then
        bash "$SCRIPTS_DIR/install-git-tools.sh" || log_warn "Some Git tools may not have installed"
    fi

    # 11. Nerd Fonts (WSL only)
    if [[ -f "$SCRIPTS_DIR/install-fonts.sh" ]]; then
        bash "$SCRIPTS_DIR/install-fonts.sh" || log_warn "Font setup may need manual completion"
    fi

    # 12. Tmux Plugin Manager (TPM)
    if [[ -f "$SCRIPTS_DIR/install-tmux-plugins.sh" ]]; then
        bash "$SCRIPTS_DIR/install-tmux-plugins.sh" || log_warn "TPM setup may need manual completion"
    fi
fi

# Final setup
log "Running final setup steps..."

# Install vim-plug for legacy vim (if vim directory exists)
if [[ -d "$DOTFILES_DIR/vim" ]] && [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
    log_info "Installing vim-plug for legacy vim..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || true
fi

# Make backup/restore scripts executable
chmod +x "$DOTFILES_DIR/.claude/skills/backup-and-restore"/*.sh 2>/dev/null || true

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║        ✓ Installation Complete!                           ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

log "Installation completed successfully!"
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
