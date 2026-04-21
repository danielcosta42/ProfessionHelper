# Profession Helper - TBC Classic

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.3-blue.svg)
![WoW](https://img.shields.io/badge/WoW-TBC%20Classic-orange.svg)
![License](https://img.shields.io/badge/license-Free%20for%20Personal%20Use-green.svg)
![Languages](https://img.shields.io/badge/languages-PT%20%7C%20EN%20%7C%20ES-brightgreen.svg)

[![Release](https://github.com/danielcosta42/ProfessionHelper/actions/workflows/release.yml/badge.svg)](https://github.com/danielcosta42/ProfessionHelper/actions/workflows/release.yml)
[![Validate](https://github.com/danielcosta42/ProfessionHelper/actions/workflows/validate.yml/badge.svg)](https://github.com/danielcosta42/ProfessionHelper/actions/workflows/validate.yml)

**The ultimate profession leveling guide for World of Warcraft: The Burning Crusade Classic**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Support](#-support) • [Credits](#-credits)

</div>

---

## 🌟 Features

### 📊 **Smart Leveling Guides**
- **Step-by-step optimized routes** for all professions (1-375)
- **Automatic skill progression tracking** with visual feedback
- **Cost-efficient paths** that minimize material waste
- **Color-coded difficulty** indicators (Orange/Yellow/Green/Grey)

### 🛒 **Intelligent Shopping Lists**
- **Automatic material calculation** based on your current skill
- **TSM price integration** for accurate cost estimates
- **Vendor vs. Farmable** material categorization
- **One-click TSM import** for auction house searches

### 🗺️ **Farm & Gathering Locations**
- **Zone-specific farming spots** for all gathering professions
- **Level-appropriate locations** with coordinates
- **Efficiency ratings** for each farming route
- **GatherMate2 integration** (optional)

### 💎 **Profession Coverage**
- ✅ **Crafting:** Alchemy, Blacksmithing, Enchanting, Engineering, Jewelcrafting, Leatherworking, Tailoring
- ✅ **Gathering:** Mining, Herbalism, Skinning
- ✅ **Secondary:** Cooking, First Aid, Fishing
- ✅ **Combo Guides:** Herbalism+Alchemy, Skinning+Leatherworking, Fishing+Cooking

### 🎨 **Modern Interface**
- **Premium minimalist design** with clean aesthetics
- **Dark theme optimized** for long gaming sessions
- **Responsive layout** that adapts to your workflow
- **Icon-driven navigation** for quick profession switching

### 🌍 **Multi-Language Support**
- 🇧🇷 **Português (ptBR)** - Portuguese (Brazil)
- 🇺🇸 **English (enUS)** - Full English support
- 🇪🇸 **Español (esES/esMX)** - Spanish (EU/Latin America)
- **Auto-detection** based on your WoW client language

---

## 📥 Installation

### Method 1: Manual Installation
1. Download the latest release from [GitHub](https://github.com/danielcosta42/profession-helper-tbc)
2. Extract the `ProfessionHelper` folder
3. Place it in your `World of Warcraft\_classic_\Interface\AddOns\` directory
4. Restart World of Warcraft or reload UI (`/reload`)

### Method 2: Git Clone (for developers)
```bash
cd "World of Warcraft\_classic_\Interface\AddOns\"
git clone https://github.com/danielcosta42/profession-helper-tbc.git ProfessionHelper
```

---

## 🎮 Usage

### Opening the Addon
- **Slash command:** `/ph` or `/profhelper`
- **Minimap button:** Click the Profession Helper icon (if enabled)

### Basic Workflow
1. **Select a profession** from the sidebar (icons on the left)
2. **View your current step** in the leveling guide
3. **Check materials needed** for your skill range
4. **Use the shopping tab** to see what to buy
5. **Farm locations** are shown for gathering professions

### TSM Integration
- **Automatic price calculation** when TSM is installed
- **Click "Copy TSM Import"** to copy shopping list
- **Paste in TSM** to create import group
- **One-click AH searches** for all materials

### Tips & Tricks
- 💡 **Orange recipes** always give skill points
- 💡 **Yellow recipes** have 75% chance for skill-ups
- 💡 **Green recipes** only 25% chance (use sparingly)
- 💡 Look for **vendor-bought materials** to save gold
- 💡 **Combine gathering + crafting** for maximum profit

---

## 🔧 Configuration

Currently, Profession Helper works out-of-the-box with sensible defaults. Future versions will include:
- Minimap button position customization
- UI scale adjustments
- Material price source selection
- Custom guide routes (advanced users)

---

## 🤝 Support

### Bug Reports & Suggestions
Found a bug or have a feature request? Please report it on:
- **GitHub Issues:** [https://github.com/danielcosta42/profession-helper-tbc/issues](https://github.com/danielcosta42/profession-helper-tbc/issues)

### FAQ

**Q: Does this work with Retail WoW?**  
A: No, this addon is specifically designed for TBC Classic (2.5.4).

**Q: Do I need TSM for this to work?**  
A: No, TSM is optional. The addon works great standalone, but TSM adds price calculations.

**Q: Can I suggest new features?**  
A: Absolutely! Open an issue on GitHub with your ideas.

**Q: Is this addon free?**  
A: Yes, completely free for personal use. The code is open source.

**Q: Which professions are supported?**  
A: All TBC professions including combo guides (e.g., Herbalism + Alchemy).

---

## 🏆 Credits

### Developer
**Chehul @ DreamScyther-US**
- GitHub: [https://github.com/danielcosta42](https://github.com/danielcosta42)
- Realm: DreamScyther-US (TBC Classic)

### Special Thanks
- **Blizzard Entertainment** - for World of Warcraft
- **TSM Team** - for the amazing TradeSkillMaster addon
- **TBC Classic Community** - for testing and feedback
- **All contributors** who helped test and improve this addon

### Open Source
This addon is free and open source. Feel free to:
- ✅ Use it for your personal gameplay
- ✅ Share it with friends
- ✅ Contribute improvements on GitHub
- ✅ Translate to additional languages

### Data Sources
Profession data verified using:
- Official TBC Classic databases
- Community-tested leveling routes
- Personal testing across multiple characters
- Feedback from beta testers

---

## 📜 License

**Free for Personal Use**

This addon is provided free of charge for personal, non-commercial use. The source code is available on GitHub under a permissive license that allows:
- Personal use
- Modification for personal use
- Distribution of the original or modified versions (with credit)

**Not permitted:**
- Commercial use without permission
- Claiming as your own work
- Removing author credits

---

## 📝 Changelog

### Version 1.0.0 (2026-04-21)
- 🎉 **Initial Release**
- ✅ Complete guides for all TBC professions (1-375)
- ✅ Multi-language support (PT/EN/ES)
- ✅ TSM integration for pricing
- ✅ Shopping list generator
- ✅ Farming location database
- ✅ Modern UI with dark theme
- ✅ Icon-driven navigation
- ✅ Auto-detection of player skill level
- ✅ Combo profession guides
- ✅ Material cost calculation

---

## �‍💻 For Developers

### Automated CI/CD
This project uses **GitHub Actions** for automated building, testing, and publishing:

- ✅ **Automatic releases** when you push version tags
- ✅ **Code validation** on every commit
- ✅ **Package testing** on pull requests
- ✅ **Multi-platform publishing** (GitHub, CurseForge, WoWInterface)

**Quick Release:**
```bash
git tag v1.0.0
git push origin v1.0.0
# Watch automation in the Actions tab!
```

See [.github/CICD-SETUP.md](.github/CICD-SETUP.md) for complete setup guide.

### Contributing
Contributions are welcome! Here's how:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes using **Conventional Commits** format:
   ```bash
   git commit -m "feat: add amazing feature"
   git commit -m "fix: resolve bug in X"
   git commit -m "docs: update README"
   ```
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

The validation workflow will automatically check your code!

**Commit Format Guide:** Use conventional commits for automatic versioning:
- `feat:` - New features (bumps MINOR version)
- `fix:` - Bug fixes (bumps PATCH version)
- `docs:` - Documentation only (no version bump)
- `feat!:` - Breaking changes (bumps MAJOR version)

See [Conventional Commits Guide](.github/CONVENTIONAL-COMMITS.md) for details.

### Development Setup
```bash
# Clone repository
git clone https://github.com/danielcosta42/ProfessionHelper.git

# Navigate to directory
cd ProfessionHelper

# Make changes and test in WoW
# Commit with conventional format
git commit -m "feat: your new feature"

# Push - version will be automatically bumped!
git push origin main
```

**Automatic Releases:** This project uses semantic versioning. When you push commits to `main` with conventional format, a new version is automatically released. No manual version updates needed!

---

## �🔮 Roadmap

### Planned Features
- [ ] In-game configuration panel
- [ ] Custom route editor
- [ ] Bank & bag integration
- [ ] Recipe tracker with missing recipes
- [ ] Profit calculator for crafted items
- [ ] Alt character tracking
- [ ] Export/import custom guides
- [ ] Achievement integration
- [ ] More language support (FR, DE, RU)

---

<div align="center">

**Made with ❤️ for the TBC Classic community**

[⬆ Back to Top](#profession-helper---tbc-classic)

</div>
