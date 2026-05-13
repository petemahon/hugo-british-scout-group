# SPEC-COMMON.md

Shared conventions for every feature in the Hugo British Scouting Overseas
Theme roadmap. Every per-feature spec assumes these. Read this once at the
start of a session, then read the feature spec.

If a feature spec contradicts this file, the contradiction is a mistake —
flag it.

## 1. Architectural rules (locked, do not relitigate)

- Hugo extended, min 0.156. en-GB only. `<html lang="en-GB">` hardcoded.
- **No JavaScript dependency anywhere.** Pure CSS for all interactivity.
  A native-share feature was proposed and explicitly declined for this
  reason — see DECISIONS.md.
- No backend services. No third-party scripts (analytics, social embeds,
  comment systems, payment widgets, livechat, font CDNs that track).
- The theme repo ships the **official Scout section logo SVGs** at
  `assets/images/sections/<key>.svg` — these are maintained centrally
  by the theme and Groups DO NOT override them. **Other visual assets**
  shipped at theme paths remain generic placeholders; Groups override
  them at the same path in their site repo.
- Group-specific values live only in the consuming site's `hugo.toml` and
  `content/`. Nothing in the theme code may reference Abu Dhabi, the BSO
  Group's name, or any Group's specifics. Peter's name in `LICENSE` is
  the single permitted exception.

## 2. All features are opt-in (cross-cutting policy)

Every feature in this roadmap defaults OFF and is opted into by the
Group via `params.features.<name> = true` in `hugo.toml`.

- The current home-page experience is what ships by default for a
  fresh site.
- Stale published content is worse than no published content. Opt-in
  means a Group only adds news, events, programmes, etc. when they
  have the editorial commitment to maintain them.
- The `exampleSite/hugo.toml` sets every feature flag to `true` so the
  demo site exercises everything.
- A feature flag set to `false` (or unset) gates: section partials on
  the home page, listing routes, taxonomy term pages, sitemap entries.

Idiom inside a partial:

```go-html-template
{{- if site.Params.features.news -}}
  ...render the news block...
{{- end -}}
```

Idiom for a listing route — preferred pattern is to ship the listing
inside the partial gate so the route 404s cleanly when the flag is off.

## 3. Section partial idiom

Every section type follows the same shape (mirroring existing partials
in `layouts/partials/sections/`):

```go-html-template
{{- /*
  <section-name> — one-line description.
  Params (front-matter under [[sections]]):
    id       (string, optional)
    title    (string, optional)
    bg       (string, optional) — "primary" | "secondary" | "tertiary"
                                  | "muted" | unset (white)
    title_color (string, optional) — same options as bg
    ... feature-specific params ...
*/ -}}
{{- $id := .id | default "" -}}
{{- $bg := .bg | default "" -}}
<section{{ with $id }} id="{{ . }}"{{ end }}
         class="section s-<section-name>{{ with $bg }} s-bg--{{ . }}{{ end }} reveal">
  <div class="container">
    ...
  </div>
</section>
```

Every section partial gets a corresponding CSS block in
`assets/css/theme.css` under a `/* ----- s-<section-name> ----- */`
banner.

## 4. Front-matter conventions

- Field names: `snake_case`. Hugo accepts both but the existing theme
  uses `snake_case` (e.g. `title_color`, `meeting_night`). Stay
  consistent.
- Dates: ISO-8601 (`2026-04-19` or `2026-04-19T19:30:00+04:00`).
- Booleans: bare `true`/`false`.
- Lists: TOML inline arrays for short lists, `[[blocks]]` for structured
  records.
- Free-text fields that can contain HTML: noted explicitly in the schema
  table as `(string, HTML allowed)`. Otherwise they are escaped.
- Required fields fail the build with a clear `errorf` message. Optional
  fields fall back to documented defaults.
- en-GB throughout visitor-facing text and documentation prose:
  `colour`, `programme`, `organisation`, `behaviour`, `licence`,
  `centre`, `enrolled`. Code identifiers (TOML field keys, CSS class
  names, template variables) follow source-code conventions and may
  use US spelling where idiomatic — see DECISIONS.md §"en-GB scope".
  The build does not lint this; reviewers do.

## 5. Image and asset paths

Two paths, two purposes:

- `assets/<feature>/...` — files that should pass through Hugo's image
  pipeline (resize, srcset, WebP). Used for editorial images: news
  covers, gallery photos, event posters, hall-hire shots, history
  images.
