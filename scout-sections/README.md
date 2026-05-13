# Scout-sections — handoff

**Deliverable 7 of ~14.** Implements the `scout-sections` redesign from
the rev-2 mockup: a responsive grid of N cards (1–6, typically 5)
auto-rendered from `data/scout_sections.toml`. Each card is a single
anchor linking to that section's scouts.org.uk page. Consumes the
shared `.sect-head` pattern shipped in D5.

Pure-CSS. No JavaScript. en-GB. Verified end-to-end with three real
Hugo builds (see `VERIFICATION.txt`).

## What's in this tarball

```
README.md                                            ← you are here
VERIFICATION.txt                                     ← test results

assets/css/17-section-scout-sections.css             ← NEW. .s-scout-sections,
                                                       .s-scout-sections__grid,
                                                       .s-scout-sections__card (+ ::before),
                                                       .s-scout-sections__logo,
                                                       .s-scout-sections__info,
                                                       .s-scout-sections__age,
                                                       .s-scout-sections__lm + .arr,
                                                       .s-scout-sections__btn.

assets/images/sections/squirrels.svg                 ← NEW PLACEHOLDER.
assets/images/sections/beavers.svg                   ← NEW PLACEHOLDER.
assets/images/sections/cubs.svg                      ← NEW PLACEHOLDER.
assets/images/sections/scouts.svg                    ← NEW PLACEHOLDER.
assets/images/sections/explorers.svg                 ← NEW PLACEHOLDER.
assets/images/sections/network.svg                   ← NEW PLACEHOLDER.

scout-sections-html.patch                            ← Modify the partial:
                                                       full rewrite to whole-card
                                                       anchor, .sect-head head,
                                                       inline SVG, no per-Group
                                                       logo override, no
                                                       button_style schema field.

data-scout-sections-toml.patch                       ← Modify the data file:
                                                       .webp → .svg on all six
                                                       logo paths; comment
                                                       block updated.

documentation-DECISIONS-md.patch                     ← Update Brand & visual:
                                                       theme now ships official
                                                       Scouts section SVGs;
                                                       per-Group override gone
                                                       for section logos.

documentation-SPEC-COMMON-md.patch                   ← One-line alignment with
                                                       new policy.

CLAUDE-md.patch                                      ← One-line alignment with
                                                       new policy.
```

⚠️ **The SVGs in this tarball are PLACEHOLDERS.** They show the section
name in white/black on the section's identity colour, so the build
renders sensibly during integration. Each SVG has a comment at the
top saying so. **Before publishing the theme, replace each of the six
`assets/images/sections/<key>.svg` files with the official Scouts
section logo SVG downloaded from <https://scoutsbrand.org.uk>.** The
CSS sizing rules (`.s-scout-sections__logo svg` — `max-height: 100%;
max-width: 100%; width: auto`) handle whatever viewBox the brand SVGs
use, including wordmarks of different aspect ratios.

## How to apply (from theme root)

```sh
# 1. Drop in the new files (CSS, six placeholder SVGs)
tar -xzf D7-scout-sections.tar.gz --strip-components=1

# 2. Apply the five modifications
patch -p1 < scout-sections-html.patch
patch -p1 < data-scout-sections-toml.patch
patch -p1 < documentation-DECISIONS-md.patch
patch -p1 < documentation-SPEC-COMMON-md.patch
patch -p1 < CLAUDE-md.patch

# 3. Delete the orphan WebP placeholders (their data-file references are gone)
rm assets/images/sections/{squirrels,beavers,cubs,scouts,explorers,network}.webp

# 4. Verify the build
cd exampleSite
hugo serve --buildDrafts=false --buildFuture=false
```

## Schema changes

### Removed

- `button_style` — the new design fixes the button look to
  `.s-scout-sections__btn` (primary-coloured pill at desktop, hidden
  on mobile). If your `[[sections]]` entries set
  `button_style = "primary"`, drop the field; the visual is the same.
  Any other value is silently ignored (and was already meaningless
  visually after this change).

### Added (optional, all default to inert)

- `eyebrow` — small uppercase lead-in above the h2, e.g. "Our Sections".
- `align` — `"left"` applies `.sect-head--left`; anything else (or
  unset) keeps the head centred.

### Unchanged

- `id`, `bg`, `title`, `title_color`, `subtitle`, `button_label`.
- Group-side `[params.scoutSections]` — same enable / disable
  semantics. Network still defaults to off (data-file
  `default_enabled = false`).

## Breaking changes beyond schema

- **Subtitle wrapper changes from `<div>` to `<p>`** via the shared
  `.sect-head` pattern. Same caveat as D5's section-header
  migration: if your subtitle contains block-level HTML
  (`<ul>`, `<div>`, `<p>` nested inside, etc.) the rendered HTML
  becomes invalid. Inline HTML (`<a>`, `<em>`, `<strong>`,
  `<br>`) is fine. Plain text is fine.

- **Outer `<section>` class changes** from `s-section-grid` to
  `s-scout-sections`. The generic `section-grid` partial still
  exists with its `s-section-grid` CSS for non-Scout-section grids
  (see `assets/css/13-section-grid.css`); the two no longer share
  rules.

