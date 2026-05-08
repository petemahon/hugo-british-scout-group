# SPEC-05: Camp Kit Lists

Read `SPEC-COMMON.md` first.

## Goal

Reusable, versioned kit lists that any event page (SPEC-02) can link
to or transclude. Different list per section, per camp type, with
optional "additional items" overrides per event. Items are structured
records with quantity and alternative — supporting cleaner page
structure and a printable checkbox layout.

The 2nd Acomb Group's KL1–KL5 layered model and 1st Liss's structured
list are the best-practice references; 20th Worcester's mobile-phone
policy block is the safeguarding-friendly addition.

## Acceptance criteria

1. A page exists at `/kit-lists/` listing all kit lists, grouped by
   section.
2. Each kit list has its own page at `/kit-lists/<slug>/` rendering
   the categorised items, optional photos, mobile-phone policy
   block, version label, and last-reviewed date.
3. **Items are structured records** with `name`, `quantity` (default 1),
   and `alternative` (free text). Renders as a labelled row in the
   on-screen view and as a checkbox row in the print view.
4. **Printable view at `/kit-lists/<slug>/print/`** — separate route
   with print-friendly stylesheet, items rendered with checkboxes,
   no nav, no footer except the print-stylesheet copy of the Group
   name and date. Parents print or "Save as PDF" from the browser.
5. Event pages (SPEC-02) with `kit_list_ref = "<slug>"` link to the
   matching kit list. The event's own `additional_kit` field appends
   to the rendered list when transcluded.
6. **Starter pack** ships in `exampleSite/`: Cubs weekend, Cubs
   summer camp, Scouts weekend, Scouts summer camp, Explorers
   expedition, plus desert-climate variants for Cubs weekend, Cubs
   summer, Scouts weekend, Scouts summer.
7. Feature gated by `params.features.kit_lists` (default OFF).
8. Example site exercises: a UK-climate Cubs weekend list, a desert-
   climate variant, a list with the optional mobile-phone policy
   shortcode, a list with cross-border notes (BSO), the printable
   view route.

## Content layout

```
content/kit-lists/
├── _index.md
├── cubs-weekend.md
├── cubs-weekend-desert.md
├── cubs-summer-camp.md
├── cubs-summer-camp-desert.md
├── scouts-weekend.md
├── scouts-weekend-desert.md
├── scouts-summer-camp.md
├── scouts-summer-camp-desert.md
└── explorers-expedition.md
```

## Front-matter schema

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | yes | — | "Cubs Weekend Camp Kit List" |
| `section` | string | yes | — | One of `data/scout_sections.toml` keys |
| `camp_type` | string | no | "" | "weekend", "summer", "winter", "indoor", "expedition" |
| `climate` | string | no | "temperate" | "temperate" \| "desert" \| "winter" — drives starter-pack labelling |
| `version` | string | no | "1.0" | Free text, e.g. "2026.1" |
| `last_reviewed` | date | yes | — | When the leader last sanity-checked this list |
| `reviewed_by` | string | no | "" | Free text — leader nickname |
| `intro` | string (HTML allowed) | no | "" | Renders above the categories |
| `categories` | list[block] | yes | — | See below |
| `phone_policy` | bool | no | false | Renders the standard phone-policy block |
| `cross_border_notes` | string (HTML allowed) | no | "" | BSO: passport, EHIC/GHIC, currency notes |
| `non_essential` | string (HTML allowed) | no | "" | "Please leave at home" list |

Each category block:

```toml
[[categories]]
  name = "Sleeping"
  notes = "If you don't have a 3-season bag, please contact GSL — we have spares."

[[categories.items]]
  name = "Sleeping bag"
  quantity = 1
  alternative = "Or two warm fleece blankets if no bag"

[[categories.items]]
  name = "Roll mat or sleeping mat"
  quantity = 1

[[categories.items]]
  name = "Pillow (small)"
  quantity = 1

[[categories.items]]
  name = "Pyjamas"
  quantity = 1
```

| Sub-field of `categories` | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `name` | string | yes | — | "Sleeping", "Clothing", "Personal", "Cooking gear" |
| `notes` | string (HTML allowed) | no | "" | Renders below the item list |
| `items` | list[item] | yes | — | See below |

