# SPEC-02 — Session Handoff (2026-05-10)

Pick this up alongside the live repo (project knowledge) and Claude's
memory. Memory already carries: handoff format (tarball for new files,
`.patch` for diffs), the dev/deploy command (`hugo serve
--buildDrafts=false --buildFuture=false` from `exampleSite/`), and the
`where-we-meet` / `embed` adjacency rule in `_index.md`.

## SPEC-02 acceptance status

| # | Criterion | Status |
| - | - | - |
| 1 | `/events/` listing, future-only by default | ✅ done |
| 2 | Per-event page with `event.ics` download link | ✅ done |
| 3 | RFC 5545 valid .ics (Apple/Google/Outlook import) | ✅ code complete — **end-to-end import verification still pending** |
| 4 | Aggregate `/events/all.ics` | ✅ done |
| 5 | Home-page `events-upcoming` block | ✅ done (live and verified) |
| 6 | `/events/past/` archive route | 🟡 TODO |
| 7 | Cancelled badge + `STATUS:CANCELLED` | ✅ rendering and .ics done; `--warning` palette token applied by Peter manually — confirm |
| 8 | Multi-day single VEVENT with DTSTART/DTEND span | ✅ done (Cubs Summer Camp example exercises this) |
| 9 | BSO dual times (`times_local` + `times_uk`) | 🟡 TODO |
| 10 | `params.features.events` gates everything | ✅ done |
| 11 | exampleSite exercises all field combinations | 🟡 partial — BSO dual-time example still missing |

## Decisions made this session — apply to spec docs

These were resolved in conversation but **not yet patched into the spec
markdown files**. First job for the next session is to patch
`documentation/specs/SPEC-02-events.md`.

1. **Front-matter schema (Schema table):**
   - Drop the `start` row entirely. `date` IS the event start.
   - Add a `publishDate` row above `end`. Required, auto-set by the
     archetype to "moment of `hugo new`". Always past at any later
     build, so Hugo's `--buildFuture=false` build still includes
     future events. Authors normally leave it alone.
   - Change `end` default from "start + 2h" to "date + 1h30" for timed
     events. For single-day all-day, default is "same date as `date`"
     (the partial handles the RFC 5545 +24h exclusive-DTEND shift).

2. **Acceptance criteria:** add an explicit note that events use
   `publishDate` for Hugo's `--buildFuture` check, not `date`. Without
   that, the deploy policy `--buildFuture=false` would exclude every
   upcoming event — broken for the entire feature.

3. **UID host:** UID format is `<slug>@<host>` where `<host>` is the
   host portion of `site.BaseURL` (e.g. `1stadscouts.org`). Stable
   across rebuilds.

4. **Aggregate `/events/all.ics` scope:** upcoming events only,
   *including* cancelled-upcoming (so subscribers see the cancellation
   propagate to their calendar).

5. **Date pill format:** stacked — large day number, abbreviated month
   (e.g. "Jul"), year. Year always shown.

6. **Demo-roller pattern (new "Decided" row):** `scripts/roll-example-dates.py`
   + `[demo]` block convention. Theme-repo only; Group sites consuming
   the theme have no `[demo]` blocks and the script ignores their
   events. See file header in `roll-example-dates.py` and the live
   block in `2026-07-12-summer-fete.md`.

## DECISIONS.md update

Add a row capturing the demo-roller convention. The committed dates in
git are the canonical "last known good" example dates; the script
overwrites them in-flight before every `hugo serve` and CI build. The
working tree's modified events should NOT be committed (`make clean`
reverts).

## Deferred items (intentionally — not bugs)

- **photo_consent errorf lint for events** — pattern exists in
  `news-card.html`; port it once the richer `single.html` adds cover
  image rendering. SPEC-COMMON §10 is the rule.
- **Richer `single.html`** — currently minimal (title, date, location,
  body, calendar link). Needs date pill, kit/cost/RSVP info strip,
  cover image, dual times, section badges, audience, dress.