- `static/<feature>/...` — files served as-is. Used for downloadable
  documents (kit-list PDFs if Group provides, AGM reports, T&Cs PDFs)
  and binary assets that must keep their exact filename.

Override pattern: theme ships generic placeholders at the same paths.
Hugo's resource resolution prefers the consuming site over the theme.

Image pipeline defaults (used by every partial that renders an
editorial image):

```go-html-template
{{- $img := resources.Get .src -}}
{{- $small  := $img.Resize "640x webp q82" -}}
{{- $medium := $img.Resize "1280x webp q82" -}}
{{- $large  := $img.Resize "1920x webp q82" -}}
<img src="{{ $medium.RelPermalink }}"
     srcset="{{ $small.RelPermalink }} 640w,
             {{ $medium.RelPermalink }} 1280w,
             {{ $large.RelPermalink }} 1920w"
     sizes="(max-width: 700px) 100vw, 1280px"
     alt="{{ .alt }}"
     loading="lazy">
```

Failed `resources.Get` (file missing) must `errorf` with the path,
not silently render a broken image.

## 6. Palette tokens

CSS custom properties already emitted by `partials/palette-style.html`:

| Token | Use |
| --- | --- |
| `--primary`, `--primary-hover` | Section-grid bg, primary buttons |
| `--secondary`, `--secondary-hover` | Secondary buttons, accents |
| `--tertiary` | "Our Sections" bg |
| `--accent` | Network section bg, callouts |
| `--text`, `--text-muted` | Body and de-emphasised copy |
| `--text-on-primary`, `--text-on-secondary` | Text inside coloured blocks |
| `--bg`, `--bg-muted` | Page bg, alternating section bg |

**New tokens added by this roadmap** (defined per palette in
`data/palettes.toml`):

| Token | Use |
| --- | --- |
| `--warning` | Cancelled events (SPEC-02), cancelled programme rows (SPEC-03), expired vacancies (SPEC-09), hall fully-booked banner (SPEC-08) |
| `--status-open` | Open joining badge (SPEC-06) |
| `--status-waiting` | Waiting-list joining badge (SPEC-06) |
| `--status-closed` | Closed joining badge (SPEC-06) |

Never hardcode hex values in section CSS. Never invent new tokens
without flagging.

## 7. Section-badge colours

`data/scout_sections.toml` carries `color` and `text_color` fields per
section. `color` is the challenge-badge outer-ring colour (used as the
badge background); `text_color` is the foreground for legibility on
that background. Used by section badges across news cards, event
cards, gallery covers, and joining cards.

The field keys use US spelling because they are code identifiers; the
en-GB rule applies to visitor-facing text and documentation prose (see
DECISIONS.md §"en-GB scope"). The badge **values** below are the
visitor-facing brand colours.

| Section | Hex |
| --- | --- |
| Squirrels | `#25B755` |
| Beavers | `#003982` |
| Cubs | `#F7EF27` |
| Scouts | `#E22E12` |
| Explorers | `#088486` |
| Network | `#000000` |

## 8. Taxonomies

A single Hugo taxonomy is shared across content types:

```toml
# hugo.toml (theme default)
[taxonomies]
  section = "sections"
```

Values are the keys from `data/scout_sections.toml`: `squirrels`,
`beavers`, `cubs`, `scouts`, `explorers`, `network`.

Front-matter usage: `sections = ["cubs", "scouts"]`. Renders as filter
chips on listing pages and as colour-coded badges on cards (badge
colour comes from `data/scout_sections.toml`).

## 9. BSO conditional rendering

A site-wide flag already exists: `params.bso = true|false`.

- A feature that is general-purpose stays decoupled from this flag.
- A feature that has BSO-specific extras (e.g. extra front-matter
  fields, alternative copy) reads `site.Params.bso` and adapts. The
  BSO branch must never be the only branch — the non-BSO path is the
  default.
- The `bso_hub` feature (SPEC-10) is the *only* feature whose entire
  existence is gated by `site.Params.bso`.

## 10. Safeguarding lint pattern

For any content type that may carry images of identifiable young
people (news posts, galleries, event pages with photos, history page
with photos), the front-matter must declare:

```toml
photo_consent = true   # required: all faces have signed consent or are obscured
```

The implementing partial validates the field with `errorf` if missing
or unset on a post that resolves any image asset. This is a build-time
lint, not a runtime check.

For features that touch personal data (joining, hall hire, fundraising),
the spec requires a `mailto:` or external-system handoff — never a form
that POSTs anywhere from the static site.

