# CLAUDE.md

Context for Claude Code working on the **Hugo British Scout Group**
theme. Loaded automatically at the start of every session.

If anything in this file conflicts with `documentation/DECISIONS.md`
or `documentation/SPEC-COMMON.md`, those files win — they are the
authoritative source of truth. This file points at them.

---

## What this project is

A reusable Hugo theme for UK Scout Groups, with first-class support
for **British Scouting Overseas (BSO)** Groups via a dedicated
membership-notice partial. Used in production by `1stadscouts.org`
(consumed via `hugo-adscouts`, a separate repo) and intended for
adoption by other UK Scout Groups — particularly BSO Groups.

- **Licence:** CC BY-SA 4.0 © Peter Mahon. Keep `LICENSE` intact in
  any refactor.
- **Theme name on disk:** `british-scout-group`. Deliberately
  general-purpose — BSO is a first-class feature, not the only use
  case.
- **Repo:** https://github.com/petemahon/hugo-british-scout-group
- **Consuming site (separate repo):**
  https://github.com/petemahon/hugo-adscouts
- **Old Mobirise predecessor (reference only, do not maintain):**
  https://github.com/petemahon/adscouts

---

## Architecture (locked invariants — flag, don't change)

- Hugo extended, **min version 0.156**. The Pages workflow pins
  `0.157.0`.
- `<html lang="en-GB">` is **hardcoded** in `baseof.html`. No locale
  parameter. Adding locale support is a flag-not-change event.
- **No JavaScript dependency anywhere.** Sticky nav, smooth scroll,
  fade-in animations, the events `events-upcoming` block, the
  cancelled-event badge, the dual-time rendering — all pure CSS.
  Adding JS is a flag-not-change event. A native-share feature was
  proposed and explicitly declined for this reason.
- **No backend services, no third-party tracking scripts** (no
  analytics, social embeds, comment systems, payment widgets,
  livechat, tracking font CDNs).
- **Official Scout section logo SVGs** ship in the theme at
  `assets/images/sections/<key>.svg`, downloaded from
  https://scoutsbrand.org.uk by the theme maintainer. Groups do
  NOT override these — brand asset maintenance is centralised.
  **Other visual assets** shipped at theme paths are generic
  placeholders; Groups override at the same path in their site repo.
- **Group-specific values live only in the consuming site's
  `hugo.toml` and `content/`.** Nothing in the theme code may
  reference Abu Dhabi, the BSO Group's name, or any Group's
  specifics. The only Group-specific string anywhere in the theme is
  Peter's name in `LICENSE`.

---

## The spec pack — primary reference

The full feature roadmap and conventions live under `documentation/`.
Read these before changing anything substantial:

| File | When to read |
| --- | --- |
| `documentation/DECISIONS.md` | **Always.** Locked-in choices. Read before suggesting anything that touches palettes, the section types list, BSO, navigation, accessibility, demo data, or the en-GB scope rule. |
| `documentation/SPEC-COMMON.md` | **Always.** Shared conventions every feature spec assumes. Section partial idiom, palette tokens, taxonomies, image pipeline defaults, safeguarding lint pattern, i18n naming, build validation order. |
| `documentation/specs/SPEC-NN-*.md` | When implementing that specific feature. |
| `documentation/D13-SPEC.md` | Reference for the D5–D13 visual redesign sweep — closing deliverable, footer + where-we-meet contract, breaking changes. |

Suggested recommended implementation order is in
`documentation/README.md` (the feature-pack README, distinct from the
top-level `README.md`).

---

## Working preferences (Peter)

These take priority over Claude Code's general defaults:

- **Always confirm design decisions before implementing.** Don't
  assume. Present resolved questions together as a bulk slate rather
  than piecemeal — Peter's working style is decisive bulk
  confirmation.
- **English only, en-GB** for visitor-facing text and documentation
  prose (`colour`, `programme`, `organisation`, `behaviour`,
  `licence`, `centre`, `enrolled`). **Code identifiers — TOML field
  keys, CSS class names, template variables — follow source-code
  conventions and may use US spelling where idiomatic** (`color`,
  `text_color`, `bg`, `bg_muted`). See DECISIONS.md §"en-GB scope".
- **Validate builds incrementally.** Don't write a sprawl of
  templates and try to build at the end. The SPEC-COMMON §13 build
  order — data files first, then partial with hardcoded content,
  then dispatcher wiring, then front-matter schema, then CSS, then
  i18n, then example content — is the canonical sequence.