| Sub-field of `categories.items` | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `name` | string | yes | — | The item name |
| `quantity` | int | no | 1 | "3 pairs of socks" → quantity 3 |
| `alternative` | string | no | "" | Free text — "or fleece blankets if no bag" |

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/kit-lists/list.html` | `/kit-lists/` index, grouped by section |
| `layouts/kit-lists/single.html` | `/kit-lists/<slug>/` (on-screen) |
| `layouts/kit-lists/print.html` | `/kit-lists/<slug>/print/` (printable view) |
| `layouts/partials/kit-list-categories.html` | Category-by-category list — both views call this with a `mode` param |
| `layouts/partials/kit-list-item.html` | Single item row — `mode = "screen"` shows quantity badge + alternative; `mode = "print"` prepends a checkbox |
| `layouts/partials/kit-phone-policy.html` | Reusable phone-policy block |
| `layouts/shortcodes/kit-list.html` | Transclude a kit list inside another page (e.g. an event) |

The print route is implemented as a Hugo subpage —
`content/kit-lists/<slug>/print.md` would be one approach, but cleaner
is a custom output format `KitListPrint` declared on the kit-lists
content type so Hugo emits both `/kit-lists/<slug>/` (HTML) and
`/kit-lists/<slug>/print/` (HTML with print stylesheet) from the
same source file.

## hugo.toml additions

```toml
[params.features]
  kit_lists = false                       # default OFF — opt-in

[params.kit_lists]
  show_phone_policy_default = false
  default_phone_policy_text = "default i18n string applied if blank"
  printable_route = true                  # generate /print/ subroute
```

## Asset paths

Optional images per item or category — `assets/kit-lists/<slug>/<item>.jpg`.
Not used in v1; if a Group wants to illustrate a 3-season bag, they
add an inline image via Markdown in the `intro` or `categories[].notes`.

## CSS-only baseline

### On-screen view

- Two-column layout on wide screens (≥768px), single column below.
- Item rows show: `name` (bold), `quantity` badge if > 1, `alternative`
  text in muted colour.
- `<details>`/`<summary>` per category for collapse on mobile,
  optional.

### Print view (`/print/`)

- Single A4-friendly page.
- Each item rendered as a checkbox row: `<label><input type="checkbox">
  Item name (×3) — or fleece blankets</label>`.
- Two-column packed layout for compactness.
- Hide nav, hide hero, hide non-essentials.
- Page header: Group name + kit list title + camp dates if known +
  child name field (blank line for handwriting).
- Page footer: "v1.2 reviewed 2026-04-01" small print.

## BSO notes

The `cross_border_notes` field is BSO-friendly. Recommend the BSO Hub
(SPEC-10) cross-references kit lists that have non-empty
`cross_border_notes`.

Examples to include in the BSO archetype comment:
- Passport, photocopy of passport
- EHIC / GHIC, travel insurance
- Local currency for tuck (€10 / AED 50 etc.)
- Adapters
- Local pharmacy substitutes for any UK-only brand the parent might
  assume travels

The desert-climate starter-pack variants are particularly useful for
BSO Groups in UAE, Saudi Arabia, Oman, Egypt etc. — high temperatures
and sun exposure change the kit list materially (sun hat mandatory,
extra water, lighter sleeping bag, sand-suitable footwear).

## Safeguarding & GDPR

- Mobile phone policy: `phone_policy = false` default means each Group
  affirmatively chooses to publish a policy. Configurable via i18n and
  front-matter. Recommended default mirrors 20th Worcester's pattern.
- Don't include children's names in kit lists.
- Don't include leaders' personal mobile numbers — only the Group
  duty mobile or generic email.

## Decided

| Q | Decision |
| --- | --- |
| Q5.1 | **Structured items** — `{name, quantity, alternative}` records, not plain strings. Cleaner on-screen and supports the printable checkbox view. |
| Q5.2 | **Yes** — ship a starter pack including desert-climate variants for Cubs weekend, Cubs summer, Scouts weekend, Scouts summer. Material reduction in friction for BSO Groups in hot climates. |
| Q5.3 | **Free-text `additional_kit` on Event front-matter** (already in SPEC-02 schema). Cleaner than per-event override blocks. |
| Q5.4 | **No PDF generation.** Printable browser route at `/kit-lists/<slug>/print/` with checkboxes covers the use case. Browser "Save as PDF" handles the export. |

## Out of scope (cross-references)

- Per-young-person kit checking — that's leader paperwork, not
  website content.
- Quartermaster inventory.
- Hire-it kit ("we can lend you a sleeping bag") — Groups put this
  in the `intro`.
- Camp shop / Scout shop links — Markdown links in `intro`.

## Implementation order

1. Schema, archetype with structured items.
2. `layouts/kit-lists/single.html` with hardcoded categories.
3. Replace with front-matter-driven categories.
4. `layouts/partials/kit-list-categories.html` and `kit-list-item.html`
   with `mode` parameter.
5. `layouts/kit-lists/print.html` — register custom output format,
   verify route emits.
6. `layouts/kit-lists/list.html`.
7. `layouts/partials/kit-phone-policy.html` + i18n string.
8. Print stylesheet for the `/print/` route.
9. Cross-border-notes block (BSO archetype variant).
10. Shortcode `{{< kit-list "cubs-weekend" >}}` for transclusion in
    events (SPEC-02).
11. Starter pack: write all nine kit lists in `exampleSite/`.
12. README, screenshot of both views.
