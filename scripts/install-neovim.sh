#!/bin/bash
# Install Neovim

source "$(dirname "$0")/common.sh"

log "Installing Neovim..."

if [[ "$OS" == "macos" ]]; then
    # macOS: let Homebrew handle versioning
    # Clean up any leftover Linux AppImage installation
    if [[ -f "$HOME/.local/bin/nvim.appimage" ]] && ! "$HOME/.local/bin/nvim.appimage" --version &>/dev/null; then
        log_warn "Found non-functional nvim at ~/.local/bin (likely a Linux AppImage), removing..."
        rm -f "$HOME/.local/bin/nvim.appimage" "$HOME/.local/bin/nvim"
        hash -r 2>/dev/null  # clear bash's cached path
    fi

    if command -v nvim &> /dev/null && nvim --version &>/dev/null && [[ "$FORCE" != true ]]; then
        log_info "Neovim already installed ($(nvim --version | head -n1))"
        log_info "Upgrading if newer version available..."
        brew upgrade neovim 2>&1 || true
    else
        log_info "Installing Neovim via Homebrew..."
        brew install neovim
    fi

    if command -v nvim &> /dev/null && nvim --version &>/dev/null; then
        log "✓ Neovim installed: $(nvim --version | head -n1)"
    else
        log_error "Neovim installation via Homebrew failed"
        exit 1
    fi
else
    # Linux: version check + AppImage install

    # Check if neovim is already installed and recent enough
    if command -v nvim &> /dev/null && [[ "$FORCE" != true ]]; then
        NVIM_VERSION=$(nvim --version | head -n1 | sed 's/.*v\([0-9]*\.[0-9]*\).*/\1/')
        log_info "Neovim already installed (version $NVIM_VERSION)"

        MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
        MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)

        if [ "$MAJOR" -gt 0 ] 2>/dev/null || [ "$MAJOR" -eq 0 -a "$MINOR" -ge 9 ] 2>/dev/null; then
            log "✓ Neovim $NVIM_VERSION is up to date (>= 0.9)"
            exit 0
        else
            log_warn "Neovim version is old ($NVIM_VERSION < 0.9), upgrading..."
        fi
    fi

    # Check if nvim is currently running (would cause file busy error)
    if pgrep -x nvim > /dev/null 2>/dev/null; then
        log_error "Neovim is currently running. Please close all nvim instances and try again."
        exit 1
    fi

    # Download and install latest stable Neovim AppImage
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            NVIM_ARCH="x86_64"
            ;;
        aarch64|arm64)
            NVIM_ARCH="arm64"
            ;;
        *)
            log_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.appimage"
    NVIM_INSTALL_DIR="$HOME/.local/bin"

    mkdir -p "$NVIM_INSTALL_DIR"

    log_info "Downloading latest stable Neovim for ${NVIM_ARCH}..."
    if curl -fL "$NVIM_URL" -o "${NVIM_INSTALL_DIR}/nvim.appimage"; then
        chmod +x "${NVIM_INSTALL_DIR}/nvim.appimage"

        # Create symlink
        ln -sf "${NVIM_INSTALL_DIR}/nvim.appimage" "${NVIM_INSTALL_DIR}/nvim"

        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$NVIM_INSTALL_DIR:"* ]]; then
            export PATH="$NVIM_INSTALL_DIR:$PATH"
        fi

        # Verify installation
        if command -v nvim &> /dev/null; then
            INSTALLED_VERSION=$(nvim --version | head -n1)
            log "✓ Neovim installed successfully: $INSTALLED_VERSION"
        else
            log_error "Neovim installation failed"
            exit 1
        fi
    else
        log_error "Failed to download Neovim"
        exit 1
    fi
fi