## 11. DBS and safeguarding checks

DBS is the canonical UK Scouts safeguarding check, used globally
across UK Scout volunteers (including BSO). The DBS regime is run by
The Scout Association — Group websites describe but do not collect.

Default in volunteer-role schemas (SPEC-09): `dbs_required = true`.

DBS does not apply to volunteers who have **not resided in the UK at
any point since age 10**. Such volunteers require alternative checks
per The Scout Association's safeguarding regime. The volunteer-role
archetype's comment header documents this clearly so Group authors
don't accidentally publish "no DBS required" for roles that actually
need a host-country equivalent check.

No `safeguarding_check_note` field in v1 — the rule is uniform across
UK Scouts.

## 12. i18n and copy

User-facing strings live in `i18n/en.toml`. The theme ships defaults;
sites override by creating `i18n/en.toml` at the site root.

Naming convention: feature prefix + camelCase, e.g.:
- `newsHeading`, `newsReadMore`, `newsByLine`
- `eventsAddToCalendar`, `eventsLocation`, `eventsCancelled`
- `joiningStatusOpen`, `joiningStatusWaiting`, `joiningStatusClosed`

Strings that are likely to be Group-edited (e.g. the joining waitlist
prose) belong in front-matter, not i18n. Strings that are pure UI
chrome (button labels, ARIA descriptions, status badges) belong in
i18n.

Every BSO partial already follows this pattern — see
`bso-membership-notice.html` and existing `bsoNotice*` keys.

## 13. Build validation pattern

Implement incrementally. Per Peter's preference: do not write a sprawl
of templates and try to build at the end.

For each feature, the working order is:

1. Add `data/` files (if any) and verify with `hugo --renderToMemory`.
2. Add the section partial(s) with hardcoded content; build.
3. Wire the partial into the section dispatcher in `layouts/index.html`
   (or appropriate single/list template); build.
4. Add front-matter schema and replace hardcoded content; build.
5. Add CSS; visual check via `hugo server` and a screenshot.
6. Add i18n strings; build.
7. Add `exampleSite` content exercising every front-matter combination;
   build clean (no WARN, no errorf).
8. Update theme `README.md` with a section reference.
9. Update `DECISIONS.md` if any new architectural choice was made.

A feature is "done" only when (7) builds clean on Hugo 0.128 (the
documented minimum) AND on the current pinned version.

## 14. Files that change for every feature

A feature implementation will typically touch:

- `data/<feature>.toml` or `data/<feature>/` (optional, feature-specific)
- `archetypes/<feature>.md` (one per content type)
- `layouts/<feature>/list.html` (if it needs a listing route)
- `layouts/<feature>/single.html` (if individual pages are addressable)
- `layouts/partials/sections/<section-type>.html` (for home-page block)
- `layouts/partials/<feature>-card.html` (reusable per-item rendering)
- `assets/css/theme.css` (under a banner block)
- `i18n/en.toml`
- `exampleSite/content/<feature>/...` (demo content)
- `exampleSite/assets/<feature>/...` (placeholder images)
- `exampleSite/hugo.toml` (feature flag, any new params)
- `README.md` (a feature subsection)

The theme's `theme.toml` `min_version` should not change unless a
feature genuinely requires a newer Hugo. Flag any version bump
explicitly.

## 15. Out of scope across all features

These keep recurring as adjacent ideas; they are explicitly out of
scope for every spec in this roadmap unless the feature's spec opts
back in:

- Any form that POSTs from the static site
- Any embedded social widget (Facebook, Instagram, Twitter, TikTok)
- Any embedded analytics, A/B testing, heatmap, or session-replay tool
- Any payment processor (Stripe, PayPal, GoCardless, JustGiving)
- Any client-side search index (lunr.js, FlexSearch, Pagefind) — search
  is its own future feature, separately scoped
- Any chat or comment system
- Any login/auth gated area (OSM is the authority for member data)
- Any image editing (cropping, EXIF stripping) at runtime — these are
  Group-side responsibilities at upload time, optionally documented in
  the feature spec but never built
- Native share feature (Web Share API) — proposed and declined as
  it would introduce JS to the theme

## 16. License header (templates and CSS)

Every new layout file starts with:

```
{{- /*
  Hugo British Scout Group theme
  CC BY-SA 4.0 © Peter Mahon
  https://github.com/petemahon/hugo-british-scout-group
*/ -}}
```

CSS files use `/* ... */` form. The header is not optional.
