# SPEC-07: Group History & Governance

Read `SPEC-COMMON.md` first.

## Goal

Two related but separable pages:

- A long-form Group history page with a CSS-only timeline.
- A governance page listing the charity number, Trustee Board, AGM
  date, and an archive of Trustee Annual Reports as downloadable PDFs.

The pair forms the public face of the Group's stewardship and is a
soft-but-real reputation signal for parents and grant funders. Real
parallels: Ash Green's published 2024 AGM report, 40th Greenwich's
multi-year AGM archive, the Wikipedia "List of the oldest Scout groups"
ecosystem.

## Acceptance criteria

1. A page exists at `/about/history/` rendering a long-form Markdown
   body with an optional sidebar timeline driven by a data file.
2. A page exists at `/about/governance/` listing the charity number,
   regulator, trustee names, AGM date, and an archive of past AGM /
   Trustee Annual Reports as PDF download links.
3. **Charity info displays in every non-printing page footer** when
   `params.governance.charity_number` (or, for BSO, the secondary
   charity number) is configured. Print stylesheet hides it.
4. Both features are independently gated:
   `params.features.history` and `params.features.governance`
   (default OFF).
5. AGM archive uses a `data/reports.toml` manifest. The build emits
   a warning when a PDF in `static/about/reports/` isn't listed in
   the manifest.
6. Trustee names render as plain text — public on the Charity
   Commission register, but no contact details are shown.
7. Example site exercises: a Group with a 50-year history (timeline
   with 8+ events), a UK charity (Charity Commission for England &
   Wales), a BSO Group with both UK and host-country charity numbers.

## Content layout

```
content/about/
├── history.md
├── governance.md
└── reports/                         # optional, can be empty
    └── _index.md                    # archive listing page metadata only

data/
├── history_timeline.toml            # optional sidebar timeline
├── trustees.toml                    # current trustee board
└── reports.toml                     # AGM / Trustee Annual Reports manifest

static/about/reports/
├── 2024-trustees-annual-report.pdf
├── 2023-trustees-annual-report.pdf
└── 2022-agm-minutes.pdf
```

## Front-matter schema (`content/about/history.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Our history" | Page heading |
| `founded` | int | no | — | Year founded — renders prominently |
| `cover_image` | string | no | — | Path under `assets/about/` |
| `cover_alt` | string | yes if image | — | |
| `show_timeline` | bool | no | true | Whether to render `data/history_timeline.toml` |
| `timeline_position` | string | no | "sidebar" | "sidebar" \| "top" \| "bottom" |
| `wikipedia_url` | string | no | — | Optional link to Wikipedia "oldest Scout groups" entry |
| `photo_consent` | bool | yes if image | — | See SPEC-COMMON §10 |

Body: free Markdown — narrative history.

## Data schema (`data/history_timeline.toml`)

```toml
[[entry]]
  year = 1908
  title = "First Cub Pack formed"
  detail = "The first six members met in St Mary's Hall."

[[entry]]
  year = 1950
  title = "New HQ opened"
  detail = "The current Scout Hut on Church Lane opened, funded by jumble sales."
  image = "1950-hq-opening.jpg"     # in assets/about/timeline/
  image_alt = "Black-and-white photo of the new Scout Hut, 1950"
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `year` | int | yes | — | |
| `title` | string | yes | — | |
| `detail` | string (HTML allowed) | no | "" | |
| `image` | string | no | — | Filename under `assets/about/timeline/` |
| `image_alt` | string | yes if image | — | |

## Front-matter schema (`content/about/governance.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Governance" | Page heading |
| `intro` | string (HTML allowed) | no | "" | |
| `agm_date` | string | no | — | Free text — "Tuesday 15 May 2026, 19:30" |
| `agm_location` | string | no | — | |
| `agm_papers_url` | string | no | — | Pre-AGM papers PDF |
| `show_reports_archive` | bool | no | true | Surfaces /about/reports/ |

## Data schema (`data/trustees.toml`)

Theme ships an empty file with comment-rich example.

```toml
# data/trustees.toml — populated per Group.
# Public on the Charity Commission register; no contact details rendered.

# [[trustee]]
#   name = "Jane Smith"
#   role = "Chair of Trustees"
#   appointed = 2023
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `name` | string | yes | — | Public on Charity Commission register |
| `role` | string | yes | — | |
| `appointed` | int | no | — | Year |

## Data schema (`data/reports.toml`)

Manifest of AGM-related documents (combined: Trustee Annual Reports
AND AGM minutes). Build emits a warning when files exist in
`static/about/reports/` that aren't listed here.

```toml
[[report]]
  filename = "2024-trustees-annual-report.pdf"
  label = "2024 Trustees' Annual Report"
  year = 2024
  type = "annual_report"          # "annual_report" | "agm_minutes" | "other"

[[report]]
  filename = "2023-trustees-annual-report.pdf"
  label = "2023 Trustees' Annual Report"
  year = 2023
  type = "annual_report"

