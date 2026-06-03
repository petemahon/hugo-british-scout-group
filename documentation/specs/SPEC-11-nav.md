# SPEC-11: Navigation

Read `SPEC-COMMON.md` first.

## Goal

A hierarchical site navigation generated automatically from the
`params.features.*` flags. The Group does not curate the nav by hand;
turning a feature on adds its entry, turning it off removes it. The
theme owns the structure and the order; the Group customises labels via
i18n. Pure CSS, no JavaScript.

This is the cross-cutting feature that closes the loop on every
per-feature spec's "add a nav entry" instruction. After SPEC-11, those
instructions go away — the per-feature spec turns the feature on, and
the nav appears.

## Acceptance criteria

1. With every feature flag off (greenfield site, no opt-ins), the nav
   renders **Join Us · Our Sections · Where we meet**, where Join Us
   and Where we meet are home-page anchor links and Our Sections is
   a submenu listing the enabled Scout sections.
2. With one or more `What we do` / `Get Involved` / `About` features
   on, the corresponding top-level group appears, populated with only
   the enabled child links. Disabled-feature children are absent.
3. **Smart collapse.** A top-level group with exactly one enabled
   child renders as a direct top-level link to that child, not as a
   dropdown shell. The group's i18n label is not used in this case;
   the child's label is.
4. **Empty groups disappear entirely.** No empty dropdown shell, no
   placeholder, no console-warning fallback.
5. The active page is marked with `aria-current="page"`. Any ancestor
   page (e.g. `/news/2026-04-19-st-georges-day/` is descended from
   `/news/`) marks its top-level entry with `aria-current="true"`.
6. Hierarchical sub-menus open on `:hover` (pointer devices) and
   `:focus-within` (keyboard). On viewports below 48em they collapse
   into a single mobile sheet behind a pure-CSS checkbox-hack toggle.
7. The build emits a single `<nav>` element rendered by
   `partials/header-nav.html`. No JavaScript files are loaded.
8. The example site exercises the maximum-size nav (every feature on,
   `[params.bso].enabled = true`).

## Hierarchy (locked)

The five top-level groups, in render order, with their children. Order
is hardcoded in the partial; Groups can hide via params (`enable = false`)
but cannot reorder.

| Top-level | Default URL | Children |
| --- | --- | --- |
| Join Us | `/join/` (SPEC-06) → falls back to `#join` anchor on home if SPEC-06 off | When `[params.bso].enabled = true` AND `features.bso_hub = true`: "How to join" → `/join/`; "BSO eligibility" → `/bso/`. Otherwise: no submenu — direct link. |
| Our Sections | `#sections` home anchor (always on) | Squirrels … Network. Submenu always renders, listing only Scout sections enabled in `params.scoutSections`. Each anchor: `#squirrels`, `#beavers`, `#cubs`, `#scouts`, `#explorers`, `#network` — emitted as `id` on the home scout-section cards. |
| What we do | First enabled child's URL | Latest news (`/news/` — SPEC-01); Events (`/events/` — SPEC-02); Programme (`/programme/` — SPEC-03); Galleries (`/galleries/` — SPEC-04). |
| Get Involved | First enabled child's URL | Volunteer roles (`/support-us/volunteer-roles/` — SPEC-09); Support us / fundraising (`/support-us/` — SPEC-09); Hire the hall (`/hall-hire/` — SPEC-08). When SPEC-09 reports ≥1 open role AND `params.volunteer_roles.nav_link = true`, the Volunteer-roles entry carries the "We're recruiting" indicator (see below). |
| About | First enabled child's URL | Our history (`/about/history/` — SPEC-07); Governance (`/about/governance/` — SPEC-07); Kit lists (`/kit-lists/` — SPEC-05); Where we meet (`#where-we-meet` home anchor — always on). |

The minimum nav (no features) reads: **Join Us · Our Sections · Where we meet**.
The "Where we meet" entry promotes to top-level when About has only that
one enabled child (smart collapse).

## Always-on anchors

Three nav entries point at home-page anchors that are not gated by any
feature flag:

- `#join` — when SPEC-06 is off, Join Us nav falls back to this anchor.
- `#sections` — Scout-sections home block, always on.
- `#where-we-meet` — the embedded map block, always on.

