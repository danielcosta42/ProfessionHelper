# GitHub Automation

This directory contains GitHub Actions workflows for automated CI/CD.

## 📁 Structure

```
.github/
├── workflows/
│   ├── semver.yml        # 🤖 Automatic semantic versioning (RECOMMENDED)
│   ├── release.yml       # 📦 Manual release publishing
│   ├── validate.yml      # ✅ Code validation & linting
│   └── package-test.yml  # 🧪 Test package creation
├── scripts/
│   ├── update-version.sh # Update version in files
│   └── publish-addon.sh  # Publish to platforms
├── CONVENTIONAL-COMMITS.md  # Commit format guide
├── CICD-SETUP.md           # Complete setup guide
└── RELEASE-GUIDE.md        # Manual release guide
```

## 🚀 Two Release Methods

### Method 1: Automatic (Recommended) 🤖

**Use conventional commits for automatic versioning:**

```bash
# Bug fix → version 1.0.0 → 1.0.1
git commit -m "fix: resolve tooltip bug"
git push origin main

# New feature → version 1.0.0 → 1.1.0
git commit -m "feat: add Jewelcrafting guide"
git push origin main

# Breaking change → version 1.0.0 → 2.0.0
git commit -m "feat!: redesign UI"
git push origin main
```

**See:** [CONVENTIONAL-COMMITS.md](CONVENTIONAL-COMMITS.md)

### Method 2: Manual 📋

**Create tags manually:**

```bash
git tag v1.0.0
git push origin v1.0.0
```

**See:** [RELEASE-GUIDE.md](RELEASE-GUIDE.md)

## 🎯 Workflows

### 1. Semantic Release (`semver.yml`) - AUTOMATIC ✨
**When:** Every push to main with conventional commits

Automatically:
- Analyzes commit messages
- Determines version bump (MAJOR/MINOR/PATCH)
- Updates version in files
- Generates changelog
- Creates tag and release
- Publishes to platforms

### 2. Release & Publish (`release.yml`) - MANUAL
**When:** Push version tag (e.g., `v1.0.0`)

Manually triggered:
- Creates release package
- Uploads to GitHub Releases
- Publishes to CurseForge
- Publishes to WoWInterface

### 3. Validate Code (`validate.yml`)
**When:** Push to main/develop or PR

Checks:
- Lua syntax errors
- File structure
- TOC validation
- Localization completeness

### 4. Test Package (`package-test.yml`)
**When:** Pull request or manual

Tests:
- Package creation
- Structure validation
- Size verification

## 📖 Documentation

- **[CONVENTIONAL-COMMITS.md](CONVENTIONAL-COMMITS.md)** - How to write commits for auto-versioning
- **[CICD-SETUP.md](CICD-SETUP.md)** - Complete CI/CD setup guide
- **[RELEASE-GUIDE.md](RELEASE-GUIDE.md)** - Manual release instructions

## ⚡ Quick Start

### Automatic Versioning (Recommended):

```bash
# Make your changes
git add .

# Commit with conventional format
git commit -m "feat: add new profession guide"

# Push to main
git push origin main

# Done! Version bumped automatically 🎉
```

### Manual Release:

```bash
# Update versions manually
# Then create tag
git tag v1.0.0
git push origin v1.0.0
```

## 🎨 Commit Types

| Type | Version | Example |
|------|---------|---------|
| `fix:` | PATCH | `fix: resolve tooltip bug` |
| `feat:` | MINOR | `feat: add guide` |
| `feat!:` | MAJOR | `feat!: redesign UI` |

See full guide: [CONVENTIONAL-COMMITS.md](CONVENTIONAL-COMMITS.md)
