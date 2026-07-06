-- Profession Helper - Raid Consumables (TBC)
-- Recommended raid consumables by ROLE (TBC consumables are role-based, not raid-
-- specific: the same flask/food/oil is used across Karazhan → Sunwell). Items are
-- keyed by NAME so GetItemCount / GetItemInfo resolve them without hardcoded IDs.
--   cat  = "flask" | "battle" | "guardian" | "food" | "potion" | "weapon" | "util"
--   want = how many you'd bring (checklist threshold)

ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.RaidConsumables = {
    order = { "flask", "battle", "guardian", "food", "potion", "weapon", "util" },

    roles = {
        { key = "tank", label = "Tank", items = {
            { name = "Flask of Fortification",        cat = "flask",    want = 1, note = "+500 HP, +10 defense" },
            { name = "Elixir of Major Fortitude",     cat = "guardian", want = 5, note = "+250 HP, +10 HP5 (if not flasking)" },
            { name = "Elixir of Major Defense",       cat = "guardian", want = 5, note = "+550 armor (if not flasking)" },
            { name = "Elixir of the Mongoose",        cat = "battle",   want = 5, note = "+25 agi, +2% crit (if not flasking)" },
            { name = "Spicy Crawdad",                 cat = "food",     want = 10, note = "+30 stam, +20 spirit" },
            { name = "Super Healing Potion",          cat = "potion",   want = 10, note = "burst healing" },
            { name = "Ironshield Potion",             cat = "potion",   want = 5, note = "+2500 armor 2 min" },
            { name = "Adamantite Sharpening Stone",   cat = "weapon",   want = 5, note = "+12 crit rating (edged)" },
            { name = "Drums of Battle",               cat = "util",     want = 1, note = "party +80 haste (Leatherworking)" },
        } },

        { key = "melee", label = "Melee DPS", items = {
            { name = "Flask of Relentless Assault",   cat = "flask",    want = 2, note = "+120 attack power" },
            { name = "Elixir of Major Agility",       cat = "battle",   want = 5, note = "+35 agi, +20 crit (if not flasking)" },
            { name = "Elixir of Major Mageblood",     cat = "guardian", want = 5, note = "+16 MP5 (hybrids)" },
            { name = "Warp Burger",                   cat = "food",     want = 10, note = "+20 agi, +20 spirit" },
            { name = "Super Healing Potion",          cat = "potion",   want = 10, note = "burst healing" },
            { name = "Haste Potion",                  cat = "potion",   want = 5, note = "+400 haste 15s" },
            { name = "Insane Strength Potion",        cat = "potion",   want = 5, note = "+120 str, -75 defense" },
            { name = "Adamantite Sharpening Stone",   cat = "weapon",   want = 5, note = "+12 crit rating (edged)" },
            { name = "Drums of Battle",               cat = "util",     want = 1, note = "party +80 haste (Leatherworking)" },
        } },

        { key = "caster", label = "Caster DPS", items = {
            { name = "Flask of Pure Death",           cat = "flask",    want = 2, note = "+80 fire/frost/shadow damage" },
            { name = "Adept's Elixir",                cat = "battle",   want = 5, note = "+24 spell dmg, +24 crit (if not flasking)" },
            { name = "Elixir of Major Mageblood",     cat = "guardian", want = 5, note = "+16 MP5" },
            { name = "Blackened Basilisk",            cat = "food",     want = 10, note = "+23 spell dmg, +20 spirit" },
            { name = "Super Mana Potion",             cat = "potion",   want = 10, note = "mana restore" },
            { name = "Destruction Potion",            cat = "potion",   want = 5, note = "+120 spell dmg, +2% crit" },
            { name = "Super Healing Potion",          cat = "potion",   want = 5, note = "burst healing" },
            { name = "Superior Wizard Oil",           cat = "weapon",   want = 5, note = "+42 spell damage" },
            { name = "Drums of Battle",               cat = "util",     want = 1, note = "party +80 haste (Leatherworking)" },
        } },

        { key = "healer", label = "Healer", items = {
            { name = "Flask of Mighty Restoration",   cat = "flask",    want = 2, note = "+25 MP5" },
            { name = "Elixir of Healing Power",       cat = "battle",   want = 5, note = "+50 healing (if not flasking)" },
            { name = "Elixir of Draenic Wisdom",      cat = "guardian", want = 5, note = "+30 int, +20 spirit" },
            { name = "Golden Fish Sticks",            cat = "food",     want = 10, note = "+44 healing, +20 spirit" },
            { name = "Super Mana Potion",             cat = "potion",   want = 10, note = "mana restore" },
            { name = "Fel Mana Potion",               cat = "potion",   want = 5, note = "big mana (5 min buff penalty)" },
            { name = "Super Healing Potion",          cat = "potion",   want = 5, note = "burst healing" },
            { name = "Superior Mana Oil",             cat = "weapon",   want = 5, note = "+14 MP5" },
            { name = "Drums of Restoration",          cat = "util",     want = 1, note = "party mana/health regen (Leatherworking)" },
        } },
    },
}
