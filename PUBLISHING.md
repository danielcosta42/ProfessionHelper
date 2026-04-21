# Profession Helper - Publishing Guide

## Pre-Release Checklist

### Code Quality
- [x] All features tested in-game
- [x] No Lua errors in BugGrabber/BugSack
- [x] UI scales properly on different resolutions
- [x] All professions (1-375) verified
- [x] TSM integration tested (with and without TSM)
- [x] Multi-language support verified (PT/EN/ES)

### Documentation
- [x] README.md complete and professional
- [x] CHANGELOG.md updated with version info
- [x] LOCALIZATION.md with translation guide
- [x] LICENSE file included
- [x] In-game credits popup implemented
- [x] All code comments clear and helpful

### Files & Structure
- [x] .toc file properly configured
- [x] All required files included
- [x] .gitignore created
- [x] No development/test files in release
- [x] Proper folder structure

---

## Where to Publish

### 1. **CurseForge** (Recommended - Primary)
- Website: https://www.curseforge.com/wow/addons
- Process:
  1. Create account
  2. "Create a Project" → WoW Addons
  3. Upload your addon ZIP file
  4. Fill in project details:
     - **Name:** Profession Helper - TBC
     - **Summary:** Complete profession leveling guide with smart routes, shopping lists & TSM integration
     - **Category:** Professions
     - **Game Version:** The Burning Crusade Classic (2.5.4)
     - **Tags:** professions, leveling, guide, tsm, crafting, gathering
  5. Upload screenshots (UI examples)
  6. Publish!

### 2. **WoWInterface** (Alternative)
- Website: https://www.wowinterface.com/
- Process:
  1. Create account
  2. "Upload Addon"
  3. Fill in addon details
  4. Upload ZIP file
  5. Submit for approval

### 3. **GitHub Releases**
- Repository: https://github.com/danielcosta42/profession-helper-tbc
- Process:
  1. Push code to GitHub
  2. Create new Release (v1.0.0)
  3. Upload packaged ZIP
  4. Write release notes (copy from CHANGELOG.md)
  5. Publish release

### 4. **WoW Addon Subreddits**
- r/classicwow
- r/wowaddons
- Share with link to CurseForge/GitHub

---

## How to Package for Release

### Create Release ZIP
1. **Remove development files:**
   - Delete `.git` folder (if exists)
   - Delete test files
   - Delete `.vscode`, `.idea` folders

2. **Verify file structure:**
   ```
   ProfessionHelper/
   ├── ProfessionHelper.toc
   ├── README.md
   ├── CHANGELOG.md
   ├── LOCALIZATION.md
   ├── LICENSE
   ├── Core.lua
   ├── UI.lua
   ├── PathCalculator.lua
   ├── TSMIntegration.lua
   ├── FarmTracker.lua
   ├── FarmTrackerUI.lua
   ├── GatheringGuide.lua
   ├── Locales/
   │   └── Locales.lua
   └── Data/
       ├── Materials.lua
       ├── Alchemy.lua
       ├── Blacksmithing.lua
       ├── Enchanting.lua
       ├── Engineering.lua
       ├── Jewelcrafting.lua
       ├── Leatherworking.lua
       ├── Tailoring.lua
       ├── Cooking.lua
       ├── FirstAid.lua
       ├── Mining.lua
       ├── Herbalism.lua
       ├── Skinning.lua
       ├── Fishing.lua
       ├── GoldFarming.lua
       ├── HerbalismAlchemy.lua
       ├── SkinningLeatherworking.lua
       └── FishingCooking.lua
   ```

3. **Create ZIP:**
   - Right-click `ProfessionHelper` folder
   - "Send to" → "Compressed (zipped) folder"
   - Rename to: `ProfessionHelper-v1.0.0.zip`
   - **OR** use command line:
     ```bash
     zip -r ProfessionHelper-v1.0.0.zip ProfessionHelper/ -x "*.git*" "*.vscode*"
     ```

---

## Marketing & Promotion

### Screenshots to Include
1. Main UI with profession selected
2. Shopping list tab with TSM prices
3. Farming locations for gathering profession
4. Step-by-step leveling guide
5. Credits/About popup
6. Combo profession guide example