- **No bash in this session.** Claude Code edits files in the
  working tree only; Peter runs `make serve`, `make build`,
  `git diff`, `git commit`, `git push`, and any `gh` commands
  himself. The settings in `.claude/settings.json` enforce this.
- **Handoff format note:** prior chat sessions used `.patch` files
  and tarballs because the chat couldn't touch the working tree.
  That pattern is obsolete under Claude Code — edits land directly
  in files. The SPEC-02 handoff doc that pattern produced has since
  been retired (SPEC-02 is fully shipped). Future handoff documents,
  if needed, should describe state and decisions, not delivery format
  — `D13-SPEC.md` is the current reference shape for that kind of
  closing-deliverable record.

---

## Things to flag, not silently change

Per Peter's working method, these need explicit confirmation before
any change is made:

- Locale handling (the theme is en-GB-only by design).
- Adding JavaScript anywhere in the theme.
- Adding a sixth named palette preset (vs. editing existing hex
  values to track Scouts brand updates — editing is the expected
  maintenance path).
- Anything that would make the theme depend on a specific Group's
  content or images.
- Anything that would make the theme BSO-specific in code (BSO
  features remain optional add-ons, not assumptions).
- Adding content from copyrighted Scout brand assets rather than
  Group materials or scoutsbrand.org.uk downloads.
- Renaming or removing any of the canonical section types listed in
  DECISIONS.md.
- Renaming the three always-on nav anchors (`#joining`,
  `#our-sections`, `#where-we-meet`) — these are part of the
  theme's stable contract.
- The BSO membership notice copy (aligned with The Scout
  Association's POR 3.2.1.1 — don't reword without flagging).
- Bumping `theme.toml` `min_version`.

---

## Repo layout (orientation)

```
hugo-british-scout-group/
├── CLAUDE.md                      # this file
├── .claude/
│   └── settings.json              # Claude Code permissions
├── theme.toml                     # theme metadata
├── LICENSE                        # CC BY-SA 4.0 © Peter Mahon
├── README.md                      # public-facing theme README
├── Makefile                       # make serve | build | roll | clean
├── archetypes/                    # `hugo new` scaffolds
├── assets/
│   ├── css/theme.css              # all design tokens at the top
│   └── images/                    # generic placeholders only
├── data/
│   ├── palettes.toml              # five palette presets
│   └── scout_sections.toml        # age/section metadata + badge colours
├── i18n/
│   └── en.toml                    # translatable strings
├── layouts/
│   ├── _default/                  # baseof, single, list
│   ├── index.html                 # home — dispatches to section partials
│   ├── events/                    # SPEC-02 — listing, single, .ics
│   ├── news/                      # SPEC-01 — listing, single
│   └── partials/
│       ├── head.html              # meta + CSS pipeline + palette injection
│       ├── header.html            # sticky nav
│       ├── footer.html            # Group's own copyright
│       ├── palette-style.html     # emits chosen palette as CSS vars
│       ├── bso-membership-notice.html
│       ├── event-*.{html,ics}     # SPEC-02 partials
│       ├── news-*.html            # SPEC-01 partials
│       ├── section-badges.html    # shared across content types
│       └── sections/              # one partial per [[sections]] type
├── scripts/
│   └── roll-example-dates.py      # demo-roller for exampleSite events
├── exampleSite/                   # demo site + test fixture
│   ├── hugo.toml
│   ├── assets/                    # placeholder images
│   └── content/
│       ├── _index.md              # home page [[sections]] array
│       ├── news/                  # example news posts
│       ├── events/                # example events (with [demo] blocks)
│       └── palettes/_index.md     # palette reference page
└── documentation/
    ├── DECISIONS.md
    ├── SPEC-COMMON.md
    ├── README.md                  # feature-pack reading order
    ├── D13-SPEC.md                # D5-D13 redesign sweep closing record
    └── specs/
        └── SPEC-01-news.md … SPEC-12-accessibility.md
```

---

## Dev loop (Peter runs these, not Claude Code)

From the repo root:

```sh
make serve   # roll example dates forward, then `hugo serve`
make build   # roll example dates forward, then `hugo --minify`
make roll    # just run the date-roller
make clean   # discard the date-roller's in-flight edits
```

`make clean` runs `git checkout -- exampleSite/content/events/`,
reverting the demo-roller's working-tree changes. Run it before any
commit that should not include rolled dates.

