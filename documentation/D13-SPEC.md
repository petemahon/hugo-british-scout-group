# D13-SPEC — Where-we-meet + Footer

**Status:** shipped.
**Track:** final deliverable in the D5–D13 visual-redesign sweep.
**Predecessors:** D5 (sect-head + eyebrow), D11 (brand-anchor band pattern,
`<symbol id="fleur">` global SVG, `--scouts-*-hover` tokens), D12 (BSO card
pattern, `color-mix` faded text tier).
**Successor:** D14 (adscouts adoption).

## What this ships

Two unrelated visual blocks closed in one deliverable:

1. **Where-we-meet map** — the existing generic `embed` section type is
   re-styled to match the mockup's `.meet-map` visual: aspect-ratio
   driven (4:3 mobile → 16:9 desktop), rounded corners (18 → 24 px),
   soft shadow. Pre-D13 the partial enforced explicit pixel
   `height` / `width` defaults; D13 drops those defaults and lets them
   become optional overrides.
2. **Footer** — complete rewrite from a single-line copyright surface
   into the mockup's brand-anchor four-column layout: brand block +
   three configurable link columns + bottom strap. Always Scouts Navy.

## Design rationale (the 8 confirmed decisions)

### Where-we-meet

1. **Re-style `embed`, do NOT introduce a dedicated `where-we-meet`
   section type.** Generic; the iframe shape works for any map. One
   fewer section type to maintain.

2. **Skip the mockup's `.map-legend` pill row** (stat tags like "4 huts
   · 5 sections · 300+ young people"). The stats are content-specific;
   the theme shouldn't ship example values. Groups can render their own
   stats with a `prose` section directly below the embed.

3. **Use `--section-py` rhythm** for the outer section padding — D7
   precedent. The mockup's bespoke 56/96 px values discarded.

4. **Aspect-ratio default + optional explicit override.** Default sizing
   is 4:3 mobile → 16:9 desktop, border-radius 18 → 24, shadow
   `0 12px 32px rgba(20,17,14,0.08)`. Front-matter `height` / `width`
   still emit inline styles that win on specificity — back-compat for
   any consumer who'd pinned a fixed pixel height.

### Footer

5. **Add `--scouts-navy` (`#003982`) and `--scouts-navy-hover`
   (`#14529e`)** to `00-tokens.css` block 1b. `#003982` already appears
   in two other places — `--sec-explorers` (D7) and the hardcoded
   `.s-bg-dark` rule in `02-layout.css` — confirming canonical
   provenance. The `--scouts-navy-hover` value continues D10/D11's
   pattern of choosing a slightly-lighter sibling that doesn't ride the
   site palette.

6. **`[params.footer]` schema** with `tagline` (string) and `columns`
   array. Each column has `heading` (string) and `items` (array of
   `{label, url?}`). Maximum four columns to fit the desktop grid;
   beyond that, content overflows the row. Sensible default ordering
   (brand block + Visit/Contact/About) shipped in the example site.

7. **`footerStrap` i18n key** — default `"Skills for Life ·
   #SkillsForLife"`. Sites can override to remove the hashtag,
   substitute their own strapline, or empty the value to suppress the
   strap entirely. Other branded strings in the theme follow the same
   i18n-key pattern.

8. **`styled-link` sentinel on every footer anchor.** Footer is a
   `.s-bg-dark`-equivalent surface (Scouts Navy); the auto-underline
   rule in `02-layout.css` would underline every link by default. The
   sentinel opts out; the footer-specific `.site-footer__link:hover`
   rule restores underline as the canonical hover affordance.

## What changed in the working tree

### New files (full content)

```
layouts/partials/footer.html              wholesale rewrite
assets/css/30-footer.css                  wholesale rewrite
documentation/D13-SPEC.md
```

### Modified files (patches)

```
assets/css/00-tokens.css                  +2 navy tokens
assets/css/16-section-embed.css           full rewrite (4 lines → 41)
layouts/partials/sections/embed.html      drop default height/width
i18n/en.toml                              +footerStrap key
exampleSite/hugo.toml                     drop footerBg, +[params.footer]
exampleSite/content/_index.md             block 10 — drop explicit sizing
README.md                                 +D13 tag on 30-footer.css line
```

### Breaking changes

