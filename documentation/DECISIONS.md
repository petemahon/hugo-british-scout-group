# DECISIONS.md

Locked-in choices for the Hugo British Scouting Overseas Theme project.
Read before suggesting changes that touch any of these. Flag, don't
silently revise.

## Identity & licence

- Theme code stays general-purpose under the name `british-scout-group`,
  even though this project's focus is BSO. The theme is for any UK Scout
  Group; BSO is a first-class feature, not the only use case.
- Licence is CC BY-SA 4.0 © Peter Mahon. Keep `LICENSE` intact in any
  refactor.
- The only Group-specific string anywhere in the theme is Peter's name
  in `LICENSE`. Everything else lives in the consuming site's `hugo.toml`.

## Architecture

- Hugo extended, minimum version 0.156. The Pages workflow pins `0.157.0`.
- `<html lang="en-GB">` is hardcoded in `baseof.html`. No locale parameter.
- No JavaScript dependency anywhere. Sticky nav, smooth scroll, fade-in
  animations are pure CSS. Adding JS is a flag-not-change item.
- Front-matter-driven sections: `[[sections]]` array in `content/_index.md`,
  each entry's `type` maps to a partial in `layouts/partials/sections/`.
- Theme distributed as Git submodule at `themes/british-scout-group`,
  not as a Hugo Module.

## Section types (canonical list)

`hero`, `two-col-cta`, `two-col-image-cta`, `section-grid`,
`stacked-features`, `scout-sections`, `section-header`, `embed`,
`bso-membership`, `palette-showcase`, `prose`, `join`,
`news-grid`, `events-upcoming`, `programme-current`,
`network-feature`, `volunteer-feature`.

The last five entries were added during the D5–D13 visual redesign
sweep: `join` (two-card joining CTA), `news-grid` (SPEC-01 home block),
`events-upcoming` (SPEC-02 home block), `network-feature` (Scout
Network 18–25 brand-anchor band), `volunteer-feature` (volunteer
recruitment brand-anchor band — Scouts Purple regardless of palette).

Adding a new type is fine. Renaming or removing one is a flag-not-change.

## Brand & visual

- Five palette presets: `classic-purple`, `adventure`, `coastal`,
  `vibrant`, `network`. Names locked in.
- All hex values come from the Scouts Brand Guidelines 2023. Editing
  these to realign with future Scouts brand updates is the expected
  maintenance path; adding a sixth named palette is a flag-not-change.
