#!/bin/bash
# Install Go

source "$(dirname "$0")/common.sh"

log "Installing Go..."

GO_VERSION="1.22.0"  # Update this as needed

# Check if Go is already installed
if command -v go &> /dev/null && [[ "$FORCE" != true ]]; then
    INSTALLED_VERSION=$(go version | sed 's/.*go\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
    log_info "Go already installed (version $INSTALLED_VERSION)"

    # Check if version is recent enough
    if awk "BEGIN {exit !($INSTALLED_VERSION >= 1.21)}"; then
        log "✓ Go is up to date"
        exit 0
    else
        log_warn "Go version is old, upgrading..."
    fi
fi

if [[ "$OS" == "macos" ]]; then
    # macOS: install via Homebrew
    log_info "Installing Go via Homebrew..."
    brew install go

    if command -v go &> /dev/null; then
        export GOPATH="$HOME/go"
        export GOBIN="$GOPATH/bin"
        export PATH="$GOBIN:$PATH"

        mkdir -p "$GOPATH/bin" "$GOPATH/src" "$GOPATH/pkg"

        log "✓ Go $(go version | sed 's/.*go\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/') installed"
        log_info "GOPATH: $GOPATH"
        log_info "GOBIN: $GOBIN"
    else
        log_error "Go installation via Homebrew failed"
        exit 1
    fi
else
    # Linux: download tarball
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
            log "✓ Go $(go version | sed 's/.*go\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/') installed"

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
