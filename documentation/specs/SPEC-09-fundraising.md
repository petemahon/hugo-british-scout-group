# SPEC-09: Fundraising & Volunteering

Read `SPEC-COMMON.md` first.

## Goal

Static page listing the Group's fundraising activities, plus a
separate volunteer-roles page surfaced via a homepage banner block
and a nav link when any role is currently open.

No payment processing, no application forms - purely informational.

Real parallels: Cheddington Scouts (full fundraising rotation:
Christmas Post, Lucky Number Club, easyfundraising, jumble, bonfire
BBQ), Ash Green's transparent reporting of capital costs, Scouts UK's
volunteer induction guidance.

## Acceptance criteria

1. A page exists at `/support-us/` listing fundraising activities
   and external links.
2. A separate page exists at `/support-us/volunteer-roles/` listing
   open vacancies as cards.
3. **Homepage banner block** `volunteer-recruitment-banner` (a new
   section type) renders only when at least one volunteer role is
   currently open (`role_open` not false and not past `closes` date).
   Suppressed silently otherwise.
4. **Nav link** "We're recruiting" appears in the main menu when at
   least one role is open. Hidden when no roles open. Configurable
   via `params.volunteer_roles.nav_link = true`.
5. Per-role pages at `/support-us/volunteer-roles/<slug>/`. Closed
   (past `closes` date or `role_open = false`) vacancies don't
   render.
6. **`remote = true` per-role flag** marks specific roles as
   remote-friendly with a "Remote OK" badge. Important for BSO
   recruitment of UK-resident remote volunteers.
7. Optional Gift Aid declaration PDF link.
8. Optional "annual budget" transparency block - high-level numbers,
   not detailed accounts.
9. Feature gated by `params.features.fundraising` (default OFF).
10. Example site exercises: a Group with all blocks enabled, a Group
    with only the volunteer-roles block, a Group with no current
    open roles (banner+nav suppressed), a remote-friendly role.

## Content layout

```
content/support-us/
├── _index.md
└── volunteer-roles/
    ├── _index.md
    ├── treasurer.md
    ├── assistant-cub-leader.md
    └── trustee.md
```

## Front-matter schema (`content/support-us/_index.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Support us" | Page heading |
| `intro` | string (HTML allowed) | yes | - | Group's why-we-need-support |
| `donate_url` | string | no | - | External link only |
| `donate_label` | string | no | "Donate" | |
| `easyfundraising_url` | string | no | - | |
| `amazon_smile_url` | string | no | - | |
| `localgiving_url` | string | no | - | |
| `justgiving_url` | string | no | - | |
| `stewardship_url` | string | no | - | |
| `giftaid_pdf` | string | no | - | Path to Gift Aid declaration PDF |
| `fundraising_activities` | list[block] | no | `[]` | See below |
| `annual_budget` | block | no | - | Inline budget block - see below |

Each `fundraising_activities` block:

```toml
[[fundraising_activities]]
  name = "Christmas Post"
  when = "December every year"
  detail = "Volunteers deliver Christmas cards across the village. £1 per card. Last year raised £2,400."
  contact_email = ""               # optional
```

`annual_budget` block (inline):

```toml
[annual_budget]
  income = "12000"
  expenditure = "11500"
  currency = "GBP"
  year = "2024-25"
  reserves_label = "We aim to keep three months of operating costs in reserves."
  reports_link = "/about/reports/"   # cross-link to SPEC-07
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `income` | string | no | - | Number as string |
| `expenditure` | string | no | - | |
| `currency` | string | no | "GBP" | |
| `year` | string | no | - | "2024-25" |
| `reserves_label` | string (HTML allowed) | no | "" | |
| `reports_link` | string | no | - | Path to governance/reports page |

## Front-matter schema (`content/support-us/volunteer-roles/_index.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Volunteer with us" | Page heading |
| `intro` | string (HTML allowed) | no | "" | Renders above the role grid |
| `closed_message` | string (HTML allowed) | no | "We're not actively recruiting right now, but please get in touch if you'd like to help." | Rendered when no roles are open |

## Front-matter schema (`content/support-us/volunteer-roles/<slug>.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | yes | - | Role title - "Treasurer", "Assistant Cub Leader" |
| `section` | string | no | "" | Optional - `data/scout_sections.toml` key |
| `time_commitment` | string | no | "" | Free text - "Two hours per week, term time" |
| `dbs_required` | bool | no | true | True for any role with young people. See SPEC-COMMON §11 for residency-since-age-10 nuance - captured in archetype comment header. |
| `remote` | bool | no | false | Renders "Remote OK" badge. BSO-relevant for UK-resident remote volunteers. |
| `start_date` | date | no | - | When the role would start |
| `closes` | date | no | - | Vacancy hidden after this date |
| `apply_email` | string | yes | - | Generic Group email |
| `apply_url` | string | no | - | External application link if used |
| `role_open` | bool | no | true | Soft-disable without deleting. **NB:** named `role_open`, not `published` - Hugo reserves `published` as a date field. |

Body: free Markdown - what the role involves, who'd suit it.

## Section partial: `volunteer-recruitment-banner`

Renders only when at least one role is currently open. Configurable
on the home page via `[[sections]]`:

```toml
[[sections]]
  type     = "volunteer-recruitment-banner"
  id       = "volunteer-banner"
  title    = "We're recruiting"
  message  = "Help us run the Group - we have open volunteer roles."
  cta_text = "See open roles"
  bg       = "primary"
```

