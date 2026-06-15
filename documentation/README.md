# Hugo British Scouting Overseas Theme - feature spec pack

This pack defines the v1 feature roadmap for the
`hugo-british-scout-group` theme. The current `1stadscouts.org`
homepage is what ships by default; every spec in this pack adds an
**opt-in** feature.

## Reading order

1. **`DECISIONS.md`** - locked-in architectural and design choices.
   Read first. Cross-cutting items: the all-features-opt-in policy,
   new palette tokens, section badge colours, URL conventions, DBS
   policy, BSO POR default visibility.
2. **`SPEC-COMMON.md`** - shared conventions every feature spec
   assumes. Read second.
3. **`SPEC-NN-<feature>.md`** - the per-feature specs. Read the one
   you're implementing in the current session.

Project Knowledge for an implementation session should contain:
- The theme repo files
- `DECISIONS.md` and `SPEC-COMMON.md` (always)
- The specific `SPEC-NN-*.md` for the feature you're building
- The Scouts Brand Guidelines 2023 PDF (only when working on palette
  or section colours)

## The twelve specs

Ten per-feature specs (each defining one opt-in feature) plus two
cross-cutting specs that affect every feature:

| # | Feature | Spec |
| --- | --- | --- |
| 1 | News & Camp Reports | `SPEC-01-news.md` |
| 2 | Events with `.ics` download (incl. aggregate `/events/all.ics`) | `SPEC-02-events.md` |
| 3 | Termly Programme with Skills for Life themes | `SPEC-03-programme.md` |
| 4 | Photo Galleries with optional video links | `SPEC-04-galleries.md` |
| 5 | Camp Kit Lists (structured, printable, with desert variants) | `SPEC-05-kit-lists.md` |
| 6 | Joining & Welcome Pack (multi-pack, printable Welcome Pack) | `SPEC-06-joining.md` |
| 7 | History & Governance (with charity-info footer) | `SPEC-07-history-governance.md` |
| 8 | Hall Hire | `SPEC-08-hall-hire.md` |
| 9 | Fundraising & Volunteering (per-role remote flag, conditional banner+nav) | `SPEC-09-fundraising.md` |
| 10 | BSO Joining Eligibility & Moving Hub (POR visible by default) | `SPEC-10-bso-hub.md` |
| 11 | **Navigation** - auto-built hierarchical nav from feature flags (always on) | `SPEC-11-nav.md` |
| 12 | **Accessibility** - WCAG 2.2 AA baseline, skip link, focus visibility, audit lints (always on) | `SPEC-12-accessibility.md` |

## Recommended implementation order

1. **SPEC-01 News** - small, foundational, exercises the schema +
   taxonomy + photo-consent lint patterns the others reuse.
2. **SPEC-02 Events with `.ics`** - the highest single uplift,
   shares the section-badge and `--warning` token work with #1.
3. **SPEC-06 Joining & Welcome Pack** - biggest recruitment lever,
   introduces the `--status-*` tokens and the multi-pack data
   pattern.
4. **SPEC-10 BSO Hub** - once Joining cross-links exist, the BSO
   add-on is incremental.
5. **SPEC-04 Galleries** - high safeguarding bar; do after the
   simpler features have proved the lint patterns.
6. **SPEC-05 Kit Lists** - consumes the printable-route pattern
   used by Welcome Pack; depends on SPEC-02 for `kit_list_ref`.
7. **SPEC-07 History & Governance** - adds the charity-info footer
   that touches `baseof.html` (lower-risk to do once other features
   are in).
8. **SPEC-03 Programme** - depends on stable section-badge wiring;
   adds the programme-themes data file.
9. **SPEC-09 Fundraising** - adds the per-role `remote` flag and
   the conditional homepage banner / nav link logic.
10. **SPEC-08 Hall Hire** - smallest, isolated, leave to last.
11. **SPEC-11 Navigation** - implement after every per-feature spec
    that contributes a nav entry exists. Doing this earlier means
    backtracking the partial each time a feature lands.
12. **SPEC-12 Accessibility** - implement last as a hardening pass
    over everything that came before. The build-time audit lints in
    SPEC-12 will catch a11y regressions in earlier features
    retroactively, which is the point.

