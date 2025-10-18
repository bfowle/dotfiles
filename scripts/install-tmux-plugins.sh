#!/bin/bash
# Install Tmux Plugin Manager (TPM) and plugins

source "$(dirname "$0")/common.sh"

log "Installing Tmux Plugin Manager (TPM)..."

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Install TPM if not already installed
if [ ! -d "$TPM_DIR" ]; then
    log_info "Cloning TPM repository..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" 2>&1 | grep -v "Cloning into" || true

    if [ -d "$TPM_DIR" ]; then
        log "✓ TPM installed successfully"
    else
        log_error "Failed to install TPM"
        exit 1
    fi
else
    log_info "TPM already installed, updating..."
    cd "$TPM_DIR"
    git pull origin master 2>&1 | grep -v "Already up to date" || true
    cd - > /dev/null
fi

# Install/update plugins
if [ -d "$TPM_DIR" ]; then
    log_info "Installing/updating tmux plugins..."

    # Create plugins directory if it doesn't exist
    mkdir -p "$HOME/.tmux/plugins"

    # Run TPM's install script
    if [ -f "$TPM_DIR/bin/install_plugins" ]; then
        "$TPM_DIR/bin/install_plugins" 2>&1 | grep -E "(Installing|Updating|Already installed)" || true
        log "✓ Tmux plugins installed"
    else
        log_warn "TPM install script not found, plugins will install on first tmux launch"
    fi
else
    log_error "TPM directory not found"
    exit 1
fi

log "✓ TPM setup complete"
