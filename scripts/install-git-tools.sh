#!/bin/bash
# Install Git-related tools

source "$(dirname "$0")/common.sh"

log "Installing Git tools..."

# GitHub CLI (gh)
if ! command -v gh &> /dev/null || [[ "$FORCE" == true ]]; then
    log_info "Installing GitHub CLI (gh)..."
    if command -v apt-get &> /dev/null; then
        # Add GitHub CLI repository
        type -p curl >/dev/null || sudo apt install curl -y
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update -qq
        sudo apt-get install -y gh 2>&1 | grep -v "^Reading" || true
    fi
fi

# lazygit (TUI for git)
if ! command -v lazygit &> /dev/null || [[ "$FORCE" == true ]]; then
    log_info "Installing lazygit..."

    # Install via go if available
    if command -v go &> /dev/null; then
        go install github.com/jesseduffield/lazygit@latest 2>&1 || true
    else
        # Download binary
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        ARCH=$(dpkg --print-architecture)
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz" 2>/dev/null
        tar xf /tmp/lazygit.tar.gz -C /tmp
        sudo install /tmp/lazygit /usr/local/bin
        rm /tmp/lazygit.tar.gz /tmp/lazygit
    fi
fi

# Verify installations
log_info "Verifying Git tool installations..."
if command -v gh &> /dev/null; then
    log_info "✓ GitHub CLI (gh) installed: $(gh --version | head -n1)"
else
    log_warn "✗ GitHub CLI (gh) not found"
fi

if command -v lazygit &> /dev/null; then
    log_info "✓ lazygit installed"
else
    log_warn "✗ lazygit not found"
fi

log "✓ Git tools installation complete"
