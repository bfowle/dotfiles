#!/bin/bash
# Download and prepare Nerd Fonts

source "$(dirname "$0")/common.sh"

log "Setting up Nerd Fonts..."

# macOS: install via Homebrew cask
if [[ "$OS" == "macos" ]]; then
    log_info "Installing Nerd Fonts on macOS via Homebrew..."
    brew install --cask font-caskaydia-cove-nerd-font 2>&1 || true
    brew install --cask font-jetbrains-mono-nerd-font 2>&1 || true
    log "✓ Nerd Fonts installed on macOS"
    log_info "Set your terminal font to 'CaskaydiaCove Nerd Font' or 'JetBrainsMono Nerd Font'"
    exit 0
fi

# Check if running in WSL
if ! grep -qi microsoft /proc/version 2>/dev/null; then
    log_warn "Not running in WSL - font installation is for WSL/Windows and macOS only"
    log_info "For native Linux, install fonts to ~/.local/share/fonts/"
    exit 0
fi

# WSL: Download fonts and create Windows installer
# Get Windows username
WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
if [ -z "$WIN_USER" ]; then
    log_error "Could not detect Windows username"
    exit 1
fi

# Paths
WIN_DOWNLOADS="/mnt/c/Users/${WIN_USER}/Downloads"
FONT_DIR="${WIN_DOWNLOADS}/NerdFonts"
PS_SCRIPT="${WIN_DOWNLOADS}/install-fonts.ps1"

# Check if fonts are already downloaded
if [ -d "$FONT_DIR" ] && [ "$(ls -A $FONT_DIR/*.ttf 2>/dev/null | wc -l)" -gt 0 ]; then
    log_info "Nerd Fonts already downloaded in $FONT_DIR"
    log_info "To reinstall, delete the folder and run this script again"
else
    log_info "Downloading Nerd Fonts to Windows Downloads folder..."

    mkdir -p "$FONT_DIR"

    # Download CascadiaCode Nerd Font (best for Windows Terminal)
    log_info "Downloading CascadiaCode Nerd Font..."
    CASCADIA_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"

    if curl -fL "$CASCADIA_URL" -o "${FONT_DIR}/CascadiaCode.zip"; then
        log_info "Extracting fonts..."
        unzip -q "${FONT_DIR}/CascadiaCode.zip" -d "$FONT_DIR"
        rm "${FONT_DIR}/CascadiaCode.zip"
        log "✓ CascadiaCode Nerd Font downloaded"
    else
        log_error "Failed to download CascadiaCode Nerd Font"
        exit 1
    fi

    # Optional: Download JetBrainsMono as alternative
    log_info "Downloading JetBrainsMono Nerd Font (alternative)..."
    JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

    if curl -fL "$JETBRAINS_URL" -o "${FONT_DIR}/JetBrainsMono.zip"; then
        unzip -q "${FONT_DIR}/JetBrainsMono.zip" -d "$FONT_DIR"
        rm "${FONT_DIR}/JetBrainsMono.zip"
        log "✓ JetBrainsMono Nerd Font downloaded"
    else
        log_warn "Failed to download JetBrainsMono (optional)"
    fi
fi

# Create PowerShell installation script
log_info "Creating PowerShell installation script..."

cat > "$PS_SCRIPT" << 'PSEOF'
# PowerShell script to install Nerd Fonts
# Run this as Administrator

$ErrorActionPreference = "Stop"

Write-Host "Installing Nerd Fonts..." -ForegroundColor Green

# Get font directory
$FontDir = "$env:USERPROFILE\Downloads\NerdFonts"

if (-not (Test-Path $FontDir)) {
    Write-Host "ERROR: Font directory not found: $FontDir" -ForegroundColor Red
    Write-Host "Please run ./install.sh in WSL first to download fonts" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Get all font files
$Fonts = Get-ChildItem -Path $FontDir -Include *.ttf,*.otf -Recurse

if ($Fonts.Count -eq 0) {
    Write-Host "ERROR: No font files found in $FontDir" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Found $($Fonts.Count) font files"

# Install fonts
$FontsInstalled = 0
$FontsSkipped = 0

foreach ($Font in $Fonts) {
    $FontName = $Font.Name

    # Copy to Windows Fonts directory
    $DestPath = "C:\Windows\Fonts\$FontName"

    if (Test-Path $DestPath) {
        Write-Host "  Skipped: $FontName (already installed)" -ForegroundColor Yellow
        $FontsSkipped++
    } else {
        try {
            Copy-Item -Path $Font.FullName -Destination $DestPath -Force

            # Register font in registry
            $FontRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            $FontRegistryName = $Font.BaseName + " (TrueType)"

            if (-not (Get-ItemProperty -Path $FontRegistryPath -Name $FontRegistryName -ErrorAction SilentlyContinue)) {
                New-ItemProperty -Path $FontRegistryPath -Name $FontRegistryName -Value $FontName -PropertyType String -Force | Out-Null
            }

            Write-Host "  Installed: $FontName" -ForegroundColor Green
            $FontsInstalled++
        } catch {
            Write-Host "  Failed: $FontName - $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "  Installed: $FontsInstalled fonts" -ForegroundColor Green
Write-Host "  Skipped: $FontsSkipped fonts (already installed)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Close and reopen your terminal" -ForegroundColor White
Write-Host "  2. Open Windows Terminal settings (Ctrl+,)" -ForegroundColor White
Write-Host "  3. Select your WSL profile" -ForegroundColor White
Write-Host "  4. Change font to: CaskaydiaCove Nerd Font" -ForegroundColor White
Write-Host "  5. Save and enjoy icons!" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
PSEOF

# Make PowerShell script executable
chmod +x "$PS_SCRIPT"

# Convert Windows paths for display
WIN_FONT_DIR="C:\\Users\\${WIN_USER}\\Downloads\\NerdFonts"
WIN_PS_SCRIPT="C:\\Users\\${WIN_USER}\\Downloads\\install-fonts.ps1"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║        Nerd Fonts Downloaded!                             ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
log "✓ Fonts downloaded to: $WIN_FONT_DIR"
log "✓ PowerShell installer created: $WIN_PS_SCRIPT"
echo ""
echo -e "${YELLOW}TO COMPLETE FONT INSTALLATION:${NC}"
echo ""
echo "  1. Open PowerShell as Administrator:"
echo -e "     ${BLUE}Right-click Start → Windows PowerShell (Admin)${NC}"
echo ""
echo "  2. Run the installation script:"
echo -e "     ${BLUE}cd ~\\Downloads${NC}"
echo -e "     ${BLUE}.\\install-fonts.ps1${NC}"
echo ""
echo "  3. Configure Windows Terminal:"
echo -e "     ${BLUE}Open Windows Terminal settings (Ctrl+,)${NC}"
echo -e "     ${BLUE}Select your WSL profile${NC}"
echo -e "     ${BLUE}Font face: CaskaydiaCove Nerd Font${NC}"
echo ""
echo "  4. Restart your terminal and run 'ls' to see icons!"
echo ""

# Try to open Windows Explorer to the font directory (convenience)
if command -v explorer.exe &> /dev/null; then
    log_info "Opening Downloads folder in Windows Explorer..."
    explorer.exe "$WIN_DOWNLOADS" 2>/dev/null || true
fi

log "✓ Font installation preparation complete"
