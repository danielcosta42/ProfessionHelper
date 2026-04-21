# Conventional Commits Guide

## 📝 Automatic Semantic Versioning

This project uses **Conventional Commits** for automatic version bumping and changelog generation.

---

## 🎯 Commit Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Examples:

```bash
# Bug fix (PATCH: 1.0.0 → 1.0.1)
git commit -m "fix: correct TSM price calculation"

# New feature (MINOR: 1.0.0 → 1.1.0)
git commit -m "feat: add Jewelcrafting guide"

# Breaking change (MAJOR: 1.0.0 → 2.0.0)
git commit -m "feat!: redesign entire UI"

# With scope
git commit -m "fix(ui): resolve tooltip positioning bug"

# With body
git commit -m "feat: add gathering routes

Added detailed farming routes for all gathering professions
including optimal zone progression and efficiency tips."

# Breaking change with footer
git commit -m "feat: new API for profession data

BREAKING CHANGE: Old ProfessionData API removed. Use new PH.GetProfessionData() instead."
```

---

## 📊 Commit Types

### Types that trigger releases:

| Type | Version Bump | When to Use | Example |
|------|--------------|-------------|---------|
| `feat` | **MINOR** (1.0.0 → 1.1.0) | New features | `feat: add fishing locations` |
| `fix` | **PATCH** (1.0.0 → 1.0.1) | Bug fixes | `fix: resolve crash on profession switch` |
| `perf` | **PATCH** (1.0.0 → 1.0.1) | Performance improvements | `perf: optimize material calculation` |
| `revert` | **PATCH** (1.0.0 → 1.0.1) | Revert previous commit | `revert: remove broken feature` |
| `refactor` | **PATCH** (1.0.0 → 1.0.1) | Code refactoring | `refactor: simplify UI rendering` |
| `feat!` or `BREAKING CHANGE:` | **MAJOR** (1.0.0 → 2.0.0) | Breaking changes | `feat!: new database structure` |

### Types that DON'T trigger releases:

| Type | Purpose | Example |
|------|---------|---------|
| `docs` | Documentation only | `docs: update README installation steps` |
| `style` | Code formatting | `style: fix indentation in Core.lua` |
| `chore` | Maintenance tasks | `chore: update .gitignore` |
| `test` | Adding/updating tests | `test: add unit tests for calculator` |
| `build` | Build system changes | `build: update workflow dependencies` |
| `ci` | CI/CD changes | `ci: add new validation step` |

---

## 🚀 How It Works

### Workflow:

1. **You commit with conventional format:**
   ```bash
   git commit -m "feat: add new profession guide"
   git push origin main
   ```

2. **GitHub Actions triggers:**
   - Analyzes commit messages
   - Determines version bump (MAJOR/MINOR/PATCH)
   - Updates version in files
   - Generates changelog
   - Creates git tag
   - Creates GitHub release
   - Publishes to CurseForge/WoWInterface

3. **Automatic version bump:**
   - `feat:` commits → `1.0.0` → `1.1.0`
   - `fix:` commits → `1.0.0` → `1.0.1`
   - `feat!:` commits → `1.0.0` → `2.0.0`

---

## 📋 Complete Examples

### Feature Addition (MINOR bump)

```bash
git add Data/Jewelcrafting.lua
git commit -m "feat: add complete Jewelcrafting profession guide

Added step-by-step leveling guide for Jewelcrafting 1-375
with material lists and vendor locations."
git push origin main
```

**Result:** Version bumps from `1.0.0` → `1.1.0`

---

### Bug Fix (PATCH bump)

```bash
git add UI.lua
git commit -m "fix(ui): correct tooltip positioning on edge of screen

Tooltips now properly anchor when near screen edges
to prevent cutoff issues."
git push origin main
```

**Result:** Version bumps from `1.1.0` → `1.1.1`

---

### Breaking Change (MAJOR bump)

```bash
git add Core.lua Data/*.lua
git commit -m "feat!: redesign data structure for better performance

BREAKING CHANGE: Old ProfessionData table structure replaced.
Third-party addons using PH.Data will need updates."
git push origin main
```

**Result:** Version bumps from `1.1.1` → `2.0.0`

---

### Multiple Changes (batch commits)

```bash
# Fix a bug
git add FarmTracker.lua
git commit -m "fix: resolve farm tracker reset on reload"

# Add a feature
git add GatheringGuide.lua
git commit -m "feat: add mining routes for Outland zones"

# Push both
git push origin main
```

**Result:** Version bumps `1.0.0` → `1.1.0` (highest bump wins)

---

## 🎨 Scopes (Optional but Recommended)

