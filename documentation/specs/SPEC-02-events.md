# SPEC-02: Events with `.ics` download

Read `SPEC-COMMON.md` first.

## Goal

A page-per-event content type rendering date, time, location, kit
needed, cost, audience, and a downloadable `.ics` calendar file.
Aggregated into `/events/` index sortable by date and section.

The natural pair to News (SPEC-01) — together they cover the "what we
did" and "what's next" needs. Real parallels: Brent District event
pages, Chester-le-Street's St George's Day, BSO Northern Europe's
District Camp.

## Acceptance criteria

1. A new page exists at `/events/` listing upcoming events in
   chronological order. Past events are hidden by default. The listing
   filter compares each event's `date` against `now`. Hugo's
   `--buildFuture=false` deploy gate is satisfied by `publishDate`,
   which the archetype auto-fills to the moment of `hugo new`; without
   that distinction, a deploy with `--buildFuture=false` would exclude
   every upcoming event, breaking the entire feature.
2. Each event has its own page at `/events/<slug>/` with all fields
   below plus a "Download to calendar" link to a sibling `event.ics`
   file.
3. Hugo generates the `.ics` via a custom output format. The `.ics` is
   valid per RFC 5545 (test against iCal / Outlook / Google Calendar).
4. **Aggregate `/events/all.ics`** is generated at build time —parents
   can subscribe once to get every upcoming event. The aggregate
   **excludes cancelled events** (status="cancelled"): when an event
   is cancelled it is omitted from the feed entirely, and subscribers'
   calendar apps remove the meeting on next refresh. Postponed events
   ARE included with their new date and a prefixed DESCRIPTION ("Note:
   new date/time. "). Past events are excluded.
5. Home-page section block `events-upcoming` shows the next *N* events.
6. Past events accessible via `/events/past/` when
   `params.events.show_past_archive = true`.
7. **Cancelled events** render with a red Cancelled pill using the
    `--warning` palette token (`#d4351c`, see DECISIONS.md) ahead of
    the section badges. The per-event `event.ics` renders a
    well-formed but empty VCALENDAR (no VEVENT) so the URL stays
    valid for bookmarked subscribers and their calendar removes the
    meeting on next poll. The event is omitted from `/events/all.ics`.
    `STATUS:CANCELLED` is no longer emitted.
7b. **Postponed events** render with an amber Postponed pill using
    the `--postponed` palette token (`#d97706`) ahead of the section
    badges. The `date` field reflects the NEW date. The per-event
    `event.ics` and aggregate `/events/all.ics` emit the event with
    new DTSTART/DTEND, DESCRIPTION prefixed `"Note: new date/time. "`,
    and SEQUENCE bumped to at least 1 so subscriber calendars update
    the meeting in place rather than duplicating.
8. **Multi-day events** (camps) emit a single `VEVENT` with `DTSTART`
   and `DTEND` spanning the period, not daily VEVENTs.
9. BSO mode: events render two times when `times_local` and `times_uk`
   are both set (e.g. "20:30 (Brussels) / 19:30 (UK)").
10. Feature is fully gated by `params.features.events` (defaulting OFF).
11. The example site exercises: an upcoming event with all fields, a
    minimal event (just title/date/location), a cancelled event
    (`status="cancelled"`), a postponed event (`status="postponed"`,
    `revision=1`), a past event, a BSO event with dual times, a
    multi-day camp.

## Content layout

```
content/events/
├── _index.md                                  # listing metadata
├── 2026-04-26-st-georges-parade.md
├── 2026-05-15-summer-camp.md
└── past/_index.md                              # archive sub-section
```

Slug convention: `YYYY-MM-DD-kebab-case-title.md`.

## Front-matter schema (per event)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | yes | — | Event title |
| `publishDate` | datetime | yes | - | When the event was added to the site. Always past at deploy time so Hugo's `--buildFuture=false` build includes future events. The archetype auto-fills with the moment of `hugo new`; authors normally leave it alone. |
| `date` | datetime | yes | — | Event start. Used by Hugo for sort and listing. |
| `end` | datetime | no | `date + 1h30` | Used in `.ics` |
| `all_day` | bool | no | false | If true, `.ics` uses `VALUE=DATE` |
| `timezone` | string | no | `params.events.timezone` | IANA TZ, e.g. "Europe/Brussels" |
| `location` | string | yes | — | Venue name, e.g. "St Mary's Hall" |
| `address` | string | no | — | Full street address |
| `map_url` | string | no | — | OpenStreetMap or Google Maps link |
| `sections` | list[string] | no | `[]` | Taxonomy values |
| `cost` | string | no | "" | Free text — "£25", "Free", "€10 per Cub" |
| `cost_includes` | string | no | "" | "Activities, food, accommodation" |
| `kit_list_ref` | string | no | — | Slug of a kit list (SPEC-05) |
| `kit_list_url` | string | no | — | External kit list link if not local |
| `additional_kit` | string (HTML allowed) | no | "" | Per-event kit additions on top of the referenced kit list (SPEC-05 cross-ref) |
| `dress` | string | no | "" | "Full uniform", "Activity uniform", "Mufti" |
| `audience` | string | no | "" | "Cubs only", "Whole Group", "Parents welcome" |
| `rsvp_to` | string | no | — | Generic Group email, never personal |
| `rsvp_deadline` | datetime | no | — | Optional |
| `cost_pay_url` | string | no | — | External payment link only |
| `status` | string | no | `"active"` | `"active"`, `"cancelled"`, or `"postponed"`. Cancelled = red pill + removed from .ics feeds. Postponed = amber pill + .ics emitted with new date and bumped SEQUENCE. |
| `revision` | int | no | 0 | Bumped each time `date` changes on an existing event. SEQUENCE in the .ics is `max(revision, postponed ? 1 : 0)`. Required for re-postponing; first postponement handled automatically. |
| `cover_image` | string | no | — | Path under `assets/events/<slug>/` |
| `cover_alt` | string | yes if image | — | |
| `photo_consent` | bool | yes if image | — | See SPEC-COMMON §10 |
| `times_local` | string | no | — | BSO: e.g. "20:30 (Brussels)" |
| `times_uk` | string | no | — | BSO: e.g. "19:30 (UK)" |
| `external_url` | string | no | — | If event is hosted elsewhere (District camp, World Jamboree) |
| `external_url_label` | string | no | "More information" | Anchor text |

## Output format: `.ics`

Defined in `hugo.toml`:

```toml
[mediaTypes."text/calendar"]
suffixes = ["ics"]

[outputFormats.Calendar]
mediaType    = "text/calendar"
isPlainText  = true
notAlternative = true

# Per-event .ics (event.ics next to index.html)
[outputFormats.EventCalendar]
mediaType    = "text/calendar"
baseName     = "event"
isPlainText  = true
notAlternative = true

# Aggregate .ics (all upcoming events)
[outputFormats.EventsAggregateCalendar]
mediaType    = "text/calendar"
baseName     = "all"
isPlainText  = true
notAlternative = true
```

`content/events/_index.md` cascades `outputs = ["html", "EventCalendar"]`
to give every event both `index.html` and `event.ics`.

The events list page itself adds `EventsAggregateCalendar` to its
outputs, producing `/events/all.ics`.

`layouts/events/single.eventcalendar.ics` and
`layouts/events/list.eventsaggregatecalendar.ics` are the templates.
Both must emit valid VEVENTs (UTF-8, CRLF line endings, `UID:<slug>@<host>`,
`DTSTAMP` in UTC, `DTSTART`/`DTEND` in the configured timezone,
`SUMMARY`, `DESCRIPTION` plain-text-escaped, `LOCATION`, `URL`,
`STATUS:CANCELLED` if applicable).

`<host>` is the host portion of `site.BaseURL`, parsed via
`urls.Parse` (e.g. `1stadscouts.org`). Stable across rebuilds so a
calendar subscriber's events update in place rather than duplicating.

## Section partial: `events-upcoming`

```toml
[[sections]]
  type      = "events-upcoming"
  id        = "whats-on"
  title     = "What's coming up"
  count     = 4                # default 4
  show_more = true             # link to /events/
  bg        = "muted"
```

Renders cards: date pill, title, location, audience, "Details →" link.

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/events/list.html` | `/events/` upcoming, and `/events/past/` (single template, branches on `.Params.archive` set in `content/events/past/_index.md`) |
| `layouts/events/list.eventsaggregatecalendar.ics` | `/events/all.ics` |
| `layouts/events/single.html` | `/events/<slug>/` |
| `layouts/events/single.eventcalendar.ics` | Per-event `.ics` |
| `layouts/events/term.html` | `/events/sections/cubs/` |
| `layouts/partials/sections/events-upcoming.html` | Home-page block |
| `layouts/partials/event-card.html` | |
| `layouts/partials/event-meta.html` | Date/time/location strip |
| `layouts/partials/event-times.html` | Renders single or dual time pair |

The past archive uses Hugo's natural sub-section pattern: `content/
events/past/_index.md` is its own section, falls back to the parent
`layouts/events/list.html` template, and that template branches on
`.Params.archive = true` to filter to past events instead of upcoming.

## hugo.toml additions

```toml
[params.features]
  events = false                           # default OFF — opt-in

[params.events]
  timezone           = "Europe/London"     # site-level default
  show_past_archive  = false
  upcoming_window_days = 365
  default_count_on_home = 4
```

## Asset paths

- `assets/events/<slug>/cover.jpg` for cover images.
- `static/events/<slug>/poster.pdf` for downloadable PDF posters.
- Theme ships a generic placeholder at
  `assets/events/_placeholder/cover.jpg`.

## CSS-only baseline

- Date pill: stacked vertically — large day number, abbreviated
  month (e.g. "Jul"), year. Year always shown. CSS Grid for the
  internal stack; outer container is `event-meta` (date pill on left,
  details on right).
- **Cancelled pill**: solid `var(--warning)` (`#d4351c`) background with
  `var(--text-on-warning)` text. Sits ahead of section badges in the same
  `.badges` row on the event card.
- **Postponed pill**: solid `var(--postponed)` (`#d97706`) background with
  `var(--text-on-postponed)` text. Same position as the Cancelled pill;
  mutually exclusive (an event is either active, cancelled, or postponed).
- Past events visible only when `params.events.show_past_archive` is
  true; the listing template filters by `now`.
- Two-time rendering for BSO: a `<dl>` pair, both visible in mobile
  layout, side-by-side in wide.

## BSO notes

`times_local` / `times_uk` is a BSO pattern observed verbatim on
`britishscoutingoverseas.org.uk`. Both fields optional; the partial
renders dual times only if both present. No `params.bso` gating —
any Group (e.g. UK Group hosting an international event) might use it.

## Safeguarding & GDPR

- `rsvp_to` field validation: archetype comment recommends generic
  Group email (e.g. `gsl@1stanytown.org.uk`), never personal. Build
  does not enforce.
- `address` field for events at private homes (rare): archetype warns
  against publishing private addresses.
- No personal data collection on the site.

## Auto-hide past events

Past events disappear from `/events/` when the site rebuilds. Without
a JS extension (excluded by no-JS rule), the recommended pattern is
a GitHub Actions cron that triggers a weekly rebuild. Documented in
the feature README.

## Decided

| Q | Decision |
| --- | --- |
> | Q2.1 | **Status enum** replaces the cancelled boolean. Three states (`active`, `cancelled`, `postponed`), each with distinct site rendering and .ics behaviour. Cancelled events are OMITTED from .ics feeds entirely (cleanest UX — calendar subscribers see the meeting disappear). Postponed events are emitted with the new date, a prefixed DESCRIPTION and bumped SEQUENCE so subscriber apps update in place. New `--warning` (`#d4351c`) and `--postponed` (`#d97706`) palette tokens added across all five presets; both are app-functionality colours, not brand palette entries (see DECISIONS.md). |
| Q2.2 | **Single template** (`layouts/events/list.html`) branching on `.Params.archive` set by `content/events/past/_index.md`. Hugo natural sub-section pattern. |
| Q2.3 | **Single VEVENT** for multi-day events with `DTSTART`/`DTEND` spanning the period. |
| Q2.4 | **Yes** — aggregate `/events/all.ics` feed via custom output format on the events list page. Material UX win for parents. |
| Q2.5 | **Demo-roller** — example event dates are kept fresh in the theme repo only via `scripts/roll-example-dates.py` and a `[demo]` block in each example event's front-matter. Cross-cutting form documented in DECISIONS.md. Group sites consuming the theme have no `[demo]` blocks and the script ignores their events. |

## Out of scope (cross-references)

- Online booking / payment → no; `rsvp_to` is `mailto:` only.
- Recurring events / weekly meetings → that's SPEC-03 (Programme).
- Live map embed → no; static `map_url` link only.
- Calendar widget on home page → no; the upcoming-events block is a
  list of cards.
- Comments / RSVPs visible to other parents → no.

## Implementation order

1. Define the three custom output formats in `hugo.toml`; confirm
   Hugo emits `event.ics` next to `index.html` and `/events/all.ics`
   for stub events.
2. Write `layouts/events/single.eventcalendar.ics` with hardcoded
   fields; verify it imports cleanly into Apple Calendar and Google
   Calendar.
3. Add `archetypes/events.md`, write a stub event, build, validate
   `.ics` again.
4. Build `layouts/events/list.html` with future-only filter,
   hardcoded styling.
5. Add `layouts/partials/sections/events-upcoming.html` and wire into
   `layouts/index.html`.
6. Replace stub event with three example events covering all field
   combinations.
7. Implement Cancelled handling using `--warning` token.
8. Implement dual-time rendering for BSO.
9. Past archive route via sub-section `content/events/past/_index.md`.
10. Aggregate `.ics` template (`list.eventsaggregatecalendar.ics`).
11. Multi-day VEVENT example.
12. CSS, i18n strings, README section (including the cron pattern
    for auto-hiding past events), screenshot.
