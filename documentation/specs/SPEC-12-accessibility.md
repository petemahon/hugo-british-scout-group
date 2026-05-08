# SPEC-12: Accessibility

Read `SPEC-COMMON.md` first, then `SPEC-11-nav.md` (this spec depends on
the nav structure).

## Goal

Bring the theme to **WCAG 2.2 AA** as a baseline, with specific
attention to keyboard navigation, screen reader landmarks, focus
visibility, and the parts of the no-JS dropdown nav that need
non-obvious markup to behave well.

This is the cross-cutting feature that hardens every page rendered by
the theme. Like SPEC-11, it has no `params.features.<name>` flag — it
is always on. There is no opt-in or opt-out.

UK Scouts websites are public-facing community sites and reach a
volunteer audience that includes a higher-than-average proportion of
older adults; accessibility is not optional and is treated as a
correctness requirement.

## Acceptance criteria

1. Every page renders an unstyled "Skip to main content" link as the
   first focusable element. Hidden visually until focused, then
   visible.
2. Every page emits the standard ARIA landmarks: `<header>`, `<nav>`,
   `<main>`, `<footer>`. The nav is labelled via `aria-label`.
3. **Focus visibility** is consistent across the theme. A 2px
   `--focus-ring` outline (a new palette token) is applied to every
   focusable element via `:focus-visible`. No `outline: none` is
   permitted anywhere.
4. The pure-CSS dropdown nav is keyboard navigable: Tab moves
   through, submenu opens on `:focus-within`, items inside are Tab-
   reachable. `aria-haspopup="true"` on group toggles. (We do not
   claim Esc-to-close, which would require JS.)
5. Image-bearing content types (news, gallery, events with photos,
   history) **must** declare a non-empty `alt` for every image. The
   build fails (errorf) if `cover_alt` is empty when `cover_image` is
   set, mirroring SPEC-01's existing lint pattern, applied uniformly
   across feature specs.
6. Heading order is enforced: every page has exactly one `<h1>`. The
   `_default/baseof.html` reserves the `<h1>` for the page title; no
   section partial may emit `<h1>`. The build fails (errorf) if a
   section partial produces an `<h1>`.
7. Colour contrast: all text in the five palettes meets WCAG AA at
   the relevant size (≥18pt or ≥14pt bold counts as "large"; rest as
   "normal"). The palette CSS already encodes `--text-on-primary`
   etc. for this; SPEC-12 adds the audit and the CI check.
8. The example site builds clean and passes an automated WCAG check
   via `axe-core` CLI run from the GitHub Actions workflow.

## Scope: what's in, what's out

**In scope:**

- Skip link.
- Landmark structure.
- Focus ring tokens and consistent `:focus-visible` styling.
- Dropdown nav keyboard support (markup, not interactivity beyond
  what `:focus-within` gives).
- `prefers-reduced-motion` honoured by every existing animation
  (`reveal`, hover transitions). Existing animations already use
  CSS transitions, but a top-level rule disables them under reduced
  motion.
- Heading-order audit at build.
- Image-alt audit at build (per content type, lint already exists in
  SPEC-01; SPEC-12 generalises the pattern).
- Colour contrast audit at build.
- An `axe-core` GitHub Action against the rendered example site.

**Out of scope:**

- Screen-reader-only "Skip to nav" / "Skip to footer" — only the
  one main-content skip link.
- ARIA live regions (no JS, no dynamic updates).
- Reading order beyond what semantic HTML provides.
- Mouseless drag-and-drop (no DnD anywhere in the theme).
- Captions or transcripts for video — galleries link out only
  (SPEC-04), no embeds, so no captioning concern in the theme.
- Sign-language alternatives for video — same reason.

## hugo.toml additions

No new feature flag. The accessibility behaviour is unconditional.

## Layouts to create / modify