This isn't binding; it's a suggested order that minimises
backtracking.

## Cross-cutting summary (full detail in `DECISIONS.md`)

| Topic | Decision |
| --- | --- |
| Feature rollout | Every feature defaults OFF. `params.features.<name> = true` to opt in. Stale published content is worse than no content. |
| Palette tokens | New: `--warning` (cancelled / fully-booked), `--status-open`, `--status-waiting`, `--status-closed`. Defined per palette in `data/palettes.toml`. |
| Section badges | New `colour` field in `data/scout_sections.toml`. Squirrels `#25B755`, Beavers `#003982`, Cubs `#F7EF27`, Scouts `#E22E12`, Explorers `#088486`, Network `#000000`. Mix of brand-book and challenge-badge values. |
| DBS | Uniform UK Scouts policy globally including BSO. `dbs_required = true` default. Residency-since-age-10 nuance documented in archetype comments. No `safeguarding_check_note` field. |
| URL conventions | News flat (`/news/<slug>/`), events flat with date prefix in slug, galleries `/galleries/<slug>/<image-slug>/`, BSO under `/bso/`. |
| Past events archive | Hugo natural sub-section pattern: `content/events/past/_index.md` with `archive = true`. Single template branches. |
| Multi-day events | Single `VEVENT` with `DTSTART`/`DTEND` spanning the period. |
| Aggregate `.ics` | `/events/all.ics` generated at build via custom output format. |
| Programme themes | Skills for Life curriculum chips ship in v1 via `data/programme_themes.toml`. Encourages curriculum balance and District audit. |
| Galleries - video | Link-only support via `video_links` array. No hosted video, no embedded players. |
| Galleries - pruning | Not built. README documents the GitHub Actions cron pattern with the explicit warning that a forgotten cron will keep pruning. |
| Kit lists | Structured items `{name, quantity, alternative}`. Printable view at `/kit-lists/<slug>/print/` with checkboxes. Starter pack ships nine lists including desert-climate variants. |
| Welcome Pack | Hugo content section at `/welcome-pack/` with print stylesheet, NOT a PDF. Starter content ships in `exampleSite/`. |
| Joining - multi-pack | Array-per-section pattern in `data/sections_status.toml`. `[[cubs]]` repeated. `pack_name` field renders only when populated. |
| Volunteer roles | Per-role `remote = true` flag. Homepage banner block (`volunteer-recruitment-banner`) renders only when at least one role is open. Nav link "We're recruiting" conditional on the same. |
| Charity info | Config-gated, displayed in every non-printing footer when configured. BSO Groups typically configure with BSO Area's charity number 1151702. |
| Reports archive | `data/reports.toml` manifest with build warning when filesystem PDFs aren't in the manifest. |
| Native share | **Declined.** Would require JavaScript; theme stays no-JS. |
| BSO POR reference | Default visible. Rationale: not for people who are part of BSO; it's a firm policy nod for those who are actively trying to bypass POR as a local national. |
| Navigation | Auto-built from `params.features.*`. Five hardcoded top-level groups (Join Us, Our Sections, What we do, Get Involved, About). Smart collapse: single-child groups become direct top-level links. Empty groups disappear. Theme nav fully replaces any `[[menu.main]]` config - no merge. Pure CSS. |
| Accessibility | WCAG 2.2 AA baseline. Skip link, landmarks, `:focus-visible` ring per palette via new `--focus-ring` token. Build-time lints for image alt text and heading order, generalised from SPEC-01's pattern. axe-core CI on PRs. Always on, no opt-out. |

## What's not in this pack

- A search feature (deferred - separate scoping)
- A members-only area (out of architectural scope; OSM is the
  authority for member data)
- An admin UI (Markdown + `hugo new` is the authoring interface)

## Working method

- Confirm design decisions before implementing. Don't assume.
- Validate builds incrementally - schema first, then partial, then
  CSS, then i18n. Don't write a sprawl of templates and try to build
  at the end.
- Read access only on GitHub repos. Never attempt writes.
- The old Mobirise site (`petemahon/adscouts`) is reference-only.
  `petemahon/hugo-adscouts` is the live site.
