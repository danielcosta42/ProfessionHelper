# Profession Helper — TBC Classic / Anniversary

**The complete profession toolkit for World of Warcraft: The Burning Crusade Classic.**

Profession Helper gives you optimized step-by-step leveling guides, automatic shopping lists, farming locations, a gold-making guide, and a real-time farm tracker — all in one clean in-game interface.

---

## Features

### Step-by-Step Leveling Guides
- Optimized routes for all professions from 1 to 375
- Visual step cards with current / next / done status
- Color-coded difficulty (Orange → Yellow → Green → Grey)
- Automatic progression tracking based on your current skill level

### Smart Shopping Lists
- Exact material quantities calculated for your skill range
- Bag and bank scanning — items you already carry are deducted automatically
- TSM and Auctionator price integration for real-time cost estimates
- Vendor vs. farmable material categorization
- One-click TSM string copy for quick AH searches

### Farm & Gathering Locations
- Zone-by-zone farming spots for Herbalism, Mining, and Skinning
- Floating gathering guide widget with minimap waypoint indicator
- Step-by-step route navigation with progress tracker

### Gold Farming Guide
- Gold-making tips for every profession at max skill (375)
- Covers transmutes, cooldowns, crafted items, consumables, and more
- Priority-ranked methods per profession

### Farm Tracker
- Real-time gold/hour calculation during farming sessions
- Tracks items looted, mob gold, and TSM estimated value
- Start / stop / reset via `/ph farm` or minimap right-click
- Floating HUD with session summary

### Cooldown Tracker
- Tracks profession cooldowns (Transmutation 24h, cloth cooldowns 84h, etc.)
- Shows time remaining until each cooldown is available again

### Recipe Tracker
- Shows which recipes you have and which ones are still missing
- Displays source info (vendor, trainer, drop, reputation) for missing recipes

### Alt Manager
- Tracks profession skill levels across all characters on the realm
- Quick overview of which alt has which profession maxed

### Disenchant & Prospecting Calculator
- Expected output calculator for Disenchanting and Prospecting
- Helps you decide if a DE or prospect is worth it at current AH prices

### Profession Coverage
- **Crafting:** Alchemy, Blacksmithing, Enchanting, Engineering, Jewelcrafting, Leatherworking, Tailoring
- **Gathering:** Mining, Herbalism, Skinning
- **Secondary:** Cooking, First Aid, Fishing
- **Combo guides:** Herbalism + Alchemy, Skinning + Leatherworking, Fishing + Cooking

### Multi-Language Support
- **Português (ptBR)** — Portuguese (Brazil)
- **English (enUS)** — Full English support
- **Español (esES / esMX)** — Spanish (EU / Latin America)
- Auto-detected from your WoW client language

---

## Installation

1. Download the latest release
2. Extract the `ProfessionHelper` folder
3. Place it in `World of Warcraft\_classic_\Interface\AddOns\`
4. Restart World of Warcraft or type `/reload` in-game

---

## Usage

| Command | Action |
|---|---|
| `/ph` | Open the main window |
| `/ph show` / `/ph hide` | Show or hide the window |
| `/ph farm` | Start a farm session |
| `/ph farm stop` | Stop the current session |
| `/ph farm reset` | Reset session data |
| `/ph help` | List all commands |

- **Left-click** the minimap icon to open the main window
- **Right-click** the minimap icon to start / stop the Farm Tracker

### Tips
- Orange steps always give a skill point — prioritize these
- Yellow steps have a ~75% chance — use them to fill gaps
- Green steps are inefficient — avoid unless materials are free
- Check the Shopping tab before logging off so you can buy mats in advance

---

## Compatibility

- World of Warcraft: The Burning Crusade Classic (2.5.x)
- WoW Classic Anniversary (Season of Discovery / Anniversary realms)
- **Optional:** TradeSkillMaster (TSM), Auctionator

---

## FAQ

**Do I need TSM?**
No. The addon works standalone. TSM and Auctionator add live price data to the shopping list.

**Does it work on Anniversary / Season of Discovery realms?**
Yes.

**Does it work on Retail WoW?**
No — it is designed specifically for TBC Classic API.

**Is it free?**
Yes, completely free and open source.

---

## Support the Project

If Profession Helper saves you time and gold, consider buying me a coffee! All donations go toward keeping the addon maintained and updated.

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?business=daniel.cfdutra13%40gmail.com&currency_code=USD)

---

## Credits

**Chehul @ DreamScyther-US**
- GitHub: [https://github.com/danielcosta42/ProfessionHelper](https://github.com/danielcosta42/ProfessionHelper)

Special thanks to the TBC Classic community for testing and feedback.

---

## Changelog

### 1.11.0
- Bag and bank scanner: materials you already own are automatically deducted from the shopping list

### 1.10.0
- Cooldown tracker: tracks Transmutation (24h) and cloth fabric cooldowns (84h)

### 1.9.0
- Recipe tracker: shows learned recipes and missing ones with their source

### 1.8.0
- Alt manager: track profession levels across all characters on the realm

### 1.7.0
- Disenchant & Prospecting calculator: expected output based on current AH prices

### 1.6.0
- Auctionator price support and improved price fallback logic (vendor sell price)

### 1.5.0 – 1.5.1
- Full multilingual support — all UI strings now auto-translate per client locale
- Fixed Portuguese text hardcoded in the Gold Farming guide and several UI elements

### 1.4.0
- Complete localization system: step cards, material labels, shopping list, TSM messages, gathering guide all translated
- Added 38 new localization keys across ptBR, enUS, and esES

### 1.0.0
- Initial release: all TBC profession guides (1–375), shopping list, farming locations, TSM integration, Gold Farming guide, Farm Tracker, dark UI, multi-language support