[[report]]
  filename = "2024-agm-minutes.pdf"
  label = "2024 AGM Minutes"
  year = 2024
  type = "agm_minutes"
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `filename` | string | yes | — | Must exist in `static/about/reports/` |
| `label` | string | yes | — | Display label |
| `year` | int | yes | — | Used for sort |
| `type` | enum | no | "other" | "annual_report" \| "agm_minutes" \| "other" |

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/about/history.html` | Single-page layout for `history.md` |
| `layouts/about/governance.html` | Single-page layout |
| `layouts/about/reports/list.html` | `/about/reports/` archive listing |
| `layouts/partials/history-timeline.html` | CSS-only vertical timeline |
| `layouts/partials/trustee-list.html` | |
| `layouts/partials/agm-archive.html` | Lists PDFs from manifest |
| `layouts/partials/charity-info.html` | Charity number and regulator block (used in footer) |

## hugo.toml additions

```toml
[params.features]
  history    = false                  # default OFF — opt-in
  governance = false                  # default OFF — opt-in

[params.governance]
  show_in_footer          = true      # render charity-info partial in every non-printing footer
  charity_number          = ""
  charity_name            = ""        # if different from group title
  regulator               = "Charity Commission for England and Wales"
  charity_url             = ""        # link to public register entry
  charity_secondary       = false     # set true if BSO Group with second jurisdiction
  charity_secondary_number = ""
  charity_secondary_regulator = ""
  charity_secondary_url   = ""
```

The footer partial in `baseof.html` includes `charity-info.html` when
**either** `charity_number` or `charity_secondary_number` is set AND
`show_in_footer` is true. Print stylesheet hides the block.

Most BSO Groups don't have a charity registration of their own (they
operate under BSO's England & Wales charity number 1151702). Such
Groups configure `charity_number = "1151702"`, `charity_name =
"British Scouting Overseas"`, `charity_url` pointing to the public
register entry. The configuration handles this naturally with no
special-casing.

## Asset paths

- `assets/about/cover.jpg` — history page cover.
- `assets/about/timeline/<year>.jpg` — optional timeline images.
- `static/about/reports/<filename>.pdf` — AGM-related documents.

## CSS-only baseline

- Timeline: vertical line via `position: absolute` pseudo-element on
  a flex column, year markers as bullets.
- Trustee list: definition list (`<dl>`) for semantic correctness.
- AGM archive: simple ordered list with PDF icon (CSS only).
- Charity number footer block: small, neutral styling, hidden in
  print via `@media print { .charity-info { display: none; } }`.

## BSO notes

Many BSO Groups operate under BSO Area's charity registration
(England & Wales, 1151702) rather than registering separately. The
single-charity configuration handles this — Groups set
`charity_number = "1151702"`. Some BSO Groups have a host-country
legal personality (1st Brussels is also a Belgian ASBL,
BE1013020290) — the `charity_secondary_*` block handles dual
jurisdictions.

The history feature is *especially* relevant for BSO. Several BSO
Groups have rich histories. The BSO Hub (SPEC-10) cross-links to
`/about/history/` when present.

## Safeguarding & GDPR

- Trustee names are public on the Charity Commission register —
  listing them is legitimate. No contact details.
- Photos in the history timeline of identifiable young people require
  `photo_consent = true` on the parent page.
- Historic photos (pre-1990s) of young people who are now adults:
  documentation note that Groups consider whether to feature these.

## Decided

| Q | Decision |
| --- | --- |
| Q7.1 | **Charity info config-gated**, displayed in every non-printing footer when configured. Hidden in print. Most BSO Groups will configure with BSO Area's charity number 1151702. |
| Q7.2 | **Manifest** (`data/reports.toml`) with build warning when filesystem PDFs aren't in the manifest. Best of both — explicit ordering plus drift detection. |
| Q7.3 | **Empty starter** for `data/trustees.toml` with comment-rich example. Don't ship placeholder names. |
| Q7.4 | **Combine** — single archive of AGM-related documents (Trustee Annual Reports + AGM minutes). The `type` enum distinguishes them. |

## Out of scope (cross-references)

- Per-trustee profile pages.
- Email contact form for trustees.
- Charity finance dashboards.
- Annual fundraising report (part of the Trustee Annual Report PDF).
- Specific historical events as News posts → SPEC-01.

## Implementation order

1. `archetypes/about-history.md` and `archetypes/about-governance.md`.
2. `layouts/about/history.html` with hardcoded narrative.
3. `data/history_timeline.toml` skeleton.
4. `layouts/partials/history-timeline.html` CSS-only.
5. `layouts/about/governance.html` with hardcoded trustees.
6. `data/trustees.toml` empty starter.
7. `data/reports.toml` manifest.
8. Reports archive partial reading the manifest, with build warning
   for unlisted filesystem PDFs.
9. Charity number footer partial + `show_in_footer` config flag.
10. Wire footer inclusion in `baseof.html`.
11. BSO `charity_secondary_*` block.
12. Wikipedia outbound link rendering.
13. Print stylesheet hides charity-info footer block.
14. CSS, i18n, README, screenshot.
