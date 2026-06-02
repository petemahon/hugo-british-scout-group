# SPEC-06: Joining & Waiting List

Read `SPEC-COMMON.md` first.

## Goal

Structured joining page generated from a single Markdown file plus a
data file, with one block per section showing current status (Open /
Waiting List / Closed), age range, fee, meeting night, and what
parents need to commit. Multi-pack support is configurable for
Groups that run more than one Pack/Troop within a section.

The Welcome Pack ships as a printable Hugo content section — a set
of pages with a print-friendly stylesheet — replacing the original
"download a PDF" pattern. Sample content and structural guidelines
ship with the theme.

The single highest-impact recruitment page on any Group site, given
TSA's published 107,000-strong national waiting list. Real parallels:
10th Royal Eltham, Dudley District, 1st Liss, Ham Scouts, 4th
Sevenoaks (Welcome Pack pattern).

## Acceptance criteria

1. A page exists at `/join/` rendering one card per section the Group
   runs (toggled via `params.scoutSections` — already in theme),
   with multi-pack support: a section with multiple packs renders
   one card per pack.
2. Each card shows: section logo, age range, status badge, meeting
   night & time, fee + period, contact link, and a short description.
3. Status options: `open`, `waiting`, `closed`. Each renders a
   visually distinct badge styled with `--status-open`,
   `--status-waiting`, `--status-closed` palette tokens (see
   DECISIONS.md).
4. Optional FAQ block below the cards, populated from front-matter.
5. **Welcome Pack** is a Hugo content section at `/welcome-pack/`,
   containing a set of Markdown pages styled for print. A
   "Printable version" link concatenates all pages for one-shot
   printing or "Save as PDF". Sample content covering the standard
   topics (about, sections, joining, safeguarding, calendar) ships
   in the example site as a starter Groups can edit.
6. The page links out to the Group's OSM waiting list URL or to a
   `mailto:` if the Group does not use OSM. The site itself never
   collects any data.
7. BSO mode (`[params.bso].enabled = true`) renders the existing
   `bso-membership-notice` partial above the cards, plus per-card
   eligibility strings.
8. Feature gated by `params.features.joining` (default OFF).
9. Example site exercises: a Group with all sections open, a Group
   with one waiting list, a Group with Squirrels closed (not yet
   running), a multi-pack Cubs section, a BSO Group with eligibility
   text.

## Content layout

```
content/join/
├── _index.md                       # the joining page itself
└── faq/
    ├── 01-what-do-cubs-do.md
    └── 02-do-i-need-to-volunteer.md

content/welcome-pack/
├── _index.md                       # cover page + nav
├── about.md                        # about the Group
├── sections.md                     # what each section does
├── joining.md                      # subs, payment, what to bring
├── safeguarding.md                 # code of conduct, photo consent
└── calendar.md                     # termly calendar overview

data/sections_status.toml           # source of truth, edited by Group
```

## Front-matter schema (`content/join/_index.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Join us" | Page heading |
| `intro` | string (HTML allowed) | no | "" | Renders below heading, above cards |
| `welcome_pack_url` | string | no | "/welcome-pack/" | Path to Welcome Pack section, or external URL |
| `welcome_pack_label` | string | no | "Read our Welcome Pack" | |
| `osm_waiting_list_url` | string | no | — | Direct OSM URL — overrides per-card emails when present |
| `enquiry_email` | string | no | — | Generic Group email for enquiries |
| `volunteer_link_text` | string | no | "We need you too" | Bridge to SPEC-09 |
| `bso_eligibility_summary` | string (HTML allowed) | no | "" | BSO only — short eligibility blurb |

## Data schema (`data/sections_status.toml`)

Multi-pack support: each section key is an **array** of pack records.
Single-pack groups have one entry per section; multi-pack groups have
multiple. The `pack_name` field renders only when populated.