Use scopes to indicate which part of the codebase changed:

```bash
feat(ui): add new settings panel
fix(tsm): correct price calculation for stacks
perf(data): optimize profession data loading
docs(readme): update installation instructions
chore(deps): update GitHub Actions versions
```

**Common scopes:**
- `ui` - User interface changes
- `core` - Core addon logic
- `data` - Profession data files
- `locales` - Translations
- `tsm` - TSM integration
- `api` - Public API changes
- `deps` - Dependencies
- `ci` - CI/CD workflows

---

## ⚠️ Breaking Changes

### Mark breaking changes with `!` or footer:

**Method 1: Exclamation mark**
```bash
git commit -m "feat!: remove deprecated API methods"
```

**Method 2: Footer**
```bash
git commit -m "feat: new configuration system

BREAKING CHANGE: Old config format no longer supported.
Users must reconfigure addon settings."
```

**Both trigger MAJOR version bump!**

---

## 🔍 Changelog Generation

Changelog is automatically generated from commit messages:

**Your commits:**
```bash
feat: add Alchemy guide
feat: add TSM shopping lists
fix: resolve tooltip bug
fix: correct material calculations
docs: update README
```

**Generated changelog:**
```markdown
## [1.1.0] - 2026-04-21

### ✨ Features
- add Alchemy guide
- add TSM shopping lists

### 🐛 Bug Fixes
- resolve tooltip bug
- correct material calculations
```

---

## 💡 Best Practices

### ✅ Good commits:

```bash
feat: add Engineering profession guide
fix: resolve crash when opening empty profession
perf: optimize material list rendering
docs: add FAQ section to README
refactor: simplify UI code structure
```

### ❌ Bad commits:

```bash
update files                    # Too vague
WIP                            # Not descriptive
Fixed stuff                    # No type prefix
Added new things and fixed bugs # Multiple concerns
```

---

## 🛠️ Local Setup

### Install commitizen (optional helper):

```bash
npm install -g commitizen cz-conventional-changelog

# Configure
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc

# Use it
git add .
git cz  # Interactive commit helper
```

### Install commitlint (optional validation):

```bash
npm install -g @commitlint/cli @commitlint/config-conventional

# Validate commit message
echo "feat: add new guide" | commitlint
```

---

## 📚 Quick Reference

### Version Bump Cheat Sheet:

```
fix:      1.0.0 → 1.0.1  (PATCH)
feat:     1.0.0 → 1.1.0  (MINOR)
feat!:    1.0.0 → 2.0.0  (MAJOR)

perf:     1.0.0 → 1.0.1  (PATCH)
refactor: 1.0.0 → 1.0.1  (PATCH)
revert:   1.0.0 → 1.0.1  (PATCH)

docs:     no release
style:    no release
chore:    no release
test:     no release
build:    no release
ci:       no release
```

### Common Commit Templates:

```bash
# Feature
git commit -m "feat(scope): add new functionality"

# Bug fix
git commit -m "fix(scope): resolve issue with X"

# Breaking change
git commit -m "feat!: remove deprecated API"

# Performance
git commit -m "perf: optimize data loading"

# Documentation
git commit -m "docs: update installation guide"

# Refactoring
git commit -m "refactor: simplify code structure"
```

---

## 🎯 Workflow Summary

1. **Make your changes**
2. **Stage files:** `git add .`
3. **Commit with conventional format:** `git commit -m "type: description"`
4. **Push to main:** `git push origin main`
5. **Wait ~2 minutes** - GitHub Actions handles the rest!
6. **Check Actions tab** to verify release

---

## 🆘 Troubleshooting

### "No release created"

**Cause:** Commits don't follow conventional format or are non-release types

**Solution:**
```bash
# Instead of:
git commit -m "added new feature"

# Use:
git commit -m "feat: add new feature"
```

### "Multiple releases for same commit"

**Cause:** Both manual tag and semantic-release running

**Solution:** Choose one approach:
- Use semantic-release (recommended) - no manual tags
- OR use manual tags - disable semver.yml workflow

### "Version mismatch after release"

**Cause:** Manual edits conflicting with automation

**Solution:** Let automation handle versions - don't edit manually

---

## 📖 Further Reading

- **Conventional Commits:** https://www.conventionalcommits.org/
- **Semantic Versioning:** https://semver.org/
- **Semantic Release:** https://semantic-release.gitbook.io/

---

**Ready to commit!** 🚀

Remember the format: `type(scope): description`

```bash
git commit -m "feat: your awesome new feature"
git push origin main
```

Then watch the magic happen! ✨