(Reconciled 2026-06-03 to the shipped home-section IDs — `#join`,
`#sections`, `#where-we-meet` — rather than the originally-drafted
`#joining`/`#our-sections`, which never matched the content.)

These anchor IDs are part of the theme's stable contract. The home-page
section partials (existing `scout-sections`, future home-anchored
joining and where-we-meet blocks) emit them as `id` attributes. Renaming
or removing one of these IDs is a flag-not-change event.

## hugo.toml additions

No new feature flag — SPEC-11 is the cross-cutting nav feature and is
always on. The nav structure is derived from existing flags.

```toml
# Per-Group fine-grained hide of an auto-entry without disabling the
# feature itself. Useful when a Group runs the feature internally but
# doesn't want it in the public nav (e.g. a beta period). Optional;
# default is auto-include.
[params.nav]
  show_join_us       = true
  show_our_sections  = true
  show_what_we_do    = true
  show_get_involved  = true
  show_about         = true
  show_where_we_meet = true
```

`show_*` defaults to `true` for every entry. Setting one to `false`
hides that entry from the auto-nav even if the corresponding feature is
on.

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/partials/header-nav.html` | The whole `<nav>`. Reads `site.Params.features.*` and `site.Params.nav.*`, builds the tree, renders it. |
| `layouts/partials/header-nav-item.html` | One leaf or one group. Recursively rendered. |
| `layouts/partials/header-nav-toggle.html` | Pure-CSS hamburger checkbox (mobile). |

`baseof.html` already calls `partials/header.html`. SPEC-11 modifies
`header.html` to call `header-nav.html`.

## i18n keys

Group labels and the toggle button label. Default English shipped;
Groups override in their site `i18n/en.toml`.

```
navJoinUs              = "Join Us"
navOurSections         = "Our Sections"
navWhatWeDo            = "What we do"
navGetInvolved         = "Get Involved"
navAbout               = "About"
navJoinUsHowToJoin     = "How to join"
navJoinUsBSO           = "BSO eligibility"
navWhatWeDoNews        = "Latest news"
navWhatWeDoEvents      = "Events"
navWhatWeDoProgramme   = "Programme"
navWhatWeDoGalleries   = "Galleries"
navGetInvolvedVolunteer = "Volunteer"
navGetInvolvedFundraising = "Fundraising"
navGetInvolvedHall     = "Hire the hall"
navAboutHistory        = "Our history"
navAboutKit            = "Kit lists"
navAboutWhereWeMeet    = "Where we meet"
navWhereWeMeet         = "Where we meet"
navMobileToggle        = "Menu"
navMobileToggleAria    = "Open the main navigation"
navRecruitingFlag      = "(NEW)"
```

**SPEC-11 owns the conditional "We're recruiting" nav indicator** —
SPEC-09's AC4 was deliberately deferred here, since the nav is rebuilt
by this spec. The Volunteer-roles entry carries the indicator — gated
by `params.volunteer_roles.nav_link` (default true) — only when at
least one volunteer role is currently open. The open-role count comes
from the shipped `partials/volunteer-roles-open.html` (the single
source of truth already used by the homepage recruitment banner); the
nav partial MUST call that same partial so the banner and the nav
indicator can never disagree. `navRecruitingFlag` supplies the
indicator text.

## CSS-only baseline

A few specific behaviours that the CSS must encode (all without JS):

- **Hover (pointer devices).** Submenus open on `:hover` of the
  group's `<li>`. Guarded by `@media (hover: hover) and (pointer: fine)`
  so touch devices don't pick up the hover state and flicker.
- **Keyboard.** Submenus open on `:focus-within`. Tab moves through
  the top-level items; Tab on an open group's `<a>` enters the
  submenu. Esc support requires JS so we don't claim it.
- **Mobile.** Below 48em, the nav collapses behind a checkbox-hack
  hamburger. The submenu items render flat (indented, not floated)
  so the user sees the whole tree at once.
- **Active state.** `aria-current="page"` on the exact active link;
  `aria-current="true"` on the ancestor top-level entry. Both styled
  via the `[aria-current]` attribute selector.
- **Touch laptops.** `@media (hover: hover)` ensures hover doesn't
  trigger on laptops with touchscreens that report both. Touch
  always uses tap, which on a non-mobile viewport opens the submenu
  via `:focus-within` once the link receives focus.
- **No layout shift.** The dropdown panel is positioned with
  `position: absolute` from the top-level item; the top-bar height
  doesn't change when a panel opens.

CSS lives under a new `/* ----- s-nav ----- */` banner.

## BSO notes

The Join Us group's behaviour changes only when
`[params.bso].enabled = true` AND `params.features.bso_hub = true`:

- Without BSO: Join Us is a direct top-level link to `/joining/` (or
  `#joining` anchor if SPEC-06 off).
