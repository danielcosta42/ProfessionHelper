# ProfessionHelper — Crafter Marketplace (Design & Feasibility)

> Status: **Design proposal** (not yet implemented)
> Target client: WoW Classic **Anniversary / TBC Classic 2.5.6** (interface 20506)
> Companion addon: **PartyLens** (same author) — see [§8 Cross-addon synergy](#8-cross-addon-synergy-chehulnet)
> Last updated: 2026-07-04

A structured, in-game "crafter marketplace / open-orders network": players advertise
what they can craft, post what they want made, and browse open orders — all inside
the addon, with **zero external server**.

---

## 1. The hard constraint that shapes everything

WoW addons run in a sandbox with **no internet access and no persistent server**.
Every cross-player feature must ride in-game chat/addon channels. The single most
important fact for this design was verified empirically on the target client:

```
/run print(C_ChatInfo.SendAddonMessage("PLtest","ping","CHANNEL",GetChannelName("LookingForGroup") or 0))
--> 4   (Enum.SendAddonMessageResult.InvalidChatType)
```

**`SendAddonMessage` over `CHANNEL` is BLOCKED.** Blizzard removed the `CHANNEL`
chatType in Classic patch 1.13.3 to kill LFG-style "invisible broadcast to arbitrary
players" addons, and the restriction is in force on this client. There is therefore
**no hidden, server-wide addon broadcast**. This kills the naive "everyone joins one
channel and broadcasts listings" design.

> ⚠️ **PartyLens implication:** PartyLens's `Comm.lua` / `LayerNet.lua` mesh sends
> `SendAddonMessage(prefix, payload, "CHANNEL", n)` — every such call returns `4`
> and is silently dropped (no error, no `ADDON_ACTION_BLOCKED`). Its **invisible
> mesh has never delivered**. Its **visible-chat** features (beacon hearing requests
> via `CHAT_MSG_CHANNEL`, auto-invite) still work. See [§9](#9-partylens-mesh-fix).

### 1.1 Transports that actually work (the legal bus menu)

| Transport | Reach | Hidden? | Notes |
|---|---|---|---|
| `GUILD` / `OFFICER` addon msg | whole guild | yes | The only "many players at once" hidden bus. Trusted, low scam. |
| `PARTY` / `RAID` / `INSTANCE_CHAT` | current group | yes | While grouped. |
| `WHISPER` addon msg | one named target | yes | Targeted handshake / order routing. |
| `SAY` / `YELL` addon msg | ~40 yd proximity | yes | Great at capital **AH/bank hubs** (dense, thematically the trade spot). |
| `SendChatMessage` → custom channel | realm-wide, same faction | **no (visible)** | GreenWall-style relay. **Hardware-gated outdoors** (one click per line) + throttled (~10 lines/10 s) + auto-filtered by spam addons. User-click only. |
| **Passive read** of Trade/General/LFG chat (`CHAT_MSG_CHANNEL`) | realm-wide human supply | receive-only | **Not blocked, not throttled.** The backbone (see §3). |

**Design consequence:** we cannot build a hidden realm-wide network. We build a
**local opportunities board fed by four supply sources**, each tagged with its
`source`, all merged into one identical UI and matcher. The board is transport-
agnostic and degrades gracefully.

---

## 2. What already exists (reuse, don't rebuild)

ProfessionHelper already holds the entire **supply-side** dataset locally. A
marketplace is mostly *exposing and matching* data the addon already has.

| Capability | API | Marketplace use |
|---|---|---|
| Identity / faction / realm | `PH.Identity:GetCharKey()` → `"Name-Realm"`, `:GetFaction()`, `:GetClass()`, `:GetLevel()` | Tag every listing; faction gate. |
| Cross-alt crafter roster | `PH.AltManager:GetAllCharsOnRealm()`, `:GetCharProfessions(name)` | "Which of my chars can craft, at what skill." |
| Known-recipe ledger | `PH.RecipeTracker:IsKnown(prof, recipe)`, `:GetMissingRecipes(prof)` | Match an order to a char that **knows** the recipe. |
| Inventory (bags+bank, cross-alt) | `PH.BagScanner:GetCount(name)`, `:GetAllAltCounts()`, `:GetAltCount(name)` | Do I already hold the mats to fill an order? |
| Prices (TSM/Auctionator + 24h cache) | `PH.TSM:GetItemPrice(name)`, `:GetItemPriceByID(id)`, `:CalculateCost(mats)`, `:FormatMoney(copper)` | Fair-price suggestion, mats cost, profit estimate. |
| Profession cooldowns | `PH.CooldownTracker:GetAllForCurrentChar()` | "Transmute ready → I can fill this now." |
| Bill of materials | `PH:GetProfessionData(prof).recipes[]` (`{name, materials={{name,count}}}`) | What an order consumes. |
| Item id ↔ icon (reagents) | `PH.Materials[name] = {id, icon, ...}` | Normalize names→ids; row icons. |

**Foundation services:** `PH.DB:Get/Set/Ensure` (dot-path SavedVariables), `PH.Event:On/Off/Fire`
(shared event frame — subscribe `CHAT_MSG_CHANNEL` / `CHAT_MSG_ADDON` here, never
`CreateFrame` yourself), `PH.Config`, `PH.Logger`, `PH:PersistFrameLayout(frame, key)`.

### 2.1 Gaps to fill

- **No networking layer at all** — build prefix registration, send, receive routing, throttle from scratch.
- **Recipes keyed by NAME string**, no crafted-output itemID. Name matching works for the MVP; a **craft-output name↔itemID map** is needed for portable network matching (Phase 2). `Data/Materials.lua` only covers *reagents*, not craft outputs.
- **Names are localized** → normalize to itemID before any wire message.
- `C_ChatInfo` is **not** in `.luacheckrc` `read_globals` → add it (+ `GetChannelName`, `JoinTemporaryChannel`, `Ambiguate` as used) or CI lint fails (zero-warning policy).

---

## 3. Architecture: one board, four supply sources

```
                       ┌───────────────────────────────────────┐
   Trade/LFG chat ───► │  source="scan"   (passive parse)        │
   (realm-wide human)  │                                         │
   Guildmates (PH) ──► │  source="guild"  (ChehulNet addon msg)  │──► MATCHER ──► BOARD (UI)
   City AH hub ──────► │  source="hub"    (SAY/YELL proximity)   │    (enrich)    1-click whisper
   My own alts ──────► │  source="self"   (local capability)     │
                       └───────────────────────────────────────┘
```

The **matcher** enriches every raw listing with local knowledge — do I know the
recipe? do I hold the mats? is my cooldown ready? what's the profit vs TSM? — and
ranks the board by actionability. All four sources produce the same record shape,
so the UI and matcher are written once.

### 3.1 The backbone: `source="scan"` (Trade-chat scanner)

Passively parse `CHAT_MSG_CHANNEL` (Trade/General/LookingForGroup) + `CHAT_MSG_YELL`.
This is **realm-wide, faction-scoped, zero cold-start, zero ToS risk, sends nothing.**
It works for a single user on day one because the "supply" is humans, not addon peers.

- **Extract** item links → exact `itemID` + name via `item:(%d+)` (the addon already
  does this in `FarmTracker.lua:268`). Bracket name via `|h%[(.-)%]|h`.
- **Classify** intent (WTS / WTB / LFW "looking for work" / offering service) with a
  confidence-scored keyword classifier (localized; borrow PartyLens's `LocalizedKeywords` approach).
- **Match** against `RecipeTracker` (I know it) + `BagScanner` (I have mats) +
  `CooldownTracker` (ready) + `TSM` (profit) → surface **fillable** requests first.
- **Ephemeral rows** with ~10-min TTL + dedup by (sender, itemID) — the CraftScan UX.
- **Never auto-respond.** 1-click opens a prefilled whisper; the human sends it.
  (CraftScan's deliberate rule; auto-whispering Trade reads as spam and gets reported.)

### 3.2 `source="guild"` — structured listings over GUILD

For guildmates who also run the addon: broadcast structured offers/orders over the
`GUILD` addon-message bus (hidden, trusted). Merged into the same board. This is the
real "addon-to-addon network," honestly scoped to where a hidden bus exists.

### 3.3 `source="hub"` — proximity broadcast at the auction house

Opt-in: while standing at a capital-city AH/bank, broadcast craftable offers via
`SAY`/`YELL` addon messages (~40 yd). City hubs are dense and are *where trading
already happens* — a "marketplace at the AH." Addon-user-to-addon-user only.

### 3.4 `source="self"` — my own alts

From `AltManager` + `RecipeTracker` + `CooldownTracker`: "which of my characters can
fill this, and is the cooldown ready." No network needed; useful immediately.

---

## 4. Data model (SavedVariables)

New root `ProfessionHelperDB.marketplace`, seeded via `PH.DB:Ensure("marketplace")`
in `PH.Marketplace:Initialize()` (mirrors AltManager/BagScanner).

```lua
marketplace = {
  listings = {
    [id] = {                 -- id = source..":"..sender..":"..itemID
      kind    = "offer"|"order",   -- offer = "I can make X"; order = "I want X made"
      who     = "Name-Realm",      -- unspoofable CHAT_MSG sender
      itemID  = 21877,             -- normalized; never a localized name on the wire
      name    = "Netherweave Bag", -- display only (viewer locale)
      qty     = 1,
      price   = 120000,            -- copper, optional
      note    = "mats provided",   -- optional, short
      source  = "scan"|"guild"|"hub"|"self",
      ts      = 1720000000,
      ttl     = 600,               -- seconds
    },
  },
  seenPeers  = { ["Name-Realm"] = { addons={pl=true,ph=true}, faction, class, level, ts } }, -- ChehulNet
  reputation = { ["Name-Realm"] = { filled=3, cancelled=0, ts } },  -- local, display-only
  config     = { scanTrade=true, guildSync=true, hubBroadcast=false, autoWhisper=false },
}
```

Bump `PH.DB.SCHEMA_VERSION` + add a migration only if the shape changes later.

---

## 5. Wire protocol (compact, versioned, itemID-keyed)

Payloads ≤ **255 bytes**, no NUL, pipe-delimited, protocol tag first, **append-only
fields** for cross-version compat (older clients ignore trailing fields). Prefix
`"PHMkt"` (≤16 chars), registered via `C_ChatInfo.RegisterAddonMessagePrefix`.

```
PHM1|L|<offer|order>|<itemID>|<qty>|<priceCopper>|<flags>[|<note>]   listing
PHM1|C|<itemID>                                                      cancel (tombstone)
PHM1|D|<count>|<itemID:ts,itemID:ts,...>                             digest (anti-entropy)
PHM1|P|<itemID>                                                      pull (request full listing)
```

- Single listings fit raw. Only **batch digests** may exceed 255 B → then embed
  **LibStub + LibSerialize + LibDeflate** (`CompressDeflate` → `EncodeForWoWAddonChannel`)
  and chunk/reassemble (or use **AceComm-3.0**, which chunks for you).
- Send through **ChatThrottleLib** at `BULK` priority so marketplace traffic never
  starves other addons and never disconnects the client. Handle
  `Enum.SendAddonMessageResult.AddonMessageThrottle (3)` with back-off.
- Budget well under **10 msgs / 10 s per prefix** (server throttle). Guild sync =
  low-frequency digests + pull-on-demand, never a firehose.
- All libs are pure-Lua / embeddable and run on Classic (WeakAuras/RCLootCouncil ship
  them on Classic). No `Libs/` dir exists today — create one.

---

## 6. UI

New panel `UI/MarketplaceUI.lua` following the `AltManagerUI` pattern
(`PH:ShowMarketplaceUI()` toggle + `PH:UpdateMarketplaceUI()`, registered with
`PH:PersistFrameLayout(frame, "marketplace")`, refreshed via a `PH_MARKET_UPDATED`
event subscription). Tabs:

1. **Oportunidades** — WTB/LFW you can fill right now: *know recipe ✓ · have/estimate mats · cooldown ready · profit vs TSM*, ranked. 1-click → prefilled whisper.
2. **Pedidos abertos** — the full order board (all sources), filterable by profession/item.
3. **Minhas ofertas** — advertise what my alts craft; toggle guild/hub broadcast.

Discoverability: a toolbar icon entry in `UI/Main.lua` `CreateMainWindow` and a
`/ph market` slash subcommand in `PH:HandleSlashCommand`.

---

## 7. Anti-spam, trust, ToS (non-negotiable)

Grounded in Blizzard's UI AddOn policy + community norms (BadBoy/spam-filter reality):

- **Free, open-source, no ads, no donations solicited** in-addon (Blizzard policy).
- **Never auto-post to Trade** — hardware-gated + spammy + auto-filtered. Visible
  posts are user-click, one line at a time, throttled via CTL.
- **Never auto-whisper** — 1-click, human-confirmed (CraftScan lesson).
- **Trust = display-only local reputation** keyed on the unspoofable CHAT_MSG sender
  name. No auth, no escrow (WoW P2P trade is manual and scam-prone — the addon can
  never make trades safe; it only surfaces *information*). Say so in the UI.
- **Privacy** — broadcasting craftables/inventory is self-disclosure; guild + hub
  broadcast are **opt-in**; don't persist others' data past TTL.
- **Ephemeral** — TTL + dedup; the board is a live view, not a database of strangers.

---

## 8. Cross-addon synergy (`ChehulNet`)

Goal: **both addons work standalone, but communicate and enrich each other.**
Achieved with a tiny **shared convention** (not a hard dependency) — a versioned
identity/presence handshake both addons speak, over the **legal** buses (GUILD +
WHISPER + PARTY/RAID; **not** CHANNEL).

```
Prefix: "ChehulNet"  (registered by BOTH addons)
CHN1|hello|<addonsCsv>|<faction>|<class>|<level>|<flags>
     e.g.  CHN1|hello|pl,ph|Horde|MAGE|70|crafter
```

- **Sent** on login over `GUILD` (throttled), on group join over `PARTY/RAID`, and
  on-demand over `WHISPER` when you interact with someone (e.g. before whispering a
  crafter you found in Trade).
- **Both addons listen.** If the other addon isn't installed, the ping is simply
  unanswered — nothing breaks (loose coupling).
- **Enrichment:**
  - PartyLens badges an LFM leader / group member as "🔨 crafter (Alchemy 375)".
  - ProfessionHelper knows a guildmate/whisper-target runs PH and can request their
    craftable list; ranks known-addon peers above cold trade-chat rows.
  - A trade-chat crafter you found → optional WHISPER handshake reveals they also run
    PartyLens / are LFG, and their exact offerings.

**Implementation path:**
- **A — shared convention (MVP):** copy a ~40-line send/receive helper + freeze the
  `ChehulNet` payload spec in both addons. Zero coupling, both standalone.
- **B — embedded micro-lib (target):** extract transport + handshake into
  `LibChehulMesh-1.0` embedded (LibStub) in **both** addons — no install dependency,
  one code path, one in-memory peer registry. Migrate once the protocol stabilizes.

---

## 9. PartyLens mesh fix (separate track)

The `4` result confirms PartyLens's invisible mesh is dead on this client. To restore
presence sync / layer-number convergence / invisible mesh requests, its cross-player
traffic must move **off** `SendAddonMessage("CHANNEL")` to a legal transport:

- **GUILD** addon msg — trivial, but too narrow for realm-wide *layer hopping*
  (layers span the realm, guild doesn't).
- **GreenWall-style visible relay** — `SendChatMessage` to a custom channel joined via
  `JoinTemporaryChannel`; realm-wide, same-faction, but **visible** + hardware-gated
  (so only the requester's click-driven post, not the beacon's background sync) +
  throttled. This matches how PartyLens's *working* half already operates.

Its beacon → auto-invite path (driven by scanning **visible** chat) is unaffected.
Track this fix independently of the marketplace.

---

## 10. Roadmap

| Phase | Scope | Transport | Cold-start | Risk |
|---|---|---|---|---|
| **1 — MVP** | Scan board + capability matcher + "my alts can craft" + 1-click whisper | receive-only | **none** (solo-useful) | none |
| **2 — Network + synergy** | `ChehulNet` handshake (GUILD/WHISPER) + structured guild listings merged via `source` tag + craft-output name↔itemID map + embed LibStub/LibSerialize/LibDeflate/CTL. PartyLens cross-badges. | GUILD + WHISPER (hidden) | low (guild) | low |
| **3 — Reach (opt-in)** | SAY/YELL hub proximity at city AH; optional GreenWall-style visible-channel relay; extract `LibChehulMesh` into both addons | proximity + visible relay | medium | medium (spam/ToS) |

**Recommendation:** ship Phase 1 (the confirmed-locked MVP: offers + open-orders board
+ 1-click whisper, fed by the scanner + local alts). It delivers value with zero
network effect, then Phase 2 layers the real addon-to-addon network and the PartyLens
synergy on the legal buses. Phase 3 is demand-gated.

---

## Appendix — how to wire the feature module

1. `Features/Marketplace.lua`: `PH.Marketplace = {}; function M:Initialize()` →
   `PH.DB:Ensure("marketplace")`, `C_ChatInfo.RegisterAddonMessagePrefix("PHMkt")`
   (+`"ChehulNet"`), subscribe `PH.Event:On("CHAT_MSG_CHANNEL", handler, "Marketplace")`
   and `"CHAT_MSG_ADDON"`. On receive → `PH.DB:Set` + `PH.Event:Fire("PH_MARKET_UPDATED", ...)`.
2. `UI/MarketplaceUI.lua`: `PH:ShowMarketplaceUI()` (toggle pattern) + `PH:UpdateMarketplaceUI()`.
3. `ProfessionHelper.toc`: add `Features\Marketplace.lua` **before** `Core\Init.lua`;
   `UI\MarketplaceUI.lua` after it.
4. `Core/Init.lua`: `if PH.Marketplace then PH.Marketplace:Initialize() end` in
   `OnAddonLoaded`; add `/ph market` branch + help line in `HandleSlashCommand`.
5. `Core/Config.lua` (+ `Core/Storage.lua` ROOT_DEFAULTS): add `marketplace_*` defaults.
6. Locale keys in `Locales/{enUS,ptBR,esES}.lua` (Lua 5.1 forbids `\u`).
7. `.luacheckrc`: add `C_ChatInfo` (+`GetChannelName`, `JoinTemporaryChannel`,
   `Ambiguate`) to `read_globals`; run `luacheck . --config .luacheckrc` → exit 0.
