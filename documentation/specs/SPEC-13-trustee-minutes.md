# SPEC-13: Trustee Board Minutes

Read `SPEC-COMMON.md` first. Extends SPEC-07 (History & Governance).

## Goal

Make it easy for a Trustee Board — at **any** level of UK Scouting
(Group, District, County/Area/Region) — to keep good minutes, and to
publish a short, safe account of what the board decides.

Two parts, deliberately separated:

1. **A universal authoring template** trustees fill in for each meeting,
   covering every standing agenda item plus level-specific business. Kept
   **private** by the board.
2. **A public summary archive** at `/about/minutes/` — short, redacted
   "decisions taken" summaries only, opt-in per meeting.

## Why summaries only (the safeguarding decision)

This theme has **no backend and no authentication** (a locked invariant),
so anything rendered is fully public. Full Trustee Board minutes routinely
contain confidential matter — live safeguarding cases, named young people
and volunteers, HR/personnel matters, detailed finances. Publishing them
would be a safeguarding and GDPR risk. So the theme **never** renders full
minutes: only short summaries the board has approved and redacted. Most
charities already work this way (they publish the Trustees' Annual Report
and AGM outcome, not routine board minutes).

Decided via the 4-question slate on 2026-06-13:

| Q | Decision |
| --- | --- |
| Publish model | **Public summaries only.** Full minutes authored privately; the site renders a short per-meeting summary. |
| Levels | **One universal template** with all core sections; the three level-specific blocks are optional (keep one, delete the rest). |
| Format | **Lightweight archive treatment**, reusing the reports-archive/balanced-info-page components — not rich per-meeting article pages. |
| Placement | Chosen as `/about/governance/minutes/`, but **landed at `/about/minutes/`** (flat under `/about/`, matching its siblings `history` / `governance` / `reports`). Nesting under the `governance.md` leaf isn't cleanly achievable — see "Placement" below. Cross-linked from the governance page and with `/about/reports/`. |

## Acceptance criteria

1. A universal minutes template ships at
   `documentation/templates/trustee-minutes-template.md`, covering the
   standing agenda items and the Group / District / County-Area-Region
   level blocks, with a clear "keep private" warning and a "public summary"
   section.
2. A page exists at `/about/minutes/` listing approved public summaries,
   newest meeting first, cross-linked from the governance page and with
   `/about/reports/`.
3. The feature is gated by `params.features.trustee_minutes` (default OFF)
   **and** requires `params.features.governance`.
4. Only summary files with `approved = true` render; unapproved/draft files
   never publish.
5. Full minutes are never rendered by the theme.
6. Example site exercises a Group-level board with ordinary meetings and an
   AGM summary.

## Content layout

```
documentation/templates/
└── trustee-minutes-template.md     # the universal authoring template

archetypes/
└── minutes.md                      # scaffolds a published summary

content/about/minutes/              # /about/minutes/
├── _index.md                       # section index (title + intro)
├── 2026-03-board.md                # approved public summaries
├── 2025-11-board.md
└── 2025-05-agm.md
```

**Placement — why `/about/minutes/`, not `/about/governance/minutes/`.**
`content/about/governance.md` is a leaf page, so a `content/about/governance/`
directory (needed to nest minutes under it) collides with it — a `.md` page
and a same-named branch directory both map to `/about/governance/`. Two ways
round it were tried and rejected: a `url` front-matter override on the
section `_index.md` (Hugo does not reliably publish a branch-section relocated
this way — it 404s), and converting governance to a branch bundle (risks the
shipped SPEC-07 layout resolution). `/about/minutes/` is the clean, reliable
home and is consistent with the other flat `/about/*` pages; the governance
page cross-links it so it still reads as "under governance" to visitors.

## Front-matter schema (summary files)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | — | Display title |
| `meeting_date` | string (ISO date) | yes | — | Display + newest-first sort |
| `meeting_type` | enum | no | "ordinary" | "ordinary" \| "extraordinary" \| "agm" |
| `level` | enum | no | `[params.minutes].level` | "group" \| "district" \| "county" |
| `present_count` | int | no | 0 | 0 hides the count |
| `quorum_met` | bool | no | false | Shows a "Quorum met" tag |
| `minutes_pdf` | string | no | — | Optional link to an approved redacted PDF |
| `approved` | bool | no | false | **Publication gate** — only `true` renders |
| `build` | table | yes | — | `render = "never"`, `list = "local"` (rendered inline, no standalone page, not in site-wide collections). The `build` key — renamed from `_build` in Hugo 0.145.0. |

Body: the short public summary (Markdown).

## hugo.toml additions

```toml
[params.features]
  trustee_minutes = false    # default OFF — opt-in; needs governance = true

[params.minutes]
  level = "group"            # "group" | "district" | "county" — labels the archive
```

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/about/minutes/list.html` | `/about/minutes/` archive listing |

No new partials — reuses `back-link.html`, the `.pb-*` balanced-info-page
components and the About stylesheet.

## CSS

Added to `assets/css/56-section-about.css`: `.s-minutes*` and a compact
`.minutes-list` / `.minutes-entry` card treatment. CSS-only, no JS.

## i18n

`minutes*` keys plus `governanceMinutesHeading` / `governanceMinutesLink`
for the governance-page cross-link. Level labels are host-country-generic.

## Navigation

**No nav change.** Reached via a cross-link from the governance page, to
keep the locked SPEC-11 nav contract untouched.

## Safeguarding & GDPR

- Full minutes are never published; only approved, redacted summaries.
- The template carries explicit guidance to remove names of young people
  and individuals, safeguarding/welfare/HR detail, and detailed finances
  before publishing, and to point to the Trustees' Annual Report instead.
- The `approved` gate defaults OFF so nothing publishes by accident.

## Out of scope

- Rendering full minutes anywhere.
- Per-meeting standalone pages / permalinks (lightweight archive only).
- Members-only / authenticated areas (no backend — a locked invariant).
- A data-manifest drift check (summaries are content files, not filesystem
  PDFs; the reports archive keeps its own PDF drift check).

## Implementation order

1. `documentation/templates/trustee-minutes-template.md` (universal template).
2. `archetypes/minutes.md`.
3. `layouts/about/minutes/list.html`, gated and rendering approved summaries.
4. Example `content/about/minutes/` (`_index.md` + summaries).
5. `hugo.toml`: `trustee_minutes` flag + `[params.minutes]`.
6. i18n strings.
7. CSS.
8. Governance-page cross-link.
