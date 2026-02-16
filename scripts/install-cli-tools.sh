#!/bin/bash
# Install modern CLI tools

source "$(dirname "$0")/common.sh"

log "Installing modern CLI tools..."

if [[ "$PKG_MANAGER" == "brew" ]]; then
    # macOS: batch install via Homebrew (prebuilt bottles, much faster than cargo)
    log_info "Installing CLI tools via Homebrew..."
    brew install ripgrep fd bat eza fzf git-delta zoxide 2>&1 || true

    # fzf shell integration
    if command -v fzf &> /dev/null; then
        FZF_PREFIX="$(brew --prefix)/opt/fzf"
        if [[ -f "$FZF_PREFIX/install" ]]; then
            "$FZF_PREFIX/install" --key-bindings --completion --no-update-rc --no-bash --no-zsh 2>&1 || true
        fi
    fi
else
    # Linux: use cargo with apt-get fallback

    # ripgrep (better grep)
    if ! command -v rg &> /dev/null || [[ "$FORCE" == true ]]; then
        log_info "Installing ripgrep..."
        if command -v cargo &> /dev/null; then
            cargo install ripgrep 2>&1 | grep -v "Updating" || true
        elif command -v apt-get &> /dev/null; then
            sudo apt-get install -y ripgrep 2>&1 | grep -v "^Reading" || true
        fi
    fi

    # fd (better find)
    if ! command -v fd &> /dev/null || [[ "$FORCE" == true ]]; then
        log_info "Installing fd..."
        if command -v cargo &> /dev/null; then
            cargo install fd-find 2>&1 | grep -v "Updating" || true
        elif command -v apt-get &> /dev/null; then
            sudo apt-get install -y fd-find 2>&1 | grep -v "^Reading" || true
            # Create fd alias (Ubuntu installs as fdfind)
            if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
                sudo ln -sf $(which fdfind) /usr/local/bin/fd
            fi
        fi
    fi

    # bat (better cat)
    if ! command -v bat &> /dev/null || [[ "$FORCE" == true ]]; then
        log_info "Installing bat..."
        if command -v cargo &> /dev/null; then
            cargo install bat 2>&1 | grep -v "Updating" || true
        elif command -v apt-get &> /dev/null; then
            sudo apt-get install -y bat 2>&1 | grep -v "^Reading" || true
            # Create bat alias (Ubuntu installs as batcat)
            if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
                sudo ln -sf $(which batcat) /usr/local/bin/bat
            fi
        fi
    fi

    # eza (better ls)
    if ! command -v eza &> /dev/null || [[ "$FORCE" == true ]]; then
        log_info "Installing eza..."
        if command -v cargo &> /dev/null; then
            cargo install eza 2>&1 | grep -v "Updating" || true
        fi
    fi

    # fzf (fuzzy finder)
    if ! command -v fzf &> /dev/null || [[ "$FORCE" == true ]]; then
        log_info "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>&1 | grep -v "^Cloning" || true
        ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-zsh 2>&1 || true
    fi

    # delta (better git diff)
    if ! command -v delta &> /dev/null || [[ "$FORCE" == true ]]; then
        log_info "Installing delta..."
        if command -v cargo &> /dev/null; then
            cargo install git-delta 2>&1 | grep -v "Updating" || true
        fi
    fi

    # zoxide (better cd)
    if ! command -v zoxide &> /dev/null || [[ "$FORCE" == true ]]; then
        log_info "Installing zoxide..."
        if command -v cargo &> /dev/null; then
            cargo install zoxide 2>&1 | grep -v "Updating" || true
        fi
    fi
fi

# Verify installations
log_info "Verifying CLI tool installations..."
TOOLS=(
    "rg:ripgrep"
    "fd:fd-find"
    "bat:bat"
    "eza:eza"
    "fzf:fzf"
    "delta:git-delta"
    "zoxide:zoxide"
)

for tool_info in "${TOOLS[@]}"; do
    IFS=":" read -r cmd name <<< "$tool_info"
    if command -v "$cmd" &> /dev/null; then
        log_info "✓ $name installed"
    else
        log_warn "✗ $name not found"
    fi
done

log "✓ CLI tools installation complete"
