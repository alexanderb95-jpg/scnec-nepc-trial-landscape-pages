# Git Setup Guide

This repository has been set up with Git version control. Here's what's configured and how to use it.

## Current Configuration

### User Information
- **Name**: Alex (local repository setting)
- **Email**: alex@localhost (local repository setting)

To change your git user information:
```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

Or set globally for all repositories:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Repository Settings
- **Default branch**: `main`
- **Line endings**: LF (Unix-style) for text files
- **File mode**: Tracked

## What's Tracked

The following are tracked in git:
- ✅ Source code: `scripts/`, `rmarkdown/`, `python/`
- ✅ Documentation: `docs/`
- ✅ Data files: `data/` (CSV, Excel, RDS files)
- ✅ Configuration: `.gitignore`, `.gitattributes`, `README.md`

The following are **ignored** (not tracked):
- ❌ Generated outputs: `outputs/` (HTML files)
- ❌ Generated figures: `figures/` (PNG, SVG, EPS files)
- ❌ Documents: `documents/` (PDF, DOCX, PPTX files)
- ❌ Temporary files: `temp/`
- ❌ R workspace files: `.RData`, `.Rhistory`
- ❌ Cache directories: `cache/`, `*_cache/`, `*_files/`

## Useful Git Aliases

The following shortcuts are configured:
- `git st` → `git status`
- `git co` → `git checkout`
- `git br` → `git branch`
- `git ci` → `git commit`
- `git unstage` → `git reset HEAD --`
- `git last` → `git log -1 HEAD`

## Common Git Commands

### Check Status
```bash
git status
# or
git st
```

### Stage Files
```bash
# Stage all changes
git add .

# Stage specific file
git add scripts/my_script.R

# Stage all files in directory
git add scripts/
```

### Commit Changes
```bash
git commit -m "Description of changes"
# or
git ci -m "Description of changes"
```

### View History
```bash
# View commit history
git log

# View last commit
git last

# View changes in last commit
git show
```

### View Changes
```bash
# See what changed
git diff

# See staged changes
git diff --staged
```

### Undo Changes
```bash
# Unstage a file
git unstage filename

# Discard changes to a file (careful!)
git checkout -- filename

# Undo last commit (keep changes)
git reset --soft HEAD~1
```

## Setting Up a Remote Repository

If you want to push to GitHub, GitLab, or another remote:

1. Create a repository on your hosting service (GitHub, GitLab, etc.)

2. Add the remote:
```bash
git remote add origin https://github.com/username/repo-name.git
```

3. Push your code:
```bash
git push -u origin main
```

## Best Practices

1. **Commit often**: Make small, logical commits with clear messages
2. **Check status**: Use `git status` before committing to see what will be included
3. **Review changes**: Use `git diff` to review changes before committing
4. **Write good commit messages**: Be descriptive about what changed and why
5. **Don't commit generated files**: They're already in `.gitignore`, but double-check

## Ignoring Large Files

If you have large data files (>100MB), consider:
1. Using Git LFS (Large File Storage)
2. Storing data files externally
3. Uncommenting data file ignores in `.gitignore`

## Troubleshooting

### Line Ending Warnings
If you see warnings about CRLF/LF conversions, that's normal. Git is normalizing line endings to LF (Unix-style) for consistency.

### Files Not Being Ignored
If files that should be ignored are showing up:
1. Check `.gitignore` syntax
2. Files already tracked won't be ignored - remove them first:
   ```bash
   git rm --cached filename
   ```

### Undo Everything
If you want to start fresh:
```bash
# Remove all tracked files (keeps working directory)
git rm -r --cached .

# Re-add what you want
git add scripts/ rmarkdown/ python/ docs/ data/
```
