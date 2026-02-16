#!/bin/bash
# Install system dependencies

source "$(dirname "$0")/common.sh"

log "Installing system dependencies..."

case "$PKG_MANAGER" in
    apt)
        log_info "Updating package list..."
        sudo apt-get update -qq

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
            tmux
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
        ;;
    brew)
        log_info "Installing essential packages via Homebrew..."
        # macOS has pbcopy (no xclip needed), built-in tar/gzip/curl, etc.
        PACKAGES=(
            cmake
            pkg-config
            wget
            git
            unzip
            tmux
            python3
        )
        brew install "${PACKAGES[@]}" 2>&1 || true
        ;;
    *)
        log_warn "No supported package manager found, skipping system packages"
        ;;
esac

# Install Python neovim module (cross-platform)
if command -v pip3 &> /dev/null; then
    log_info "Installing Python neovim module (pynvim)..."
    pip3 install --user --upgrade pynvim 2>&1 | grep -v "Requirement already satisfied" || \
    pip3 install --upgrade pynvim 2>&1 | grep -v "Requirement already satisfied" || true
fi

log "✓ System dependencies installed"