- **Two palette tokens are app-functionality colours, not brand
  palette entries:**
  - `--warning` (`#d4351c`) — scarlet, used for the Cancelled pill
    on event cards (SPEC-02), cancelled programme rows (SPEC-03),
    expired vacancies (SPEC-09), the hall fully-booked banner
    (SPEC-08), and other alert states. Distinct from Scouts Red
    (`#E22E12`, the Scouts section's identity colour) so the two
    never visually collide on a card or page.
  - `--postponed` (`#d97706`) — amber, used for the Postponed pill
    on event cards. Distinct from any Scouts brand colour: not Scouts
    Orange (`#ff912a` = `--accent`), not Cubs yellow (`#F7EF27`).
  Both values are uniform across all five palette presets. They are
  not brand colours and are not expected to change when the Scouts
  Brand Guidelines update.  
- Theme ships the **official Scouts section logo SVGs** at
  `assets/images/sections/{squirrels,beavers,cubs,scouts,explorers,network}.svg`,
  downloaded from https://scoutsbrand.org.uk by the theme maintainer.
  Groups DO NOT override these — brand asset maintenance is centralised
  in the theme. When The Scout Association updates a logo, the theme
  is updated and every Group picks up the new asset by bumping their
  submodule.
- **Other generic placeholder imagery** (e.g. `assets/images/volunteer/role-model.webp`)
  ships as before; Groups override at the same path with their own
  files — Hugo's resource resolution prefers the site over the theme.
## Link-decoration sentinels

- `02-layout.css` auto-applies `text-decoration: underline` to anchors
  inside dark-bg sections (`.s-bg-primary`, `.s-bg-secondary`,
  `.s-bg-tertiary`, `.s-bg-dark`) so raw links remain distinguishable
  from body text. Two classes opt out:
  - `.btn` — anchors carrying full button styling.
  - `.styled-link` — sentinel marker for anchors that are styled cards,
    badges or other self-contained components (no own visual treatment,
    just an opt-out flag).
- New section types whose anchors are card-like or button-like wear
  `.styled-link` from day one. Do not add new entries to the
  `:not(.btn):not(.styled-link)` chain.

## Scout sections (the age groups)

- Section metadata (age ranges, `scouts.org.uk` URLs) is fixed in the
  theme at `data/scout_sections.toml`. Groups never duplicate this.
- Groups toggle which sections they run via `params.scoutSections` in
  `hugo.toml` and supply their own logos.
- The responsive grid is sized for the canonical five sections.

## BSO

- The BSO membership notice is a dedicated partial.
- Wording aligns with The Scout Association's POR 3.2.1.1. The current
  copy is canonical — don't reword without flagging.
- Configured via `[params.bsoMembershipNotice]` (host country + host
  association). Text overridable via standard Hugo i18n in `i18n/en.toml`.
- BSO features are an optional add-on. The theme does not assume a
  Group is BSO.

## Event status model (SPEC-02 / D8)

- Event front-matter uses an enum `status = "active" | "cancelled" |
  "postponed"`. Default `"active"`. Replaces the older `cancelled: bool`
  field (retired in D8).
- An optional `revision` int (default 0) tracks the number of times
  an event has been rescheduled. The `event.ics` SEQUENCE counter is
  set to `max(revision, status == "postponed" ? 1 : 0)`. Bumping
  `revision` is required only when re-postponing an already-postponed
  event; the first postponement is handled automatically.
- `.ics` output behaviour per status:
  - `active`: VEVENT emitted normally.
  - `cancelled`: per-event `event.ics` renders a well-formed empty
    VCALENDAR (no VEVENT); event is omitted from `/events/all.ics`.
    The URL stays valid for any bookmarked subscriber, and their
    calendar app removes the meeting on next poll. STATUS:CANCELLED
    is no longer emitted (retired with the old boolean schema).
  - `postponed`: VEVENT emitted with the new DTSTART/DTEND; DESCRIPTION
    prefixed with the i18n string `eventsPostponedICSNote` ("Note: new
    date/time. "); SEQUENCE bumped so subscriber apps update the
    meeting in place rather than duplicating.
- Site rendering: cards and single pages show a coloured status pill
  (red for cancelled, amber for postponed) ahead of the section
  badges. Active events show no status pill.  

## Palette reference page

The `/palettes/` page (`palette-showcase` section type) lives only in
the theme's `exampleSite`. Consuming sites do not include it.

## Deployment

- GitHub Pages via Actions, workflow at `.github/workflows/hugo.yml`.
- Pinned: `actions/checkout@v5`, `actions/deploy-pages@v5`.
- Kept at older Node-20 versions: `actions/configure-pages@v5`,
  `actions/upload-pages-artifact@v3` — no Node-24 release upstream yet
  (tracking actions/upload-pages-artifact#138).

## Navigation (cross-cutting — SPEC-11)

- Navigation is **auto-built** from `params.features.*` flags. The
  Group does not configure `[[menu.main]]`; the theme owns the
  structure.
- **Five top-level groups, hardcoded order**: Join Us · Our Sections
  · What we do · Get Involved · About. A Group can hide an entry
  via `params.nav.show_<name> = false` but cannot reorder.
- **Smart collapse**: a group with a single enabled child renders
  as a direct top-level link to that child. The group's i18n label
  isn't used in this case.
- **Empty groups disappear entirely** — no shell, no placeholder.
- Pure CSS. `:hover` (pointer devices, guarded) and `:focus-within`
  (keyboard) for desktop dropdowns; checkbox-hack hamburger for
  mobile, where each group is a `<details>`/`<summary>` **accordion**
  (collapsed by default; the current page's group auto-opens).
- **Three always-on anchors** that the nav can fall back to even
  with no features enabled: `#join`, `#sections`, `#where-we-meet`.
  These IDs are part of the theme's stable contract; renaming them is
  a flag-not-change event. (Reconciled 2026-06-03 from the originally
  drafted `#joining`/`#our-sections` to the shipped home-section IDs.)
- **Shipped 2026-06-03.** Content pages clear the fixed nav via a
  `body.is-home` class + `--nav-clear`; the home hero stays full-bleed.

## Accessibility (cross-cutting — SPEC-12)

- WCAG 2.2 AA is the floor. AAA is aspirational.
- **No JS for accessibility.** Keyboard support comes from
  `:focus-within`, semantic HTML, and the dropdown patterns in
  SPEC-11.
- **Skip link** is the first focusable element on every page.
  Visible on focus.
- **Focus ring** is a new palette-level token: `--focus-ring`,
  added to every preset in `data/palettes.toml`. Falls back to
  `--primary` if a palette omits it.
- **Reduced-motion** honoured globally; the `reveal` fade-in
  disables under `prefers-reduced-motion: reduce`.
- **Image-alt lints** are uniform across content types via a
  shared `partials/audit-image.html`. SPEC-01's news lint is the
  reference implementation.
- **Heading order**: every page has exactly one `<h1>`, sourced
  from `.Title` in `_default/baseof.html`. Section partials use
  `<h2>` and below. Build-time audit if practicable; manual review
  otherwise.
- **Colour contrast audit** runs in GitHub Actions via a node
  script reading `data/palettes.toml`. Fails the workflow if any
  used (foreground, background) pair falls below AA.
- **axe-core CI** runs on PRs against the rendered example site.
  Fails the PR but doesn't block deploy.

## Demo data

- The theme repo's `exampleSite` keeps its example events looking
  fresh against build time via `scripts/roll-example-dates.py` and a
  `[demo]` table in each example event's TOML front-matter.
- Contract: each `[demo]` block has `target_offset_days` (event
  happens this many days from `now`) and `publish_lead_days`
  (`publishDate` set this many days before `now`). The script rewrites
  `date`, `end` (preserving duration) and `publishDate` in place.
- The committed dates in git are the canonical "last known good"
  example dates; the script overwrites them in-flight before every
  `hugo serve` and CI build of the theme's Pages preview. The
  working tree's modified events should NOT be committed; `make clean`
  reverts.
- Theme-repo only. Group sites consuming the theme have no `[demo]`
  blocks; the script never touches them. Real Group events have real
  fixed dates.

## en-GB scope

- en-GB applies to visitor-facing text and documentation prose.
- Code identifiers — TOML field keys, CSS class names, template
  variables, Hugo data-file keys — follow source-code conventions and
  may use US spelling where idiomatic. Examples: `color` /
  `text_color` in `data/scout_sections.toml`, `bg` / `bg_muted` in
  palette data. en-GB linting applies to what users read, not what
  developers type.

## Working method

- Confirm design decisions before implementing. Don't assume.
- Validate builds incrementally — don't write a sprawl of templates
  then try to build at the end.
- Read access only on GitHub repos. Never attempt writes.
- The old Mobirise site (`petemahon/adscouts`) is kept for history.
  Don't fork, maintain, or reference it as a source — `petemahon/hugo-adscouts`
  is the live one.