- **Card markup changes** from `<article>` containing a separate
  `<a class="btn">` to a single `<a class="s-scout-sections__card">`
  wrapping the entire card. The Learn-more button-look is now a
  non-interactive `<span class="s-scout-sections__btn">` inside that
  parent anchor. Bigger touch target, no nested anchors,
  screen-reader-friendly.

- **Per-Group `params.scoutSections.<key>.logo` override is no
  longer read.** Brand asset maintenance is centralised in the
  theme. If any consuming site set this override, the new code
  silently ignores it — the theme's logo wins.

## Architecture notes

### Identity colour source

Each card's accent strip colour comes from `data/scout_sections.toml`'s
`color` field, delivered via inline `style="--sec: #25B755;"` on the
card. This is the same value the rest of the theme uses for section
badges (news cards, event cards, gallery covers, joining cards) per
`documentation/SPEC-COMMON.md` §7.

Sourcing from the data file rather than introducing new global
`--sec-squirrels` / `--sec-beavers` / … palette tokens means:

1. One source of truth — the data file already documents the colours
   and their derivation (challenge-badge outer-ring values, with
   brand-book substitutions per DECISIONS.md).
2. Cross-spec consistency — a "scouts" card on the home page uses the
   same red strip as a "Scouts" badge pill on a news card linking to
   that section.
3. No palette token sprawl. The mockup's `--sec-*` tokens implied
   global per-section palette entries; the data file approach avoids
   that. (`--accent` and `--warning` remain global palette tokens
   because they cross sections.)

### Inline SVG

Logos are inlined via `resources.Get .logo` + `.Content | safeHTML`
in the partial. The SVG's native colours render at any size; the
CSS sizing rules (`.s-scout-sections__logo svg` with
`max-height: 100%; max-width: 100%; height: 100%; width: auto`) accept
any viewBox aspect ratio so the real Scouts wordmarks (e.g. Squirrels
174×39, Beavers 166×46, Cubs 110×43, Scouts 148×27, Explorers 168×18,
Network 130×29) all fit cleanly.

The placeholder SVGs in this tarball use a 220×44 viewBox —
intentionally generic so the placeholder layout looks reasonable. The
real wordmarks have varying aspect ratios; the CSS handles them.

### The 2×2 override (exactly four cards)

```css
.s-scout-sections__grid:has(> .s-scout-sections__card:nth-child(4):last-child)
  .s-scout-sections__card {
  flex: 0 0 calc(50% - 0.625rem);
  max-width: 380px;
}
```

`:has()` selects the grid when exactly four cards are present (`:nth-child(4)`
is also `:last-child`) and overrides the default 3-across to 2×2.
Browser support: Firefox ≥ 121, Safari ≥ 15.4, Chrome ≥ 105 — modern
defaults. Older browsers degrade to 3+1, which is still readable.

The default 3-across handles every other count: 1 (single, centred),
2 (pair centred), 3 (row), 5 (3+2, last row centred), 6 (3+3).
Tested all three of: 5, 6, and 4. See `VERIFICATION.txt`.

### Whole-card anchor

The whole card is a single `<a>` element. Inside it:

- `.s-scout-sections__logo` — `aria-hidden="true"` (the section name
  is in the `aria-label` on the anchor)
- `.s-scout-sections__info` — age + inline "Learn more →" (mobile
  view; hidden at ≥ 768 px)
- `.s-scout-sections__btn` — pill-shaped "Learn more" lookalike
  (desktop view; hidden at < 768 px). NOT an `<a>` or `<button>` — a
  `<span>`. The parent anchor handles the click; the span gives the
  visual affordance.

The card's `aria-label` reads e.g. *"Learn more about Squirrels (4 to
6 years)"*, so a screen reader announces the full target before the
section name and age repeat in the inner content.

### File slot

`17-section-scout-sections.css` slot 17 — next free in the section
band after D6:

```
10-section-hero
11-section-two-col-cta
12-section-two-col-image-cta
13-section-grid                  (generic section-grid partial)
14-section-stacked-features
15-section-join                  (D6)
16-section-embed
17-section-scout-sections        ← NEW (D7)
```

(D5's deletion of `15-section-header.css` left a gap which D6 filled;
this slot is the next-up.)

## What this does NOT include

- **The real Scouts brand SVGs.** Placeholders only — see ⚠️ above.
  Replace before publishing.
- **README.md updates.** The top-level README.md has some pre-existing
  drift around per-Group logo overrides ("Each Group must download
  alternative images, if desired"). Per the new policy, section logos
  ship with the theme and Groups don't substitute. The README.md
  paragraph in question is ambiguously worded and could be read either
  way — flagging here for a separate documentation cleanup. Not
  modified in this deliverable.
- **The volunteering image (`assets/images/volunteer/role-model.webp`)
  policy.** Unchanged. That image stays a generic placeholder Groups
  override at the same path. Only the six section logos move to
  centralised-brand-asset status.
- **adscouts adoption.** Live `hugo-adscouts` gets brought onto the
  new design as part of deliverable 14.

## What comes next

D8 — `events` section redesign (event card visual update).
