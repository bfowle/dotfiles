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

# Logging functions
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

# Export functions
export -f log log_error log_warn log_info