When no roles are open, the partial outputs nothing - the home page
flows past as if the block weren't there.

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/support-us/single.html` | The fundraising page |
| `layouts/support-us/volunteer-roles/list.html` | `/support-us/volunteer-roles/` listing |
| `layouts/support-us/volunteer-roles/single.html` | Per-role page |
| `layouts/partials/sections/volunteer-recruitment-banner.html` | Homepage banner (conditional) |
| `layouts/partials/fundraising-activities.html` | Cards / list of activities |
| `layouts/partials/external-fundraising-links.html` | easyfundraising, JustGiving, etc. - URL only |
| `layouts/partials/volunteer-roles-grid.html` | Open vacancies grid |
| `layouts/partials/volunteer-role-card.html` | Per-role card |
| `layouts/partials/annual-budget.html` | Income/expenditure summary |

## hugo.toml additions

```toml
[params.features]
  fundraising = false                  # default OFF - opt-in

[params.fundraising]
  show_giftaid = true
  show_external_links_section_heading = true

[params.volunteer_roles]
  nav_link = true                      # add "We're recruiting" to main nav when any role open
  nav_link_label = "We're recruiting"
```

The nav-link logic lives in the nav partial: it counts open roles and
shows the link only if count > 0.

**Deferred to SPEC-11 (decided 2026-06-03).** AC4's conditional
"We're recruiting" nav link is owned by SPEC-11, which rebuilds the
nav from feature flags - adding the logic to the current static
`[[menu.main]]` header would be throwaway work. SPEC-09 ships the
single source of truth the nav link needs - `partials/volunteer-roles-open.html`
(the open-role count) - plus the homepage `volunteer-recruitment-banner`,
which already gives a prominent conditional entry point. The
`[params.volunteer_roles]` block (`nav_link`, `nav_link_label`) ships
now so the config is stable; SPEC-11 is its consumer.

## Asset paths

- `static/support-us/giftaid-declaration.pdf` - Gift Aid template.
- `static/support-us/annual-report.pdf` - if Group wants to surface
  it directly here as well as via Governance.

## CSS-only baseline

- Two-column layout on the fundraising page: activities + external-
  links + budget on left, nav to volunteer-roles on right. Stacks on
  mobile.
- External-links: card grid as URLs only. Theme does not ship logos
  (copyright); plain text labels are the default.
- Volunteer role cards link to their detail page.
- "Remote OK" badge: small pill, neutral colour with palette accent
  outline.
- Recruitment banner: full-width, prominent CTA button.

## BSO notes

The `remote = true` flag is BSO-relevant. BSO Area roles (e.g. BSO
Heritage Team, Vision 2025 Transformation Lead) are explicitly
"of any nationality, anywhere in the world" - these get
`remote = true`. Local-meeting roles like Assistant Cub Leader stay
`remote = false`.

The `bso_remote_volunteer` page-level flag was considered and
**rejected** in favour of per-role granularity (Q9.3 decision).

## Safeguarding & GDPR

- All applications go to email or external system. No data collection.
- DBS information: state plainly that the role requires a DBS check;
  do not collect anything related to DBS on the site. The archetype
  comment header documents the UK-residency-since-age-10 nuance (see
  SPEC-COMMON §11).
- Don't list named volunteers needing replacement ("we need to
  replace Joan who's standing down"). Roles are listed as roles.
- Don't list children's photos on the volunteer-recruitment page -
  use adult-with-young-people-from-behind imagery, or empty Scout
  Hut imagery.
- Annual budget: high-level only. No supplier names, individual
  donation amounts, or anything that could embarrass a donor.

## Decided

| Q | Decision |
| --- | --- |
| Q9.1 | **URLs only** - no logos for external fundraising platforms. Plain text labels; copyright concerns resolved at zero schema cost. |
| Q9.2 | **Separate page + homepage banner block + nav link**. Banner and nav link both render only when at least one role is open. |
| Q9.3 | **Per-role `remote` flag** - granular accuracy preferred over the page-level toggle. BSO Area-style remote roles get the flag; local roles don't. |
| Q9.4 | **Default `dbs_required = true`** with archetype comment documenting the UK-residency-since-age-10 nuance. No `safeguarding_check_note` field - DBS is uniform UK Scouts policy globally including BSO. |
| Q9.5 | **Inline** budget - single `[annual_budget]` block in front-matter. Set once a year. |

## Out of scope (cross-references)

- Payment processing.
- Donor management.
- Pledge tracking.
- Volunteer training records → OSM / OSM Adult.
- Trustee Board reports → SPEC-07 (Governance).
- Fundraising-event pages (Christmas Post, jumble sale dates) →
  Events (SPEC-02).
- "Lucky Number Club" / "100 Club" subscription mechanism - describe
  only, no data collection.

## Implementation order

1. Schema, `archetypes/support-us.md` and `archetypes/volunteer-role.md`
   (the latter with comprehensive comment header documenting DBS
   nuance).
2. `layouts/support-us/single.html` with hardcoded sections.
3. Replace with front-matter-driven content.
4. `layouts/partials/fundraising-activities.html`.
5. `layouts/partials/external-fundraising-links.html` with conditional
   rendering of each platform.
6. `layouts/partials/annual-budget.html` with currency rendering
   reusing `data/currencies.toml` from SPEC-06.
7. `layouts/support-us/volunteer-roles/list.html`.
8. `layouts/support-us/volunteer-roles/single.html`.
9. `layouts/partials/volunteer-role-card.html` with `remote` badge.
10. `layouts/partials/volunteer-roles-grid.html` with closes-date
    filtering.
11. `layouts/partials/sections/volunteer-recruitment-banner.html` -
    conditional rendering based on open-role count.
12. Wire conditional nav link in `baseof.html` nav partial.
13. CSS, i18n, README, screenshot.
