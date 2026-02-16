#!/bin/bash
# Install LSP servers for all languages

source "$(dirname "$0")/common.sh"

log "Installing LSP servers..."

# Ensure npm is available
if ! command -v npm &> /dev/null; then
    log_warn "npm not found. LSP servers that require npm will be skipped."
    log_info "Re-run this script after: source ~/.bashrc"
    HAS_NPM=false
else
    HAS_NPM=true
fi

# TypeScript/JavaScript LSP servers and tools
if [[ "$HAS_NPM" == true ]]; then
    log_info "Installing TypeScript/JavaScript LSP servers..."
    npm install -g typescript typescript-language-server \
        vscode-langservers-extracted \
        @vue/language-server \
        @tailwindcss/language-server \
        tree-sitter-cli \
        neovim 2>&1 | grep -v "npm WARN" || true

    # Bash LSP server
    log_info "Installing Bash LSP server..."
    npm install -g bash-language-server 2>&1 | grep -v "npm WARN" || true

    # JSON/YAML LSP servers (part of vscode-langservers-extracted)
    log_info "JSON and HTML/CSS LSP servers already installed via vscode-langservers-extracted"
fi

# Go LSP server
if command -v go &> /dev/null && go version &> /dev/null; then
    log_info "Installing Go LSP server (gopls)..."
    go install golang.org/x/tools/gopls@latest 2>&1 || true
fi

# Rust LSP server (rust-analyzer)
if command -v rustup &> /dev/null; then
    log_info "Installing Rust LSP server (rust-analyzer)..."
    rustup component add rust-analyzer 2>/dev/null || true
fi

# C/C++ LSP server (clangd)
if ! command -v clangd &> /dev/null || [[ "$FORCE" == true ]]; then
    log_info "Installing C/C++ LSP server (clangd)..."
    case "$PKG_MANAGER" in
        apt)
            sudo apt-get install -y clang clangd 2>&1 | grep -v "^Reading" || true
            ;;
        brew)
            # On macOS, clangd comes with Xcode CLI tools
            if ! xcode-select -p &> /dev/null; then
                log_info "Installing Xcode Command Line Tools (provides clangd)..."
                xcode-select --install 2>/dev/null || true
                log_warn "Xcode CLI tools may require manual confirmation of the dialog"
            fi
            # Install llvm for latest clangd
            brew install llvm 2>&1 || true
            ;;
    esac
fi

# Note: Lua LSP server (lua_ls) is installed via Mason when Neovim first runs

# Verify installations
log_info "Verifying LSP server installations..."
SERVERS=(
    "typescript-language-server:TypeScript/JavaScript"
    "vue-language-server:Vue"
    "tailwindcss-language-server:Tailwind CSS"
    "gopls:Go"
    "rust-analyzer:Rust"
    "clangd:C/C++"
    "bash-language-server:Bash"
)

for server_info in "${SERVERS[@]}"; do
    IFS=":" read -r cmd name <<< "$server_info"
    if command -v "$cmd" &> /dev/null; then
        log_info "✓ $name LSP server installed"
    else
        log_warn "✗ $name LSP server not found"
    fi
done

log "✓ LSP servers installation complete"
