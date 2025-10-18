#!/bin/bash
# Install Rust via rustup

source "$(dirname "$0")/common.sh"

log "Installing Rust..."

# Check if rustup is already installed
if command -v rustup &> /dev/null && [[ "$FORCE" != true ]]; then
    log_info "Rust already installed ($(rustc --version))"
    log_info "Updating Rust..."
    rustup update
else
    log_info "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

    # Source cargo env
    source "$HOME/.cargo/env"
fi

# Verify installation
if command -v cargo &> /dev/null && command -v rustc &> /dev/null; then
    log "✓ Rust $(rustc --version) installed"
else
    log_error "Rust installation failed"
    exit 1
fi

# Install useful Rust components
log_info "Installing Rust components..."
rustup component add rustfmt clippy rust-analyzer 2>/dev/null || true

log "✓ Rust setup complete"