### Promotional Text Template

**Title:**  
"Profession Helper - Complete TBC Profession Leveling Guide (PT/EN/ES)"

**Short Description:**  
"Optimize your profession leveling with smart routes, automated shopping lists, and TSM integration. Supports all TBC professions with multi-language support."

**Long Description:**
```
🌟 Profession Helper - Your Ultimate TBC Profession Companion

Level all professions efficiently with optimized, step-by-step guides that save you time and gold!

✨ KEY FEATURES:
• Smart leveling routes (1-375) for ALL professions
• Automatic shopping lists with TSM price integration
• Farming locations for gathering professions
• Beautiful, modern interface with dark theme
• Multi-language: Portuguese, English, Spanish
• No configuration needed - works out of the box!

📊 PROFESSIONS COVERED:
✓ Crafting: Alchemy, Blacksmithing, Enchanting, Engineering, Jewelcrafting, Leatherworking, Tailoring
✓ Gathering: Mining, Herbalism, Skinning
✓ Secondary: Cooking, First Aid, Fishing
✓ Combo Guides: Herbalism+Alchemy, Skinning+Leatherworking, and more!

💎 SMART FEATURES:
• Color-coded recipes (Orange/Yellow/Green/Grey)
• Cost calculation with TSM
• Vendor vs. farmable material indicators
• Progress tracking with visual feedback
• One-click TSM import for shopping

🌍 MULTI-LANGUAGE:
Fully translated to Portuguese (BR), English, and Spanish with auto-detection!

💡 EASY TO USE:
Just type /ph or click the minimap icon to get started!

🔧 TSM INTEGRATION:
Works seamlessly with TradeSkillMaster for accurate pricing, but works great standalone too!

⭐ 100% FREE & OPEN SOURCE
Check out the code on GitHub: github.com/danielcosta42

Made with ❤️ for the TBC Classic community!
```

### Tags/Keywords
- professions
- leveling
- guide
- tbc
- classic
- crafting
- gathering
- tsm
- shopping
- alchemy
- blacksmithing
- enchanting
- engineering
- jewelcrafting
- leatherworking
- tailoring
- mining
- herbalism
- skinning
- cooking
- fishing

---

## Post-Release Tasks

### Monitor Feedback
- [ ] Check CurseForge comments daily
- [ ] Respond to GitHub issues
- [ ] Monitor WoWInterface forums
- [ ] Check Reddit posts

### Updates & Maintenance
- [ ] Fix reported bugs promptly
- [ ] Consider feature requests
- [ ] Update for new WoW patches
- [ ] Maintain documentation

### Community Engagement
- [ ] Thank users for feedback
- [ ] Share success stories
- [ ] Create video tutorial (optional)
- [ ] Write blog post (optional)

---

## Version Numbering

Follow Semantic Versioning (SemVer):
- **MAJOR.MINOR.PATCH** (e.g., 1.0.0)
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

Examples:
- 1.0.0 - Initial release
- 1.0.1 - Bug fix
- 1.1.0 - New feature added
- 2.0.0 - Major rewrite

---

## Support Channels

Provide these channels for users:
1. **GitHub Issues** (Primary) - Bug reports & features
2. **CurseForge Comments** - General discussion
3. **Discord** (Optional) - Community chat
4. **Email** (Optional) - Private support

---

## Legal & Compliance

### Things to Remember:
✅ Addon complies with Blizzard's ToS
✅ No selling of addon (free only)
✅ Proper attribution in code
✅ MIT License allows modifications
✅ GitHub repo is public
✅ No trademarked assets used
✅ Only uses Blizzard's official API

### Copyright Notice:
Always include in .toc and main files:
```
-- Profession Helper
-- Copyright (c) 2026 Chehul @ DreamScyther-US
-- MIT License - Free for personal use
-- https://github.com/danielcosta42
```

---

## Success Metrics

Track these after release:
- Downloads/installs
- User ratings
- Active users
- GitHub stars
- Issue resolution time
- Community feedback

**Goal:** Help 1000+ players level their professions efficiently! 🎯

---

Good luck with your release! 🚀
