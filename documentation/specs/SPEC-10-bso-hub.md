# SPEC-10: BSO Joining Eligibility & Moving-In/Moving-Out Hub

Read `SPEC-COMMON.md` first.

## Goal

A BSO-only content hub that surfaces:

- Joining eligibility (POR 3.2.1.1, language requirement, nationality
  rules)
- Moving-in pathway (newly-arrived British family in host country)
- Moving-out pathway (transferring to another BSO Group, returning to
  UK, joining host-country NSO)
- Host-country alternative scouting organisations (with localised
  links)
- Home-range / InTouch policy (operational reach, e.g. 1st The
  Hague's ~20 km radius around Voorschoten)

The feature exists *only* when `site.Params.bso.enabled = true`. This
is the single feature that's BSO-gated end-to-end.

The POR reference is rendered by default. Rationale: this is not for
people who are part of BSO; it is a firm policy nod for those who are
actively trying to bypass POR as a local national.

Real parallels: 1st The Hague (`/newjoiners`, `/permissions`,
`/theteam`), 1st Brussels (`/joining-in/`), 1st Chantilly (Southern
Europe BSO), Northern Europe BSO (`/join/`), Central Brussels Scouts.

## Acceptance criteria

1. `/bso/` index page rendering an overview with cards linking to:
   eligibility, moving in, moving out, host-country scouting options.
2. `/bso/eligibility/` — expands the eligibility point in the Group's
   own voice (language, nationality, volunteering, host-country
   alternatives), with a POR 3.2.1.1 citation footnote visible by
   default (`por_reference_visible`). The canonical
   `bso-membership-notice` partial is NOT embedded here — per the
   consolidation decision it renders once site-wide, on `/join/`.
3. `/bso/moving-in/` — newly-arrived family pathway: how to enrol,
   school-term anchor, what to expect.
4. `/bso/moving-out/` — leaving the host country: transfer to another
   BSO Group, transfer to UK, transfer to host-country NSO,
   transferring records.
5. `/bso/host-scouting/` — links to host-country WOSM-recognised
   National Scout Organisation(s) with brief description and
   language note.
6. The Joining page (SPEC-06) cross-links to `/bso/eligibility/`.
7. Optional `/bso/home-range/` page rendering a static map of the
   home range and the InTouch policy summary.
8. **Small "BSO links" footer component** on every BSO sub-page
   linking to the BSO Area site and the District site.
9. Feature gated end-to-end by `site.Params.bso.enabled`. With
   `enabled = false`, none of these pages render and links to them are
   suppressed in menus.
10. `params.features.bso_hub` (default OFF when `enabled = true`) — even
    when BSO is on, the hub is opt-in per the cross-cutting opt-in
    policy. BSO Group enables it explicitly when ready.
11. Example site exercises: a UAE BSO Group, a Netherlands BSO Group,
    a Belgium BSO Group with dual-NSO badging.

## Content layout

```
content/bso/
├── _index.md
├── eligibility.md
├── moving-in.md
├── moving-out.md
├── host-scouting.md
└── home-range.md           # optional, gated by config

data/bso/
└── alternatives/           # files like nl.toml, be.toml, fr.toml, ae.toml
    ├── nl.toml             # one row per WOSM-recognised NSO in Netherlands
    └── ae.toml

assets/bso/
└── home-range.png          # static OSM tile generated at build by Group
```

`data/currencies.toml` is reused (introduced in SPEC-06) for
currency rendering on the moving-in page.

## Front-matter schema (`content/bso/_index.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "BSO information" | |
| `intro` | string (HTML allowed) | no | "" | |
| `cards` | list[block] | no | computed | Override the default four cards |

Default cards (computed when `cards` unset): Eligibility, Moving in,
Moving out, Host-country scouting.

## Front-matter schema (`content/bso/eligibility.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Who can join us" | |
| `intro` | string (HTML allowed) | no | — | |
| `language_requirement` | string (HTML allowed) | yes | — | "English at home or attends an English-speaking school" |
| `nationality_filter` | string (HTML allowed) | no | "" | "Not nationals of <host country>" — POR 3.2.1.1 |
| `volunteer_eligibility_open` | bool | no | true | Renders the "anyone over 18 can volunteer" line |
| `host_country_alternatives_summary` | string (HTML allowed) | no | "" | Short blurb pointing to /bso/host-scouting/ |
| `por_reference_visible` | bool | no | true | **Default true.** Renders a POR 3.2.1.1 citation footnote at the foot of the eligibility page. Per-Group toggle to hide. |

## Front-matter schema (`content/bso/moving-in.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Moving to <host country>" | i18n + host country interpolation |
| `intro` | string (HTML allowed) | yes | — | |
| `school_term_anchor` | string | no | — | "British School in the Netherlands term-time" |
| `meeting_locations_summary` | string (HTML allowed) | no | — | Brief sketch — full info on Where We Meet |
| `subscription_currency` | string | no | "GBP" | ISO 4217 (resolved via `data/currencies.toml`) |
| `subscription_amount` | string | no | "" | Free text — "130", "1500" |
| `subscription_period` | string | no | "year" | "term" \| "month" \| "year" |
| `joining_fee` | string | no | "" | Optional one-off fee |
| `kit_purchase_help` | string (HTML allowed) | no | "" | Where to buy uniform locally |
| `parent_volunteer_ask` | string (HTML allowed) | no | "" | "Parents are warmly encouraged to volunteer…" |
| `induction_pdf` | string | no | — | Path to a downloadable induction PDF (under `static/`) |

## Front-matter schema (`content/bso/moving-out.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Moving on" | |
| `intro` | string (HTML allowed) | yes | — | |
| `to_other_bso_blurb` | string (HTML allowed) | no | i18n default | "If you're moving to another country contact us and we may be able to help find a group for you." |
| `to_uk_blurb` | string (HTML allowed) | no | i18n default | Returning to UK pattern |
| `to_host_nso_blurb` | string (HTML allowed) | no | i18n default | Joining the host-country NSO |
| `records_transfer_blurb` | string (HTML allowed) | no | i18n default | OSM transfer + safeguarding records |
| `bso_area_contact_url` | string | no | "https://www.britishscoutingoverseas.org.uk/" | Editable for future BSO Area URL changes |

## Front-matter schema (`content/bso/host-scouting.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Scouting in <host country>" | |
| `intro` | string (HTML allowed) | yes | — | |
| `host_country_iso` | string | yes | — | ISO 3166-1 alpha-2, e.g. "nl", "be", "fr", "ae". Used to load `data/bso/alternatives/<iso>.toml` |

## Data schema (`data/bso/alternatives/<iso>.toml`)

```toml
[[organisation]]
  name = "Scouting Nederland"
  url = "https://www.scouting.nl/"
  language = "Dutch"
  joining_url = "https://www.scouting.nl/word-lid"
  description = "The national WOSM-recognised scouting body for the Netherlands."

[[organisation]]
  name = "FOS Open Scouting"
  url = "https://www.fos.be/"
  language = "Dutch / French"
  joining_url = ""
  description = "Federation of Open Scouts — operates in Belgium and the Netherlands; some BSO Groups co-badge."
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `name` | string | yes | — | |
| `url` | string | yes | — | |
| `language` | string | yes | — | |
| `joining_url` | string | no | "" | Direct join page if known |
| `description` | string (HTML allowed) | no | "" | |

## Front-matter schema (`content/bso/home-range.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Home range and InTouch" | |
| `intro` | string (HTML allowed) | yes | — | |
| `centre_label` | string | yes | — | "Voorschoten", "Brussels HQ", "Mushrif Park" |
| `radius_km` | int | no | — | The configured radius |
| `radius_label` | string | no | "" | Free-text override e.g. "approximately 20 km" |
| `static_map_image` | string | no | "home-range.png" | Filename under `assets/bso/` |
| `static_map_alt` | string | yes if image | — | |
| `intouch_policy_summary` | string (HTML allowed) | yes | — | Brief, pointing to full policy PDF |
| `policy_pdf` | string | no | — | Path to full InTouch policy PDF |
| `cross_border_event_note` | string (HTML allowed) | no | "" | "Outside the home range, a permission form is required" |

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/bso/list.html` | `/bso/` index |
| `layouts/bso/single.html` | Generic per-page renderer for the four/five sub-pages |
| `layouts/partials/bso-eligibility.html` | Eligibility partial — composes `bso-membership-notice` |
| `layouts/partials/bso-moving-in.html` | |
| `layouts/partials/bso-moving-out.html` | |
| `layouts/partials/bso-host-scouting.html` | Iterates `data/bso/alternatives/<iso>.toml` |
| `layouts/partials/bso-home-range.html` | |
| `layouts/partials/bso-subscription.html` | Currency-aware fee block, reuses `data/currencies.toml` |
| `layouts/partials/bso-card.html` | Hub-page card |
| `layouts/partials/bso-links-footer.html` | Small footer component on every BSO sub-page linking to BSO Area + District |

## hugo.toml additions

```toml
[params.features]
  bso_hub = false                           # default OFF — opt-in even when enabled = true

[params.bso]
  enabled           = true                  # site-wide master switch (table key, not a scalar)
  host_country_iso  = "nl"
  host_country_name = "the Netherlands"
  host_association  = "Scouting Nederland"
  show_home_range   = false
  show_host_alternatives = true
  district          = "Northern Europe"     # for cross-link to BSO Area District
  district_url      = "https://www.bsonortherneurope.org/"
  bso_area_url      = "https://www.britishscoutingoverseas.org.uk/"

[params.bsoMembershipNotice]
  enable                  = true
  hostCountryName         = "the Netherlands"
  hostScoutingAssociation = "Scouting Nederland"
```

The existing `bsoMembershipNotice` block is consumed by
`partials/bso-membership-notice.html` (already in theme) — no change.

`host_country_name` may include the article ("the Netherlands"), per
existing `bsoMembershipNotice` convention.

## Asset paths

- `assets/bso/home-range.png` — static OSM tile, generated by Group
  via a one-off script (theme docs include a 10-line `curl` example
  using OSM tile servers + ImageMagick). Theme ships a generic
  placeholder.
- `static/bso/induction-pack.pdf` — newly-arrived families pack.
- `static/bso/intouch-policy.pdf` — full policy.

## CSS-only baseline

- Hub page: card grid (4 cards default).
- Eligibility: prose layout. The canonical membership notice is NOT
  embedded here (it lives on `/join/`); a POR 3.2.1.1 citation
  footnote renders at the foot of the page by default.
- Host-scouting: cards listing each alternative NSO with language,
  description, link.
- Home-range: image + prose. No interactive map.
- BSO links footer: small, neutral, sits below main content above
  the standard site footer.

## BSO notes — this is the BSO feature

Everything here is BSO. The `[params.bso].enabled` site-level switch
must be true for any of this to render. The theme's `index.html`
dispatcher gracefully omits any `bso-*` section types when
`enabled = false`.

The data files in `data/bso/alternatives/` ship pre-populated for the
most common BSO host countries (Netherlands, Belgium, France,
Germany, Spain, UAE, Singapore, USA — BSO Area's published reach is
"29 countries"). Groups override by adding to or replacing the file
matching their `host_country_iso`.

## Safeguarding & GDPR

- No data collection.
- Eligibility prose is editorial; the canonical membership statement
  is the `bso-membership-notice` partial, rendered once site-wide on
  `/join/`. The eligibility page carries only the POR 3.2.1.1 citation
  footnote.
- Host-country alternatives are public information; safe to publish.
- Home-range page must not show actual member home addresses.
- InTouch policy: link to the Group's own PDF.

## Decided

| Q | Decision |
| --- | --- |
| Q10.1 | **Yes** — small "BSO links" footer component on every BSO sub-page linking to BSO Area + District. New partial `bso-links-footer.html`. |
| Q10.2 | **Yes** — `host_country_name` accepts the article ("the Netherlands"). Existing `bsoMembershipNotice` convention. |
| Q10.3 | **No** — don't bake BSO Area statistics into theme prose. Statistics drift; Groups add as Markdown when wanted. |
| Q10.4 | **No** — BSO Heritage Team page out of scope. v2 follow-up if BSO Heritage publishes a stable schema. |
| Q10.5 | **Reuse** `data/currencies.toml` (introduced SPEC-06) for moving-in subscriptions. Single source of truth. |
| Q10.6 | **Default `por_reference_visible = true`.** Rationale: this is not for people who are part of BSO; it is a firm policy nod for those who are actively trying to bypass POR as a local national. Per-Group toggle to hide. |

## Out of scope (cross-references)

- BSO national headcount visualisation.
- Live "find a BSO Group near me" map.
- Application form for joining BSO.
- BSO Area volunteer recruitment → SPEC-09 covers via per-role
  `remote = true` flag.
- BSO Heritage Group archives.
- Cross-Group event pages (BSO District Camp, etc.) → Events
  (SPEC-02); SPEC-10 surfaces the District link, not the events.

## Implementation order

1. Verify the existing `params.bso` flag and `bsoMembershipNotice`
   wiring still works.
2. Add `params.features.bso_hub`, plus
   `params.bso.{host_country_iso, host_country_name, host_association,
   show_home_range, show_host_alternatives, district, district_url,
   bso_area_url}` to the example `hugo.toml`.
3. Create `content/bso/_index.md` and `layouts/bso/list.html`.
4. Create `content/bso/eligibility.md` and the
   `bso-eligibility.html` partial — verify it composes the existing
   `bso-membership-notice.html` correctly with
   `por_reference_visible = true`.
5. Create `content/bso/moving-in.md` and partial.
6. Create `content/bso/moving-out.md` and partial.
7. Create `data/bso/alternatives/nl.toml` (and a couple of other
   common ISOs) and the `bso-host-scouting.html` partial.
8. Create `content/bso/home-range.md` (gated by
   `params.bso.show_home_range`).
9. Build `bso-links-footer.html` and wire into BSO sub-page layouts.
10. Wire SPEC-06 (Joining) cross-links to `/bso/eligibility/`.
11. CSS, i18n strings (note: many already exist for the membership
    notice; new keys needed for hub headings and section labels).
12. Test the gating: build with `[params.bso].enabled = false` should
    show none of these pages, no broken links.
13. Test all three reference patterns (NL, BE, AE) build clean with
    different `host_country_iso` values.
14. README — a substantial section covering the BSO feature
    end-to-end including the rationale for default-visible POR.
15. Update `DECISIONS.md` if any new BSO architectural choice is
    made (e.g. data-file structure for alternatives).