| File | Change |
| --- | --- |
| `layouts/_default/baseof.html` | Add `<a class="skip-link" href="#main">Skip to main content</a>` as the first child of `<body>`. Add `<main id="main">` wrapper around the existing main slot. Add `<nav aria-label="Main">` wrapper inside `partials/header-nav.html` (SPEC-11 already does this, this spec just confirms the contract). |
| `layouts/_default/baseof.html` | Heading-order audit: a single `<h1>` per page, sourced from `.Title`. Section partials use `<h2>` (already do). |
| `layouts/partials/audit-headings.html` | Build-time audit; calls `errorf` if it detects an `<h1>` produced inside a section partial. (Pattern: scan `.Content` for `<h1>` regex; for partial-produced markup, this requires each section partial to surface its own headings via a contract — see implementation order.) |
| `assets/css/theme.css` | New `/* ----- a11y ----- */` banner: skip link, focus ring, reduced motion, screen-reader-only utility class. |

## CSS additions

Three additions to `assets/css/theme.css`. All use existing palette
tokens or new ones added to every preset in `data/palettes.toml`.

```css
/* ----- a11y ----- */

/* New palette token: --focus-ring (per palette in data/palettes.toml).
   Falls back to --primary if a palette omits it. */
:focus-visible {
  outline: 2px solid var(--focus-ring, var(--primary));
  outline-offset: 2px;
}

.skip-link {
  position: absolute;
  top: -100px;
  left: 1rem;
  background: var(--bg);
  color: var(--text);
  padding: 0.75rem 1.25rem;
  text-decoration: none;
  border: 2px solid var(--focus-ring, var(--primary));
  border-radius: 0.25rem;
  font-weight: 700;
  z-index: 1000;
}
.skip-link:focus-visible {
  top: 1rem;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0,0,0,0);
  white-space: nowrap;
  border: 0;
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
  .reveal { opacity: 1 !important; transform: none !important; }
}
```

## Palette token addition

Adding `--focus-ring` to every preset in `data/palettes.toml`. By
default it equals `--primary`; palettes whose primary has insufficient
contrast against the page backgrounds (e.g. `vibrant` if hot colours
get used) override.

| Palette | Default focus ring source |
| --- | --- |
| `classic-purple` | `--primary` (Scouts Purple) |
| `adventure` | `--primary` |
| `coastal` | `--primary` |
| `vibrant` | TBD — palette-specific override likely needed |
| `network` | `--primary` |

Resolves to a 4.5:1 contrast against `--bg` in every palette. The
audit (below) verifies.

## Build-time audits

Three audits must run on every build and fail with `errorf` if
violated.

### A. Heading order

Each section partial now declares its highest heading level via a
`partials/audit-claim.html` call:

```go-html-template
{{ partial "audit-claim.html" (dict "kind" "heading" "level" 2) }}
```