**The `params.footerBg` mechanism is gone.** Pre-D13 the footer accepted
`"muted" | "primary" | "secondary" | "tertiary" | "accent" | "dark"`
and applied an `.s-bg-<value>` tone. D13 makes the footer a brand-anchor
surface — always Scouts Navy regardless of palette — so the param is
silently ignored if set. Consuming sites with `footerBg` in their
hugo.toml render correctly; the param is just dead weight.

The example site's `hugo.toml` removes the line. Groups not yet on D13
keep their existing behaviour; on adoption their `footerBg` becomes
no-op. No warnings emitted by Hugo.

## Visual contract

### Where-we-meet (`.s-embed__frame`)

- Mobile (<768 px): aspect-ratio 4:3, border-radius 18 px, shadow
  `0 12px 32px rgba(20,17,14,0.08)`.
- Desktop (≥768 px): aspect-ratio 16:9, border-radius 24 px, same
  shadow.
- Front-matter `height` / `width`: emitted as inline styles, override
  the aspect-ratio.

### Footer (`.site-footer`)

- Background: `var(--scouts-navy)`, locked.
- Padding: 48/24 px mobile, 64/28 px desktop.
- Grid: 1 col mobile → 2 col @560 → `2fr 1fr 1fr 1fr` @900.
- Brand block: 28 px fleur SVG + 22 px Group name + 14.5 px tagline,
  max-width 30ch, opacity 0.75.
- Column heading (`<h5>`): 12.5 px, weight 700, letter-spacing 0.12em,
  uppercase, opacity 0.7.
- List items: 14.5 px, line-height 1.45, white 0.85 alpha.
- Bottom strap: top border `rgba(255,255,255,0.15)`, padding-top 20 px,
  font-size 12.5 px, opacity 0.7.

## Acceptance criteria

1. `hugo --buildDrafts=false --buildFuture=false` from `exampleSite/`
   exits clean.
2. Footer renders Scouts Navy regardless of selected palette.
3. Footer responsive grid: stacks at <560 px; 2-up at 560–899 px;
   4-up (brand + 3 cols) at ≥900 px.
4. Footer anchor hover: white text + underline. Focus-visible: 2 px
   white outline ring.
5. With `palette = "network"` (black/orange palette), footer still
   navy — confirms brand-anchor wins.
6. Map embed renders 4:3 on mobile, 16:9 on desktop. Setting
   `height = "600px"` in `_index.md` block 10 reverts to fixed-pixel
   height (back-compat).
7. Print preview: footer collapses to copyright line + strap on
   white, top-bordered.
8. Bottom strap: copyright left, "Skills for Life · #SkillsForLife"
   right; reflows to two lines at narrow viewport.
9. Setting `footerStrap = ""` in site `i18n/en.toml` suppresses the
   right-hand strap label entirely.
10. No `.site-footer` or `.s-embed__frame` selectors leak outside this
    deliverable's two CSS files.

## Deferred items

- **`.s-bg-dark` hardcoded `#003982` in `02-layout.css`.** Same hex as
  the new `--scouts-navy` token. Refactor to `var(--scouts-navy)` for
  consistency. Out of D13 scope.
- **Pre-D13 `footerBg` param removal.** Currently silently ignored.
  Future cleanup pass can grep consuming sites and remove the dead
  param entries.
- **Orphaned CSS from D9.** `.s-news__head` rules in
  `40-section-news.css` are unused by the home block but may still be
  used by `/news/` listing layouts. Verify before deleting.
- **`.badges` component relocation.** Lives in `21-section-events.css`
  but is now cross-section (events + news + possibly future features).
  Future move to `06-components-badges.css`.
- **BSO-vs-Network section order swap.** Mockup vs example site
  disagree; visually defensible either way.

## What's next

D14 — adscouts adoption. The consuming site (1stadscouts.org) inherits
D5–D13 by bumping the theme submodule. Per-Group content that overrides
the example values:

- `groupPrefix` / `groupSuffix` → "1st Abu Dhabi" / "Scouts"
- `[params.bsoMembershipNotice]` host country/association → UAE
- `[params.footer]` columns → real address, contact, links
- `palette` → consuming-site preference
- `[[sections]]` content in `_index.md` → group-specific copy
- `data/scout_sections.toml` enables only the sections the group runs

No code expected to change in adscouts as part of D14 — purely a
content adoption. Any code change there signals a missing theme
parameterisation that should be flagged back upstream.
