# SPEC-03: Termly Programme

Read `SPEC-COMMON.md` first.

## Goal

Per-section, per-term page summarising weekly meetings: titles, themes,
kit notes. Public-friendly view of the granular OSM programme that POR
9.1.2.1 already requires Groups to plan and submit to District.

Programmes are tagged with **Skills for Life curriculum themes** drawn
from the Scouts UK Programme Planner - rendered as palette-coloured chips
next to each meeting. Encourages leaders to pay attention to curriculum
balance and surfaces it for District audit.

Real parallels: 1st Highworth, OSM-aware Group sites that publish a
sanitised programme. The Scouts UK programme planner
(`scouts.org.uk/programme-planner/`) is the upstream tool Groups use.

## Acceptance criteria

1. A page exists at `/programme/` listing every published programme,
   in reverse chronological order grouped by section.
2. Each programme has its own page at `/programme/<slug>/` showing a
   table: week number, date, title, theme tags, kit/notes.
3. **Theme chips** render next to each meeting title using
   palette-coloured badges sourced from `data/programme_themes.toml`.
4. The home page can show "this term's programme" via a section block
   (`programme-current`), but it is **opt-in** - the block is not
   added to the example site's home page by default.
5. The build hides programmes whose `term_end` is in the past unless
   `params.programme.keep_archive = true`.
6. Programmes can render in two density modes: `themes_only`
   (just title + theme chips) or `full` (with notes/kit). Default is
   `themes_only` per safeguarding guidance.
7. Print stylesheet - parents print one term's plan on one A4 sheet,
   `<details>` forced open.
8. Cancelled rows render with `--warning` styling (see DECISIONS.md).
9. Feature gated by `params.features.programme` (default OFF).
10. Example site exercises: a current term, a past term, a future term,
    `themes_only` and `full` density modes, programmes for two
    different sections, theme chips on every entry.

## Content layout

```
content/programme/
├── _index.md
├── cubs-summer-2026.md
├── beavers-summer-2026.md
└── scouts-autumn-2025.md       # past
```

Slug convention: `<section>-<term>-<year>.md`.

## Front-matter schema (per programme)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | yes | - | "Cubs - Summer Term 2026" |
| `section` | string | yes | - | One of `data/scout_sections.toml` keys |
| `term` | string | yes | - | "Summer 2026" - display label |
| `term_start` | date | yes | - | First meeting date |
| `term_end` | date | yes | - | Last meeting date - used for archive cutoff |
| `term_anchor` | string | no | - | Free text e.g. "British School in the Netherlands Spring Term" |
| `density` | string | no | `themes_only` | `themes_only` \| `full` |
| `weeks` | list[block] | yes | - | See below |
| `kit_list_ref` | string | no | - | Link to a SPEC-05 kit list applicable across the term |
| `notes` | string (HTML allowed) | no | - | Term-level notes ("week 5 is half-term") |
| `district_approved` | bool | no | false | If true, renders a small POR-aligned badge |

Each `weeks` block:

```toml
[[weeks]]
  number      = 1
  date        = 2026-04-15
  title       = "Welcome back & investiture"
  themes      = ["skills-for-life", "beliefs-and-attitudes"]
  notes       = "Bring your necker. New Cubs welcome."   # only rendered in full density
  cancelled   = false
  cancellation_note = ""
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `number` | int | yes | - | Week number - does not have to be sequential if half-term skipped |
| `date` | date | yes | - | |
| `title` | string | yes | - | One-line meeting headline |
| `themes` | list[string] | no | `[]` | Theme keys from `data/programme_themes.toml` |
| `notes` | string | no | "" | Only shown in `full` density |
| `cancelled` | bool | no | false | |
| `cancellation_note` | string | no | "" | |

## Programme themes data

`data/programme_themes.toml` ships with the theme. Source: Scouts UK
Programme Planner. Groups don't edit this file; it's part of the theme
bundle and updates flow via submodule bumps.

```toml
[[theme]]
  key = "skills-for-life"
  label = "Skills for life"
  palette = "primary"
  scouts_url = "https://www.scouts.org.uk/skills-for-life/"

[[theme]]
  key = "beliefs-and-attitudes"
  label = "Beliefs and attitudes"
  palette = "secondary"

[[theme]]
  key = "outdoor-and-adventure"
  label = "Outdoor and adventure"
  palette = "tertiary"

[[theme]]
  key = "community-impact"
  label = "Community impact"
  palette = "accent"

[[theme]]
  key = "teamwork-and-leadership"
  label = "Teamwork and leadership"
  palette = "secondary"

[[theme]]
  key = "have-adventures"
  label = "Have adventures"
  palette = "tertiary"

[[theme]]
  key = "try-new-things"
  label = "Try new things"
  palette = "accent"

[[theme]]
  key = "live-up-to-our-values"
  label = "Live up to our values"
  palette = "primary"
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `key` | string | yes | - | Stable identifier referenced from week front-matter |
| `label` | string | yes | - | Display label |
| `palette` | string | yes | - | Palette token name (`primary`, `secondary`, `tertiary`, `accent`) - chip colour resolves from active palette |
| `scouts_url` | string | no | - | Optional outbound link to scouts.org.uk page describing the theme |

