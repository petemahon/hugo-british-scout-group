# DECISIONS.md

Locked-in choices for the Hugo British Scouting Overseas Theme project.
Read before suggesting changes that touch any of these. Flag, don't
silently revise.

## Identity & licence

- Theme code stays general-purpose under the name `british-scout-group`,
  even though this project's focus is BSO. The theme is for any UK Scout
  Group; BSO is a first-class feature, not the only use case.
- Licence is CC BY-SA 4.0 © Peter Mahon. Keep `LICENSE` intact in any
  refactor.
- The only Group-specific string anywhere in the theme is Peter's name
  in `LICENSE`. Everything else lives in the consuming site's `hugo.toml`.

## Architecture

- Hugo extended, minimum version 0.156. The Pages workflow pins `0.157.0`.
- `<html lang="en-GB">` is hardcoded in `baseof.html`. No locale parameter.
- No JavaScript dependency anywhere. Sticky nav, smooth scroll, fade-in
  animations are pure CSS. Adding JS is a flag-not-change item.
- Front-matter-driven sections: `[[sections]]` array in `content/_index.md`,
  each entry's `type` maps to a partial in `layouts/partials/sections/`.
- Theme distributed as Git submodule at `themes/british-scout-group`,
  not as a Hugo Module.

## Section types (canonical list)

`hero`, `two-col-cta`, `two-col-image-cta`, `section-grid`,
`stacked-features`, `scout-sections`, `section-header`, `embed`,
`bso-membership`, `palette-showcase`, `prose`.

Adding a new type is fine. Renaming or removing one is a flag-not-change.

## Brand & visual

- Five palette presets: `classic-purple`, `adventure`, `coastal`,
  `vibrant`, `network`. Names locked in.
- All hex values come from the Scouts Brand Guidelines 2023. Editing
  these to realign with future Scouts brand updates is the expected
  maintenance path; adding a sixth named palette is a flag-not-change.
- Theme ships zero copyrighted brand imagery. Generic placeholder WebPs
  ship at `assets/images/sections/{squirrels,beavers,cubs,scouts,explorers,network}.webp`
  and `assets/images/volunteer/role-model.webp`. Groups override at the
  same path with their own files — Hugo's resource resolution prefers
  the site over the theme.

## Scout sections (the age groups)

- Section metadata (age ranges, `scouts.org.uk` URLs) is fixed in the
  theme at `data/scout_sections.toml`. Groups never duplicate this.
- Groups toggle which sections they run via `params.scoutSections` in
  `hugo.toml` and supply their own logos.
- The responsive grid is sized for the canonical five sections.

## BSO

- The BSO membership notice is a dedicated partial.
- Wording aligns with The Scout Association's POR 3.2.1.1. The current
  copy is canonical — don't reword without flagging.
- Configured via `[params.bsoMembershipNotice]` (host country + host
  association). Text overridable via standard Hugo i18n in `i18n/en.toml`.
- BSO features are an optional add-on. The theme does not assume a
  Group is BSO.

## Palette reference page

The `/palettes/` page (`palette-showcase` section type) lives only in
the theme's `exampleSite`. Consuming sites do not include it.

## Deployment

- GitHub Pages via Actions, workflow at `.github/workflows/hugo.yml`.
- Pinned: `actions/checkout@v5`, `actions/deploy-pages@v5`.
- Kept at older Node-20 versions: `actions/configure-pages@v5`,
  `actions/upload-pages-artifact@v3` — no Node-24 release upstream yet
  (tracking actions/upload-pages-artifact#138).

## Navigation (cross-cutting — SPEC-11)

- Navigation is **auto-built** from `params.features.*` flags. The
  Group does not configure `[[menu.main]]`; the theme owns the
  structure.
- **Five top-level groups, hardcoded order**: Join Us · Our Sections
  · What we do · Get Involved · About. A Group can hide an entry
  via `params.nav.show_<name> = false` but cannot reorder.
- **Smart collapse**: a group with a single enabled child renders
  as a direct top-level link to that child. The group's i18n label
  isn't used in this case.
- **Empty groups disappear entirely** — no shell, no placeholder.
- Pure CSS. `:hover` (pointer devices) and `:focus-within`
  (keyboard) for desktop dropdowns; checkbox-hack hamburger for
  mobile (<48em).
- **Three always-on anchors** that the nav can fall back to even
  with no features enabled: `#joining`, `#our-sections`,
  `#where-we-meet`. These IDs are part of the theme's stable
  contract; renaming them is a flag-not-change event.

## Accessibility (cross-cutting — SPEC-12)

- WCAG 2.2 AA is the floor. AAA is aspirational.
- **No JS for accessibility.** Keyboard support comes from
  `:focus-within`, semantic HTML, and the dropdown patterns in
  SPEC-11.
- **Skip link** is the first focusable element on every page.
  Visible on focus.
- **Focus ring** is a new palette-level token: `--focus-ring`,
  added to every preset in `data/palettes.toml`. Falls back to
  `--primary` if a palette omits it.
- **Reduced-motion** honoured globally; the `reveal` fade-in
  disables under `prefers-reduced-motion: reduce`.
- **Image-alt lints** are uniform across content types via a
  shared `partials/audit-image.html`. SPEC-01's news lint is the
  reference implementation.
- **Heading order**: every page has exactly one `<h1>`, sourced
  from `.Title` in `_default/baseof.html`. Section partials use
  `<h2>` and below. Build-time audit if practicable; manual review
  otherwise.
- **Colour contrast audit** runs in GitHub Actions via a node
  script reading `data/palettes.toml`. Fails the workflow if any
  used (foreground, background) pair falls below AA.
- **axe-core CI** runs on PRs against the rendered example site.
  Fails the PR but doesn't block deploy.

## Working method

- Confirm design decisions before implementing. Don't assume.
- Validate builds incrementally — don't write a sprawl of templates
  then try to build at the end.
- Read access only on GitHub repos. Never attempt writes.
- The old Mobirise site (`petemahon/adscouts`) is kept for history.
  Don't fork, maintain, or reference it as a source — `petemahon/hugo-adscouts`
  is the live one.
