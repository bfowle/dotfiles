#!/bin/bash
# Install fnm (Fast Node Manager) and Node.js

source "$(dirname "$0")/common.sh"

log "Installing fnm and Node.js..."

# Check if fnm is already installed
if command -v fnm &> /dev/null && [[ "$FORCE" != true ]]; then
    log_info "fnm already installed ($(fnm --version))"
else
    log_info "Installing fnm..."
    # Force install to a consistent location across platforms
    FNM_DIR="$HOME/.local/share/fnm"
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir "$FNM_DIR"

    # Source fnm for current session
    export FNM_DIR
    export PATH="$FNM_DIR:$PATH"

    if ! command -v fnm &> /dev/null; then
        log_error "fnm installation failed"
        exit 1
    fi

    eval "$(fnm env --use-on-cd)"
fi

# Install Node.js LTS if not already installed
if ! fnm list | grep -q "lts"; then
    log_info "Installing Node.js LTS..."
    fnm install --lts
    fnm use lts-latest
    fnm default lts-latest
    log "✓ Node.js LTS installed"
else
    log_info "Node.js LTS already installed"
    fnm use lts-latest
fi

# Verify Node.js and npm are available
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    log "✓ Node.js $(node --version) and npm $(npm --version) ready"
else
    log_warn "Node.js/npm not found in PATH, may need to reload shell"
fi