If running from inside `exampleSite/` (e.g. after editing in place):

```sh
make -C .. clean && hugo serve --buildDrafts=false --buildFuture=false
```

Both `--buildDrafts=false` and `--buildFuture=false` match the deploy
policy. The events feature relies on `publishDate` (always past after
the roller has run), not `date`, to clear `--buildFuture=false`.

---

## Current state snapshot (May 2026)

- **D5–D13 visual redesign sweep:** shipped. Closing deliverable
  documented in `documentation/D13-SPEC.md`.
- **SPEC-01 News:** shipped.
- **SPEC-02 Events:** shipped (past archive gated by
  `params.events.show_past_archive`).
- **SPEC-03 Termly Programme:** shipped. `data/programme_themes.toml`
  ships an illustrative Skills-for-Life chip list with a TODO header
  to reconcile against `scouts.org.uk/programme-planner/` before
  going live. Q3.1 was revised 2026-05-21 to wire the
  `programme-current` home block into the example site.
- **SPEC-06 Joining & Welcome Pack:** shipped. `/join/` cards + FAQ
  + BSO branch; `/welcome-pack/` content section with 5 starter
  chapters and a `WelcomePackPrint` custom output format generating
  `/welcome-pack/print.html`. Introduced `--status-{open,waiting,closed}`
  palette tokens and a `.btn-waiting` button class (amber, matches
  the waiting-list badge). `bso-membership-notice` is rendered
  exactly once site-wide — on `/join/` — per the 2026-05-21
  consolidation decision.
- **SPEC-10 BSO Joining Hub:** shipped. `/bso/` hub plus five
  sub-pages (eligibility, moving-in, moving-out, host-scouting,
  optional home-range). Master switch is **`[params.bso].enabled`**,
  not a scalar `bso = true` (the two collide in TOML). Theme ships
  per-ISO host-country alternatives data for NL, BE, FR, DE, ES, AE,
  SG, US. `data/sections_status.toml` ships as a host-country-generic
  STARTER (uses "the host country" phrasing); the concrete UAE
  configuration lives in `exampleSite/hugo.toml` only.
- **Not started:** SPEC-04 Galleries, SPEC-05 Kit Lists, SPEC-07
  History & Governance, SPEC-08 Hall Hire, SPEC-09 Fundraising &
  Volunteering. Recommended next per
  `documentation/README.md` is **SPEC-04 Galleries**.
- **SPEC-11 (Nav) and SPEC-12 (Accessibility):** cross-cutting,
  always-on, no opt-in flag. To be implemented late as hardening
  passes. `exampleSite/hugo.toml` still carries a static
  `[[menu.main]]` block — will be replaced by SPEC-11's auto-built
  nav at that point.

---

## Quick conventions cheat-sheet

These are the things you'll bump into constantly:

- **Feature flag:** every feature is opt-in via
  `params.features.<name> = true` in `hugo.toml`. Default OFF. The
  `exampleSite/hugo.toml` sets every flag to `true`.
- **Section partial idiom:** see SPEC-COMMON §3. Comment-block
  header, `id` / `title` / `bg` / `title_color` params, render
  inside `<section class="section s-<name> ...">`.
- **Image pipeline:** see SPEC-COMMON §5. WebP at 640/1280/1920,
  `loading="lazy"`, missing-asset `errorf` not silent.
- **Palette tokens:** see SPEC-COMMON §6. Never hardcode hex.
- **Section-badge colours:** `data/scout_sections.toml`, fields
  `color` and `text_color` (US-spelled keys). Six sections:
  Squirrels `#25B755`, Beavers `#003982`, Cubs `#F7EF27`, Scouts
  `#E22E12`, Explorers `#088486`, Network `#000000`.
- **Photo-consent lint:** mandatory on every content type that may
  carry images of identifiable young people. SPEC-COMMON §10.
- **Licence header on new layouts:** SPEC-COMMON §16. Not optional.
- **Demo-roller `[demo]` blocks:** theme-repo only, in
  `exampleSite/content/events/*.md`. Group sites have no `[demo]`
  blocks. See DECISIONS.md §"Demo data".
- **`exampleSite/content/_index.md` adjacency rule:** the
  `where-we-meet` section-header acts as the title for the `embed`
  (map) section immediately following it — keep these two sections
  adjacent in the `[[sections]]` list. Don't insert news-grid,
  events-upcoming, etc. between them.
