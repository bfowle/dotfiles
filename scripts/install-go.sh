#!/bin/bash
# Install Go

source "$(dirname "$0")/common.sh"

log "Installing Go..."

if [[ "$OS" == "macos" ]]; then
    # macOS: let Homebrew handle versioning
    # Clean up any leftover Linux Go installation
    if [[ -d "/usr/local/go" ]] && ! /usr/local/go/bin/go version &>/dev/null; then
        log_warn "Found non-functional Go at /usr/local/go (likely a Linux binary), removing..."
        sudo rm -rf /usr/local/go
        hash -r 2>/dev/null  # clear bash's cached path
    fi

    if command -v go &> /dev/null && [[ "$FORCE" != true ]]; then
        log_info "Go already installed ($(go version))"
        log_info "Upgrading if newer version available..."
        brew upgrade go 2>&1 || true
    else
        log_info "Installing Go via Homebrew..."
        brew install go
    fi

    if command -v go &> /dev/null; then
        export GOPATH="$HOME/go"
        export GOBIN="$GOPATH/bin"
        export PATH="$GOBIN:$PATH"
        mkdir -p "$GOPATH/bin" "$GOPATH/src" "$GOPATH/pkg"

        log "✓ $(go version)"
        log_info "GOPATH: $GOPATH"
        log_info "GOBIN: $GOBIN"
    else
        log_error "Go installation via Homebrew failed"
        exit 1
    fi
else
    # Linux: version check + tarball install
    GO_VERSION="1.22.0"  # Update this as needed

    if command -v go &> /dev/null && [[ "$FORCE" != true ]]; then
        INSTALLED_VERSION=$(go version | sed 's/.*go\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
        log_info "Go already installed (version $INSTALLED_VERSION)"

        if awk "BEGIN {exit !($INSTALLED_VERSION >= 1.21)}" 2>/dev/null; then
            log "✓ Go is up to date"
            exit 0
        else
            log_warn "Go version is old, upgrading..."
        fi
    fi

    GO_INSTALL_DIR="/usr/local/go"

    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            GO_ARCH="amd64"
            ;;
        aarch64|arm64)
            GO_ARCH="arm64"
            ;;
        *)
            log_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
    GO_TAR="/tmp/go${GO_VERSION}.tar.gz"

    log_info "Downloading Go ${GO_VERSION}..."
    if curl -fL "$GO_URL" -o "$GO_TAR"; then
        log_info "Installing Go to $GO_INSTALL_DIR..."
        sudo rm -rf "$GO_INSTALL_DIR"
        sudo tar -C /usr/local -xzf "$GO_TAR"
        rm "$GO_TAR"

        # Verify installation
        export PATH="/usr/local/go/bin:$PATH"
        export GOPATH="$HOME/go"
        export GOBIN="$GOPATH/bin"
        export PATH="$GOBIN:$PATH"

        if command -v go &> /dev/null; then
            log "✓ $(go version)"

            # Create GOPATH directories
            mkdir -p "$GOPATH/bin" "$GOPATH/src" "$GOPATH/pkg"

            log_info "GOPATH: $GOPATH"
            log_info "GOBIN: $GOBIN"
        else
            log_error "Go installation failed"
            exit 1
        fi
    else
        log_error "Failed to download Go"
        exit 1
    fi
fi