```toml
[[squirrels]]
  pack_name     = ""                # "" = single-pack, no name shown
  status        = "open"
  meeting_night = "Monday"
  meeting_start = "17:30"
  meeting_end   = "18:30"
  fee           = "30"
  fee_currency  = "GBP"
  fee_period    = "term"
  contact_email = "squirrels@1stanytown.org.uk"
  description   = "Three short paragraphs about Squirrels."
  waiting_url   = ""                # OSM waiting list, optional per-pack
  bso_language  = ""                # BSO only
  bso_nationality_note = ""         # BSO only

[[beavers]]
  pack_name = "Tuesday Colony"
  status = "waiting"
  meeting_night = "Tuesday"
  ...

[[beavers]]
  pack_name = "Thursday Colony"
  status = "open"
  meeting_night = "Thursday"
  ...
```

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `pack_name` | string | no | "" | Empty = single-pack section, no name shown |
| `status` | enum | yes | — | "open" \| "waiting" \| "closed" |
| `meeting_night` | string | yes | — | "Monday", "Tuesday", … |
| `meeting_start` | string | yes | — | "17:30" |
| `meeting_end` | string | yes | — | "18:30" |
| `fee` | string | no | "" | Number as string, e.g. "30" |
| `fee_currency` | string | no | "GBP" | ISO 4217 |
| `fee_period` | string | no | "term" | "term" \| "month" \| "year" |
| `contact_email` | string | no | — | Per-pack email |
| `description` | string (HTML allowed) | no | — | Card body |
| `waiting_url` | string | no | — | OSM URL, used when `status = "waiting"` |
| `bso_language` | string | no | — | BSO only |
| `bso_nationality_note` | string | no | — | BSO only |

Currency rendering: a `data/currencies.toml` map provides the symbol
for each ISO code (reused by SPEC-09 and SPEC-10).

## Welcome Pack content section

The Welcome Pack is a Hugo content section under `/welcome-pack/`.
The theme ships a starter pack in `exampleSite/content/welcome-pack/`
covering the standard topics observed in research (4th Sevenoaks, 1st
Welwyn, 1st Alton Manor, 3rd Bookham). Groups copy the starter into
their site and edit.

### Starter pack — sample content guidelines

Each page is a normal Hugo page with title, body, optional intro
image, and a `weight` for ordering.

**`_index.md`** — Welcome Pack cover page

- Group name, current academic year, version, last reviewed date.
- A nav listing the chapters with brief descriptions.
- "Print all" link to `/welcome-pack/print.html` (compiles all
  chapters into one printable page — see Layouts).

**`about.md`** — About the Group

- One-paragraph history (link to SPEC-07 if enabled).
- Where we meet (link to existing "Where we meet" section).
- Mission / what young people get from Scouting.
- Charity number & regulator (if `params.governance.charity_number`
  is set).

**`sections.md`** — What each section does

- Per-section block: age range (from `data/scout_sections.toml`),
  meeting times (from `data/sections_status.toml`), what a typical
  meeting looks like.
- Use the section colour from `data/scout_sections.toml`.

**`joining.md`** — How to join, subs, what to bring

- Joining process (waiting list, OSM signup, first-night reminder).
- Subs: amount, currency, period, payment method, hardship policy.
- Uniform: what to buy, where to buy, badges.
- What to bring on a typical night (tied to the kit-lists feature
  if enabled).

**`safeguarding.md`** — Code of conduct & photo policy

- A clear statement that the Group is part of The Scout Association
  and follows TSA safeguarding policy.
- Code of conduct expectations for young people (and parents).
- Photo consent: how the Group records and respects it (link to
  `/policies/photo-consent/` from SPEC-04 if enabled).
- Health & medication: how forms are collected (NOT collected on the
  website — refer to OSM or first-night paperwork).
- GDPR: where data is held, retention period, who to contact for
  removal.

**`calendar.md`** — Termly calendar overview

- High-level term dates (link to SPEC-03 if enabled).
- Annual fixtures: St George's Day Parade, Remembrance Sunday,
  Group AGM, summer camp.
- Link to `/events/` if SPEC-02 is enabled.

The starter pack is **content the Group edits**, not theme code. The
theme's job is the layout + print stylesheet. Groups customise the
content for their own context.

## FAQ schema (each `content/join/faq/<n>-<slug>.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | yes | — | The question |
| `weight` | int | no | filename order | Display order |

Body: free Markdown.

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/join/single.html` | `/join/` page |
| `layouts/welcome-pack/list.html` | `/welcome-pack/` cover page |
| `layouts/welcome-pack/single.html` | Per-chapter page |
| `layouts/welcome-pack/list.welcomepackprint.html` | `/welcome-pack/print.html` — concatenated, print-styled (custom output format) |
| `layouts/partials/joining-grid.html` | The cards |
| `layouts/partials/joining-card.html` | Per-pack card |
| `layouts/partials/joining-faq.html` | FAQ accordion |
| `layouts/partials/welcome-pack-nav.html` | Chapter nav |

The print route uses a custom output format on the welcome-pack
section list page.

## hugo.toml additions

```toml
[params.features]
  joining       = false              # default OFF — opt-in
  welcome_pack  = false              # default OFF — opt-in

[params.joining]
  show_currency      = true
  card_layout        = "grid"        # "grid" | "stacked"
  show_volunteer_link = true         # links into SPEC-09 Fundraising