- With BSO Hub on: Join Us becomes a 2-item dropdown — "How to join"
  and "BSO eligibility" — to surface the BSO route alongside the
  general join route.

Outside the Join Us group, `params.bso` does not affect the nav
shape.

## Safeguarding & GDPR

No user data, no forms, no comments. Nothing GDPR-relevant.

## Decided

| Q | Decision |
| --- | --- |
| Q11.1 | Auto-build mechanism — theme partial reads `params.features.*`, no Hugo menu config required. |
| Q11.2 | Theme nav fully replaces; no `[[menu.main]]` merge. Customisation only via `params.nav.*` and i18n. |
| Q11.3 | Order hardcoded; groups can be hidden but not reordered. |
| Q11.4 | Labels via i18n; no front-matter override. |
| Q11.5 | Smart collapse: single-child group → direct top-level link. |
| Q11.6 | Empty groups disappear entirely. |
| Q11.7 | Join Us, Our Sections, and Where we meet are always present (anchor fallbacks). |

## Out of scope (cross-references)

- Footer nav → not built; if needed, treat as a SPEC-13 candidate.
- Search box in the nav → no, search is its own deferred feature.
- Mega-menu (multi-column dropdowns with thumbnails) → no, plain
  one-column dropdowns only.
- Per-page custom nav → no, the same nav renders everywhere.
- Sub-nav within a feature page (e.g. tabs across the BSO Hub
  pages) → SPEC-10's concern, not SPEC-11's.
- Skip-to-content link, focus visibility, screen-reader landmarks
  → SPEC-12 (accessibility), which depends on this spec.

## Implementation order

1. Read existing `header.html` and `baseof.html` to understand current
   logo + nav layout. Sketch the desired DOM structure on paper before
   any template work.
2. Create `partials/header-nav.html` rendering only the always-on
   entries (Join Us anchor, Our Sections, Where we meet anchor) with
   no submenu. Build; check the home page.
3. Add the Our Sections submenu, populated from `data/scout_sections.toml`
   gated by `params.scoutSections.<key>.enable`. Build.
4. Add the smart-collapse helper logic in a single `partials/header-nav-collapse.html`
   that returns either a single-child URL or empty. Used by every
   group.
5. Add What we do; build with various combinations of news/events/etc.
   on and off; verify smart collapse and disappearance.
6. Add Get Involved and About in turn; same testing pattern.
7. Add the BSO branch to Join Us; verify with
   `[params.bso].enabled = true` and `features.bso_hub = true`.
8. Add `params.nav.show_*` overrides; verify hiding behaviour.
9. CSS — start with the desktop layout (pre-48em is mobile, breakpoint
   shared with existing theme).
10. Add the mobile checkbox-hack toggle; verify on a narrow viewport.
11. Active-state styling via `[aria-current]` selectors.
12. i18n strings; build clean.
13. exampleSite — set every feature flag to true,
    `[params.bso].enabled = true`, `features.bso_hub = true`. Confirm
    the maximum nav renders.
14. README section, screenshots desktop + mobile + collapsed group.
15. Update DECISIONS.md with the locked hierarchy.

## Future-proofing

Adding an eleventh top-level entry (or a new child to an existing
group) is a flag-not-change event — it changes the nav contract.
Specifically, the items inside `What we do`, `Get Involved`, and
`About` are not extensible by a Group's own content; the theme owns
that list. New content types must either fit into one of the existing
groups or trigger a SPEC change.
