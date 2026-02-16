#!/bin/bash
# Install code formatters

source "$(dirname "$0")/common.sh"

log "Installing code formatters..."

# Helper: check if go is functional (not just present — a leftover Linux binary won't work)
has_working_go() {
    command -v go &> /dev/null && go version &> /dev/null
}

# Prettier (JS/TS/HTML/CSS/JSON/YAML/Markdown)
if command -v npm &> /dev/null; then
    log_info "Installing Prettier..."
    npm install -g prettier @fsouza/prettierd 2>&1 | grep -v "npm WARN" || true
fi

# Stylua (Lua formatter)
if command -v cargo &> /dev/null; then
    log_info "Installing stylua (Lua formatter)..."
    cargo install stylua 2>&1 | grep -v "Updating" || true
fi

# Black (Python formatter)
if [[ "$PKG_MANAGER" == "brew" ]]; then
    log_info "Installing black (Python formatter) via Homebrew..."
    brew install black 2>&1 || true
elif command -v pip3 &> /dev/null; then
    log_info "Installing black (Python formatter)..."
    pip3 install --user black 2>&1 | grep -v "Requirement already satisfied" || true
fi

# gofmt and goimports (Go formatters - come with Go)
if has_working_go; then
    log_info "Installing goimports (Go formatter)..."
    go install golang.org/x/tools/cmd/goimports@latest 2>&1 || true
fi

# rustfmt (Rust formatter - comes with Rust)
if command -v rustup &> /dev/null; then
    log_info "rustfmt already installed with Rust"
fi

# clang-format (C/C++ formatter)
if ! command -v clang-format &> /dev/null || [[ "$FORCE" == true ]]; then
    log_info "Installing clang-format..."
    case "$PKG_MANAGER" in
        apt)
            sudo apt-get install -y clang-format 2>&1 | grep -v "^Reading" || true
            ;;
        brew)
            brew install clang-format 2>&1 || true
            ;;
    esac
fi

# shfmt (Shell script formatter)
if [[ "$PKG_MANAGER" == "brew" ]]; then
    log_info "Installing shfmt (Shell formatter) via Homebrew..."
    brew install shfmt 2>&1 || true
elif has_working_go; then
    log_info "Installing shfmt (Shell formatter)..."
    go install mvdan.cc/sh/v3/cmd/shfmt@latest 2>&1 || true
fi

# Verify installations
log_info "Verifying formatter installations..."
FORMATTERS=(
    "prettier:Prettier"
    "prettierd:Prettierd"
    "stylua:Stylua"
    "black:Black"
    "goimports:goimports"
    "rustfmt:rustfmt"
    "clang-format:clang-format"
    "shfmt:shfmt"
)

for formatter_info in "${FORMATTERS[@]}"; do
    IFS=":" read -r cmd name <<< "$formatter_info"
    if command -v "$cmd" &> /dev/null; then
        log_info "✓ $name installed"
    else
        log_warn "✗ $name not found"
    fi
done

log "✓ Formatters installation complete"
