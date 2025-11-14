# Modern CLI Tool Configurations

# ripgrep configuration
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# bat theme
export BAT_THEME="gruvbox-dark"

# fzf configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374
  --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
"

# delta configuration for git
if command -v delta &> /dev/null; then
  export GIT_PAGER=delta
fi

# Additional aliases for CLI tools
# Note: Don't alias grep/find as they have different syntax and will break scripts

# lazygit alias
if command -v lazygit &> /dev/null; then
  alias lg='lazygit'
fi

# GitHub CLI completion
if command -v gh &> /dev/null; then
  eval "$(gh completion -s bash)"
fi

# Claude Code - no wrapper needed (resize command was causing scrollback issues)
# if command -v claude &> /dev/null; then
#   alias claude='resize >/dev/null 2>&1; command claude'
# fi