- **`layouts/events/term.html`** — section pills on cards currently
  404 because the term route doesn't exist. Same transient state SPEC-01
  had before its `term.html` landed.
- **Past archive sub-section** — `content/events/past/_index.md`
  with `archive = true` cascading param; `list.html` branches on
  `.Params.archive` to filter to past events instead of upcoming.
- **README section + screenshot** for the Events feature.
- **RFC 5545 line folding (>75 octets)** — TODO comment lives in
  `layouts/partials/event-vevent.ics`. Real-world consumers handle
  long lines fine but strict spec compliance wants folding.
- **news-meta.html refactor to call section-badges.html** — currently
  the news partial inlines its own copy of the section lookup.
  Out of SPEC-02 scope; flagged for a later cross-cutting cleanup.

## Suggested next slice

**BSO dual-time rendering** (step 8 in the spec's Implementation order,
acceptance criterion #9). Self-contained, visually rewarding, exercises
fields the schema already names.

Scope:
1. Extend `layouts/partials/event-times.html` to render dual times
   when both `times_local` and `times_uk` are set (a `<dl>` pair —
   Brussels label + UK label).
2. Add a fourth example event (e.g. Brussels District Camp planning
   meeting) with both times set, plus a `[demo]` block. SPEC-02 says
   these times are pure free-text strings — no datetime parsing — so
   the .ics still uses `date` for DTSTART.
3. CSS under the existing `event-times` / `event-meta` blocks for the
   dual-time stacked-on-mobile, side-by-side-on-wide layout.
4. Confirm: SPEC-02 §"BSO notes" says NO `params.bso` gating — any
   Group hosting an international event might use this. Keep that.

After BSO dual-time, the recommended order is:
- Past archive (closes #6)
- Richer single.html (closes most of step 12 plus the photo-consent lint)
- term.html (fixes the section-pill 404s)
- README + screenshot (closes step 12 entirely)
- RFC 5545 line folding pass (final polish)
- Apple/Google/Outlook end-to-end import verification (#3 final gate)

## Stale-doc flags raised this session

- `theme.toml` says `min_version = "0.156.0"`. Project knowledge's
  `SPEC-COMMON.md` already reflects this. The copy of SPEC-COMMON
  uploaded by Peter at session start said `0.128`; that copy was
  stale, project knowledge is right.
- `data/scout_sections.toml` uses field names `color` / `text_color`
  (US spelling). `SPEC-COMMON.md` §7 documents the field as `colour`.
  Implementation is the source of truth — small SPEC-COMMON edit
  needed.

## Files touched this session (now in repo per Peter's commits)

New:
- `archetypes/events.md`
- `layouts/events/single.html`
- `layouts/events/single.eventcalendar.ics`
- `layouts/events/list.html`
- `layouts/events/list.eventsaggregatecalendar.ics`
- `layouts/partials/event-vevent.ics`
- `layouts/partials/event-meta.html`
- `layouts/partials/event-times.html`
- `layouts/partials/event-card.html`
- `layouts/partials/section-badges.html` (NEW shared partial — generic over content type)
- `layouts/partials/sections/events-upcoming.html`
- `exampleSite/content/events/_index.md`
- `exampleSite/content/events/2026-07-12-summer-fete.md`
- `exampleSite/content/events/2026-08-14-cubs-summer-camp.md`
- `exampleSite/content/events/2026-09-26-leaders-training.md`
- `scripts/roll-example-dates.py`
- `Makefile`

Modified:
- `exampleSite/hugo.toml` — output formats, `params.features.events`, `params.events`
- `exampleSite/content/_index.md` — `events-upcoming` block before `news-grid`
- `layouts/partials/head.html` — palette injection AFTER theme.css (cascade fix)
- `assets/css/theme.css` — `s-events-upcoming`, `event-card`, `event-meta`, `section-badges` blocks
- `data/palettes.toml` + `layouts/partials/palette-style.html` — `--warning` and `--text-on-warning` tokens added (Peter applied manually — verify these landed correctly across all five palettes: classic-purple, adventure, coastal, vibrant, network)