The audit partial maintains a running list scoped to the page. After
the page renders, `audit-headings.html` checks: exactly one `<h1>`
(from baseof's `.Title`), and no section claims a level less than 2.

This is build-time, not runtime — Hugo's render pipeline doesn't
allow proper post-processing, so the implementation reads the
rendered HTML via `.RawContent` for body content and a partial-side
contract for partials. **Implementation note:** a perfect heading
audit may need a custom Hugo Module that post-processes the HTML.
SPEC-12 may downgrade to a *recommendation* + manual review if the
build-time check proves brittle.

### B. Image alt text

Generalised from SPEC-01's pattern. The `cover_alt`-required check
(when `cover_image` is set) is enforced uniformly across:

- News (already in SPEC-01)
- Galleries (SPEC-04)
- Events (SPEC-02 — when `poster_image` is set)
- History (SPEC-07)
- Hall hire (SPEC-08)

Implementation: a shared `partials/audit-image.html` partial that
each feature spec calls. Single source of truth for the lint message.

### C. Colour contrast

A node script in `tools/audit-contrast.mjs` (called from the GitHub
Actions workflow, not from `hugo`) reads `data/palettes.toml`,
computes WCAG contrast ratios for every (foreground, background)
pair the theme actually uses, and fails the workflow if any
combination falls below AA at the appropriate text size.

The pairs checked are the ones explicitly declared in the palette:
`(--text, --bg)`, `(--text-muted, --bg)`, `(--text-on-primary,
--primary)`, etc. Not a brute-force matrix.

## i18n keys

```
a11ySkipToContent      = "Skip to main content"
a11yMainNavLabel       = "Main"
a11yFooterNavLabel     = "Footer"   # if SPEC-13 footer nav lands
a11yMobileMenuOpen     = "Open menu"
a11yMobileMenuClose    = "Close menu"
```

## GitHub Actions: axe-core CI

Add a step to the existing `.github/workflows/hugo.yml` workflow,
running after the build but before deploy. Uses `@axe-core/cli`
against the rendered example site served via `npx serve`.

```yaml
- name: WCAG audit (axe-core)
  if: github.event_name == 'pull_request'
  run: |
    npx --yes @axe-core/cli --tags wcag2aa --tags wcag22aa \
      http://localhost:8080/ \
      http://localhost:8080/news/ \
      http://localhost:8080/news/2026-04-19-st-georges-day/ \
      http://localhost:8080/joining/ \
      http://localhost:8080/bso/
```

The check runs on PR only, not on the deployment to Pages. A failed
audit fails the PR but doesn't block a manual override merge.

## Decided

| Q | Decision |
| --- | --- |
| Q12.1 | WCAG 2.2 AA is the floor; AAA is aspirational. Sites publishing this theme should not need to do additional a11y work to be accessibility-compliant. |
| Q12.2 | No JS for accessibility — keyboard support comes from `:focus-within`, semantic markup, and the pure-CSS dropdown patterns specified in SPEC-11. |
| Q12.3 | Focus ring is a palette-level token. Each palette in `data/palettes.toml` declares its own; falls back to `--primary` if omitted. |
| Q12.4 | Heading-order audit is build-time when feasible, downgrades to documented manual-review if the build-time check is brittle. |
| Q12.5 | Image-alt lints are uniform across content types via `partials/audit-image.html`. SPEC-01's existing inline lint becomes the reference implementation; SPEC-04, -02, -07, -08 inherit it. |
| Q12.6 | `prefers-reduced-motion` honoured globally. The `reveal` fade-in disables under reduced motion. |
| Q12.7 | Colour contrast audit is a separate node script in CI, not Hugo build. Hugo can't reliably evaluate contrast ratios. |
| Q12.8 | axe-core CI on PRs only. |

## Out of scope (cross-references)

- Internationalisation beyond en-GB → DECISIONS.md locks en-GB.
- Reading-level analysis of body copy → editorial concern, not theme.
- Cookie banner / consent → no cookies, no banner. SPEC-COMMON §15
  excludes analytics that would need them.
- Prefer-dark-mode / theme switching → the five palettes are
  pre-baked, no runtime switching.
- ARIA tabs / accordion patterns → none exist in the theme; if any
  feature spec proposes one, that spec must include the a11y
  requirements per SPEC-12.

## Implementation order

1. Add `--focus-ring` to every preset in `data/palettes.toml`.
2. Add the a11y CSS block (skip link, focus ring, sr-only, reduced
   motion).
3. Modify `_default/baseof.html` to emit the skip link, the `<main
   id="main">` wrapper, and the landmarks.
4. Verify with keyboard-only navigation: Tab from page load reaches
   skip link first; Enter activates skip; focus moves to main.
5. Add `partials/audit-image.html`; refactor SPEC-01's news single
   to use it (regression test the existing news lint still fires).
6. Document the heading-order contract in `SPEC-COMMON.md`. Defer
   the build-time audit if it proves brittle; ship the manual
   review version first.
7. Write `tools/audit-contrast.mjs` and the workflow step.
8. Add the axe-core PR step.
9. Test on the example site with `--logLevel info` for clean build.
10. Tag for release.

## Reviewer's checklist

When reviewing a feature spec PR (any of SPEC-01 through SPEC-11),
confirm:

- [ ] All images go through the alt audit.
- [ ] All headings start at `<h2>` inside section partials.
- [ ] Focus is visible on every interactive element (button, link,
      `<details>` summary, etc.).
- [ ] Colour combinations declared in CSS use palette tokens, not
      hex literals.
- [ ] Animations respect `prefers-reduced-motion`.
- [ ] Keyboard navigation reaches every interactive element in a
      sensible order.

The reviewer's checklist is reproduced in the theme's CONTRIBUTING.md
once that file lands.
