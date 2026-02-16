#!/bin/bash
# Common functions for installation scripts

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
LOG_FILE="${LOG_FILE:-$HOME/.dotfiles-install.log}"

# ============================================
# Logging functions
# ============================================

log() {
    echo -e "${GREEN}==>${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}ERROR:${NC} $1" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}WARNING:${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}INFO:${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOG_FILE"
}

fatal() {
    log_error "$1"
    log_error "Installation cannot continue. Check $LOG_FILE for details."
    exit 1
}

# ============================================
# OS Detection
# ============================================

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        OS_VERSION=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
    else
        OS="unknown"
        OS_VERSION="unknown"
    fi

    # Check if WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        IS_WSL=true
    else
        IS_WSL=false
    fi

    # Determine package manager
    if [[ "$OS" == "macos" ]]; then
        PKG_MANAGER="brew"
    elif command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
    else
        PKG_MANAGER="unknown"
    fi

    export OS OS_VERSION IS_WSL PKG_MANAGER
}

# ============================================
# Package Manager Abstraction
# ============================================

ensure_brew() {
    if [[ "$OS" != "macos" ]]; then
        return 0
    fi

    # Check known install locations and add to PATH if needed
    if ! command -v brew &> /dev/null; then
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    if command -v brew &> /dev/null; then
        return 0
    fi

    # Still not found -- install it
    log_info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to PATH after install
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if ! command -v brew &> /dev/null; then
        log_error "Homebrew installation failed"
        return 1
    fi
    log "Homebrew installed successfully"
}

pkg_install() {
    local packages=("$@")
    case "$PKG_MANAGER" in
        apt)
            sudo apt-get install -y "${packages[@]}" 2>&1 | grep -v "^Reading" || true
            ;;
        brew)
            brew install "${packages[@]}" 2>&1 || true
            ;;
        *)
            log_warn "No supported package manager found, cannot install: ${packages[*]}"
            return 1
            ;;
    esac
}

# ============================================
# Auto-detect OS when sourced
# ============================================
detect_os

# Export functions for sub-scripts
export -f log log_error log_warn log_info fatal detect_os ensure_brew pkg_install
