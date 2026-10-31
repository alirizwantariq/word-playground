# Changelog — Word Playground

All notable changes to this project are documented here. The Play Console
"What's new" text for each release lives in
`store-listing/listing.md` §8 (500-char limit).

## 2.1.0 — Oct 31, 2026

### Renamed & rebranded
- **New name: Word Playground** (formerly "Word Play"). The old name is used
  by many existing Play Store apps; the new one was verified against the
  stores before adoption.
- **New app icon**: W + P letter tiles threaded on a rope (playground rope +
  the game's linked chains) with a gold star — replaces the generic
  chain-links + bolt. Regenerated in every density including adaptive
  foreground/background/monochrome layers.
- New Play feature graphic and all 18 store screenshots re-captured from a
  real Android device (phone 1080×1920, tablet 1600×2560).

### Word Hunt: 12-level difficulty ladder (replaces timed modes)
- 12 levels across three tiers: **EASY (1–4) · MEDIUM (5–8) · HARD (9–12)**.
  The old BLITZ/RUSH/CLASSIC picker is gone.
- The grid changes rows/cols on every level (5×5 up to 9×9); word count grows
  from 3 to 8 and word lengths ramp up.
- **EASY is untimed** with short words and no diagonals (kid-friendly);
  MEDIUM adds diagonals + generous clocks; HARD adds words reading
  **backwards (↩)** and tighter clocks.
- Completing a level unlocks the next, pays coins (25 first time, 5 on
  replays) and offers **NEXT LEVEL ▶**.

### Hints now live inside the game
- **HINT · 25 coins** — glows a word's first letter (as before).
- **✨ HINTS · WATCH AD** — new in-game button: one optional rewarded ad
  enables periodic letter glows for the rest of that level.

### Settings: per-game stats
- New GAME STATS block: Chain Reaction (★ stars + levels done), Word Duel
  (duels played, words solved), Word Hunt (levels done, words found, best
  score).

### Fixes found by on-device testing (Android emulator)
- **Startup crash**: the AdMob init callback ran `RewardedAd.load` on a
  background thread → `IllegalStateException`. Now dispatched to the UI thread.
- **Tap-through ghost click**: finishing a Chain Reaction level could
  "click" the freshly-appeared NEXT button under the still-lifting finger;
  overlays now shield real taps for 400 ms.
- **Word Hunt timer kept running after leaving** the screen, popping
  TIME'S UP over other screens; both navigation paths now stop it.
- Back-button arrows rendered off-center (font glyph metrics) → crisp SVG
  icons on all seven back buttons.
- Hunt header showed the time twice; score chip looked like coins; HINT
  button had no label; duel setup header not right-aligned; write-screen
  title truncated; home CTA wrapped mid-label; locked pack cards showed
  blurred ghost text.
- WebView could serve stale cached JS after an app update → asset responses
  now send `Cache-Control: no-store`.
- Self-tests are hermetic (no longer depend on persisted device state).
- Predictive back: `enableOnBackInvokedCallback` in the manifest.

### Tablet / large screens
- New ≥700px layout: bigger type, roomier tiles and grids, centered home —
  the game fills a 10" screen instead of floating in a phone column.

### QA
- 78/78 engine tests (`?demo=test`), 80/80 levels verified solvable
  (`?demo=verify`), 29/29 real-tap flows on an Android emulator, layout
  audits clean at 412×732 / 360×640 / 800×1280, 0 crashes across repeated
  cold launches.

## 2.0.0 — Oct 2026

Initial release-ready build.

- **Chain Reaction** — link related words to build chains; 80 hand-crafted
  levels in 8 packs, 3 hearts, combo scoring, hint coins, Endless mode.
- **Word Duel** — pass-and-play "Guess the Word" for 2–4 players: one secret
  word each, 6 shared hearts, animated banter callouts, live dictionary
  suggestions, invite-friends sharing.
- **Word Hunt** — words hidden across/down/diagonal in a letter grid with
  drag or tap-first-tap-last selection and tap-outside cancel.
- **Word of the Day** — 120 words with one-line facts, rotating daily.
- Offline-first: all games fully playable without internet.
- Ads: optional rewarded ads (+100 coins / letter hints) and capped
  between-round interstitials (max 1 per 3 rounds, 2-minute gaps), Google
  UMP consent flow with in-app Privacy options, child-directed treatment
  (non-personalised, G-rated), debug builds use Google test ad units and
  release builds read real IDs from `gradle.properties`.
- Native Android shell: WebView + `WebViewAssetLoader` (assets served
  locally), immersive fullscreen, Android back-button integration,
  rewarded/interstitial ad bridge, share sheet.
- Privacy policy hosted on GitHub Pages; full Play Console listing assets.