[params.welcome_pack]
  print_route = true
```

The existing `params.scoutSections` toggles which cards render.

## Asset paths

- Section logos: already handled by theme override pattern.
- Welcome Pack images: `assets/welcome-pack/<chapter>.jpg`.

## CSS-only baseline

- Cards in CSS Grid, `auto-fit, minmax(280px, 1fr)`.
- Status badge colours from new tokens (DECISIONS.md):
  - Open: `var(--status-open)`
  - Waiting: `var(--status-waiting)`
  - Closed: `var(--status-closed)`
- FAQ: `<details>` / `<summary>` — no JS. Print stylesheet forces
  `details[open] > *, details > *` reset so all answers print
  expanded.
- Welcome Pack chapter pages: serif body for readability, generous
  margins. Print stylesheet hides nav, optimises for A4.

## BSO notes — first-class

When `[params.bso].enabled = true`:

1. The `bso-membership-notice` partial renders above the cards (the
   existing POR 3.2.1.1 notice).
2. Each pack card whose `bso_language` is non-empty renders the
   language requirement as a small note inside the card.
3. Each pack card whose `bso_nationality_note` is non-empty renders
   that note linked to `/bso/eligibility/` (SPEC-10).
4. Welcome Pack `safeguarding.md` chapter renders an additional
   block referencing POR 3.2.1.1 when BSO is enabled.

When `[params.bso].enabled = false`, the BSO-specific fields are ignored.

## Safeguarding & GDPR

- **No forms on the static site.** All enquiries go to `mailto:` or
  OSM. Build emits a warning if a card has `status = "waiting"` but
  neither `waiting_url` nor `contact_email` is set.
- Welcome Pack must NOT contain forms. Hardcopy-only forms (medical,
  consent) are referenced as "completed at first night" and linked
  to placeholder PDFs the Group provides.
- `description` field is editorial; the Group writes about itself.
- Volunteer ask: link to SPEC-09, don't duplicate.
- BSO eligibility prose: not lint-checked; Group's responsibility.

## Decided

| Q | Decision |
| --- | --- |
| Q6.1 | **Yes** — three new palette tokens `--status-open`, `--status-waiting`, `--status-closed`. Defined per palette in `data/palettes.toml`. |
| Q6.2 | **Multi-pack supported** — `data/sections_status.toml` uses array-per-section pattern (`[[cubs]]` repeated). Single-pack Groups have one entry; multi-pack Groups add more. `pack_name` field renders only when populated. |
| Q6.3 | **Welcome Pack as printable Hugo content section** — `/welcome-pack/` with chapters; `/welcome-pack/print.html` (a `WelcomePackPrint` custom output format on the section list page) for the concatenated printable view. Starter content ships in `exampleSite/`. |
| Q6.4 | **No Word version** — superseded by Q6.3. The Markdown chapters in the starter pack are themselves the editable template. |
| Q6.5 | **Yes** — print stylesheet forces `<details>` open. Standard accessibility. |

## Out of scope (cross-references)

- Online waiting-list signup → no.
- Online subs payment → no. SPEC-09 may link to a payment provider.
- Per-section deep "About Cubs" pages → not in this spec; the Welcome
  Pack `sections.md` chapter and the joining card description cover
  this.
- Volunteer recruitment → SPEC-09.
- BSO long-form eligibility → SPEC-10.

## Implementation order

1. Schema + `archetypes/join.md`.
2. Add three new palette tokens (`--status-open`, `--status-waiting`,
   `--status-closed`) to `data/palettes.toml` for all five palette
   presets. Verify each palette renders sensible status colours.
3. `data/sections_status.toml` skeleton with array-per-section pattern.
4. `layouts/join/single.html`; render hardcoded card.
5. `layouts/partials/joining-card.html` with palette-driven colours
   and multi-pack handling.
6. `layouts/partials/joining-grid.html`.
7. Currency rendering using `data/currencies.toml`.
8. Status badges using new tokens.
9. FAQ section consuming `content/join/faq/*.md`.
10. BSO branch: render `bso-membership-notice` partial + per-pack
    eligibility notes.
11. Welcome Pack section: `layouts/welcome-pack/list.html`,
    `single.html`, `print.html` (custom output format).
12. Starter pack content in `exampleSite/content/welcome-pack/` —
    five chapters (about, sections, joining, safeguarding, calendar)
    plus the `_index.md` cover page, covering the topics above.
13. Print stylesheets for both `/join/` and `/welcome-pack/print/`.
14. Build warnings for missing waiting URL, missing contact email.
15. CSS, i18n, README, screenshot.
