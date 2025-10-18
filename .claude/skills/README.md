# Claude Code Skills

This directory contains custom skills for maintaining and updating the dotfiles repository using Claude Code.

## Available Skills

### 1. update-neovim-plugins
**Purpose**: Update LazyVim and all neovim plugins to latest versions

**How to use**:
- In Claude Code: Type `/update-neovim-plugins`
- The skill will run `:Lazy sync` and report what was updated

### 2. update-dotfiles-trends
**Purpose**: Research latest trends in developer tooling and suggest improvements

**How to use**:
- In Claude Code: Type `/update-dotfiles-trends`
- The skill will search for latest trends and compare with current setup

### 3. sync-gruvbox-theme
**Purpose**: Verify gruvbox theme consistency across vim, neovim, tmux, and terminal

**How to use**:
- In Claude Code: Type `/sync-gruvbox-theme`
- The skill will check all configs and report any inconsistencies

### 4. backup-and-restore
**Purpose**: Backup configurations before changes and restore if needed

**How to use**:
- Backup: `~/.dotfiles/.claude/skills/backup-and-restore/backup.sh "reason"`
- Restore: `~/.dotfiles/.claude/skills/backup-and-restore/restore.sh backup-YYYY-MM-DD-HHMMSS`
- List backups: `ls -lt ~/.dotfiles-backups/`

## What are Skills?

Skills are specialized capabilities that Claude Code can invoke autonomously based on your requests. They contain:
- **Skill.md**: Instructions, context, and guidance for Claude
- **Scripts** (optional): Executable scripts that the skill can run
- **Resources** (optional): Reference files and documentation

## Skill Structure

Each skill is a directory containing at minimum a `Skill.md` file with YAML frontmatter:

```markdown
---
name: skill-name
description: Brief description of what this skill does
---

# Skill Title

Detailed instructions for Claude Code...
```

## Adding New Skills

To add a new skill:

1. Create a directory: `.claude/skills/my-skill/`
2. Create `Skill.md` with proper frontmatter
3. Add any scripts or resources
4. Claude Code will automatically detect it

## Project vs Personal Skills

- **Project skills**: In `.claude/skills/` (shared with team via git)
- **Personal skills**: In `~/.claude/skills/` (personal, not committed)

These are project skills and will be version controlled with the dotfiles.

## Best Practices

- Keep skills focused on a single task
- Provide clear, actionable instructions
- Include examples and expected outputs
- Add error handling guidance
- Document any scripts thoroughly

## More Information

- [Claude Code Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