The exact theme list and key naming should be cross-checked against
the current Scouts UK Programme Planner before implementation begins -
the names above are illustrative based on research.

## Section partial: `programme-current`

```toml
[[sections]]
  type     = "programme-current"
  id       = "this-term"
  title    = "This term's programme"
  density  = "themes_only"        # overrides per-programme density
  sections = ["beavers", "cubs", "scouts"]   # filter
  bg       = "muted"
```

Renders one collapsible block per matching current programme. Auto-
detects "current" by `term_start <= today <= term_end`. **Not in the
example site's home page by default** - Groups add it when they have
the editorial commitment to keep programmes fresh.

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/programme/list.html` | `/programme/` index |
| `layouts/programme/single.html` | `/programme/<slug>/` |
| `layouts/partials/sections/programme-current.html` | Home-page block (opt-in) |
| `layouts/partials/programme-table.html` | Reusable table with theme chips |
| `layouts/partials/programme-themes.html` | Renders the theme chip strip for one week |
| `layouts/partials/programme-print.html` | Print-friendly variant |

## hugo.toml additions

```toml
[params.features]
  programme = false                  # default OFF - opt-in

[params.programme]
  keep_archive   = false
  default_density = "themes_only"
  show_district_approved_badge = true
  show_theme_chips = true            # set false to hide chips entirely
```

## Asset paths

No images required.

## CSS-only baseline

- HTML `<table>` with `position: sticky` header.
- `<details>`/`<summary>` for collapsible per-programme blocks on the
  home-page block - pure HTML, no JS.
- Theme chips: small inline pill-shaped spans, `var(--<palette-token>)`
  background.
- Print stylesheet via `@media print`: hide nav, hide non-essential
  blocks, table edge-to-edge, `<details>` forced open via
  `details[open] > *, details > *` reset.
- Cancelled rows: `var(--warning)` strikethrough title + small badge.

## BSO notes

The `term_anchor` field is BSO-friendly - many BSO Groups follow a
host-country school calendar (British School in the Netherlands,
International School of Brussels, etc.). Free text, not gated by
`params.bso`.

Programme themes (Skills for Life curriculum) are general-purpose and
apply to BSO Groups equally - they're under TSA and follow the same
programme planner.

## Safeguarding & GDPR

- Default density is `themes_only`. POR 9.1.2.1 programmes contain
  full activity detail (locations, external visitors, hazardous
  activity flags) which is not safe to publish on a public site.
- Archetype comment header warns against:
  - Naming young people
  - Naming external visiting adults (visiting speakers' names go in
    `notes` only with consent)
  - Specific addresses for activities at private venues
- Build does not enforce - documentation responsibility.

## Decided

| Q | Decision |
| --- | --- |
| Q3.1 | **Wired into the example site** (revised 2026-05-21). `programme-current` is still opt-in at the framework level - every feature defaults OFF and Groups must set `params.features.programme = true` and add the `[[sections]]` block themselves. The example site now ships the block enabled so the demo exercises every section type alongside `news-grid` and `events-upcoming`. Original opt-in-out-of-example rationale: stale published content damages credibility. Trumped by: the example site is a demo, not a production Group, and the demo-roller already keeps event dates fresh; the programme example content is acceptable to revisit annually. |
| Q3.2 | **INCLUDE in v1** - programme themes (Skills for Life curriculum) ship with the theme via `data/programme_themes.toml`. Encourages leaders to pay attention to curriculum balance and surfaces it for District. Renders as palette-coloured chips next to each meeting. |
| Q3.3 | **Two fields** - `term_start` and `term_end`. Required for archive cutoff filter. |
| Q3.4 | **Defer** - badges-working-towards (e.g. "this term we're working on the Naturalist badge") is a v2 enhancement, not in v1. |

## Out of scope (cross-references)

- Per-young-person badge tracking → no, that's OSM's job.
- RSVPs / attendance → no.
- Camp programmes - those are Events (SPEC-02) with kit-list refs
  (SPEC-05).
- AGM minutes - those are Governance (SPEC-07).

## Implementation order

1. Cross-check the theme list in `data/programme_themes.toml` against
   the current Scouts UK Programme Planner. Document source date.
2. `archetypes/programme.md` with the full schema scaffold.
3. `layouts/programme/list.html`, hardcoded styling.
4. `layouts/programme/single.html` with the table partial.
5. Build `layouts/partials/programme-themes.html` rendering chips
   from the data file.
6. Wire chips into `programme-table.html`.
7. Create `cubs-summer-2026.md` example with theme tags, build,
   verify chip rendering.
8. Add `programme-current` partial; wire into section dispatcher.
9. Add `[[sections]]` block in example site's `_index.md` -
   commented out by default (document in README how to enable).
10. Print stylesheet.
11. Cancelled-row handling using `--warning` + `district_approved` badge.
12. CSS, i18n, README section.
