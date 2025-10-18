#!/bin/bash
# Install system dependencies

source "$(dirname "$0")/common.sh"

log "Installing system dependencies..."

# Update package list
if command -v apt-get &> /dev/null; then
    log_info "Updating package list..."
    sudo apt-get update -qq

    # Install essential packages
    PACKAGES=(
        build-essential
        cmake
        pkg-config
        curl
        wget
        git
        unzip
        tar
        gzip
        xclip          # clipboard integration
        software-properties-common
        apt-transport-https
        ca-certificates
        gnupg
        lsb-release
        python3-pip    # for Python neovim module
    )

    log_info "Installing essential packages..."
    sudo apt-get install -y "${PACKAGES[@]}"

    # Install Python neovim module
    if command -v pip3 &> /dev/null; then
        log_info "Installing Python neovim module (pynvim)..."
        # Try with --user first, fallback to without if in virtualenv
        pip3 install --user --upgrade pynvim 2>&1 | grep -v "Requirement already satisfied" || \
        pip3 install --upgrade pynvim 2>&1 | grep -v "Requirement already satisfied" || true
    fi

    log "✓ System dependencies installed"
else
    log_warn "apt-get not found, skipping system packages"
fi
