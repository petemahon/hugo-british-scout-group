# Hugo British Scout Group theme

A reusable, palette-driven [Hugo] theme for UK Scout Group websites.
Front-matter-driven sections, no JavaScript, faithful to the Scouts brand
guidelines.

[Hugo]: https://gohugo.io

---

## Features

- **Five built-in palette presets**, each composed entirely of official Scouts
  brand colours (Purple, Teal, Forest Green, Red, Pink, Navy, Blue, Yellow,
  Orange, Green). Set one line in `hugo.toml` to apply.
- **Front-matter-driven sections**: each page lists its sections in YAML/TOML
  and the theme renders the right partial. No HTML to author.
- **Eight section types**: `hero`, `two-col-cta`, `two-col-image-cta`,
  `section-grid`, `stacked-features`, `section-header`, `embed`,
  `palette-showcase`, plus a `prose` escape hatch for free-form Markdown.
- **No JavaScript dependency** — sticky nav, smooth scroll, fade-in-on-scroll
  and responsive layout are all pure CSS.
- **Designed for GitHub Pages**, with a working build workflow in the example
  site.
- **Brand-compliant by default**: ships zero copyrighted imagery. You bring
  your own Group photos and download Scout logos from
  [scoutsbrand.org.uk](https://scoutsbrand.org.uk).

---

## Quick start (any Scout Group)

### 1. Install Hugo

You need the **extended** edition of Hugo, version 0.128 or newer.

| OS | Command |
| --- | --- |
| **macOS** (Homebrew) | `brew install hugo` |
| **Windows** (Winget) | `winget install Hugo.Hugo.Extended` |
| **Linux** (Snap) | `sudo snap install hugo` |
| **Linux** (Debian/Ubuntu .deb) | Download from [Hugo releases](https://github.com/gohugoio/hugo/releases) and `sudo dpkg -i hugo_extended_*.deb` |
| **Any** (Python wrapper) | `pip install hugo` |

Verify:

```sh
hugo version
# Should print: hugo v0.x.x+extended ...
```

### 2. Create your Group site

```sh
hugo new site 1st-anytown-scouts
cd 1st-anytown-scouts
git init
```

### 3. Add the theme as a Git submodule

```sh
git submodule add https://github.com/petemahon/hugo-british-scout-group.git themes/british-scout-group
```

### 4. Configure `hugo.toml`

Replace the auto-generated `hugo.toml` with the one from this theme's
`exampleSite/hugo.toml` and edit the parts marked `# CHANGE ME`. The minimum
config for a working site is:

```toml
baseURL = "https://example.com/"
languageCode = "en-gb"
title = "1st Anytown Scouts"
theme = "british-scout-group"

[params]
  palette = "classic-purple"          # see "Picking a palette" below
  description = "Skills for life in Anytown."
  logo = "images/your-group-logo.webp"   # under your site's assets/
  favicon = "images/favicon.png"          # under your site's static/
  copyrightOwner = "1st Anytown Scouts"
  copyrightRights = "All Rights Reserved"

[[menu.main]]
  name = "Join us"
  url = "/#join"
  weight = 10
```

### 5. Add your home page content

Copy `themes/british-scout-group/exampleSite/content/_index.md` to your
project's `content/_index.md` and edit the `[[sections]]` entries.

### 6. Run locally

```sh
hugo server
# open http://localhost:1313
```

---

## Picking a palette

Five palettes ship in `data/palettes.toml`. To preview all of them, the
example site has a `/palettes/` page that renders every palette as a swatch
card. **Run the example site locally** to see them:

```sh
cd themes/british-scout-group/exampleSite
hugo server --themesDir ../..
# open http://localhost:1313/palettes/
```

To apply a palette, set `params.palette` in your `hugo.toml`:

```toml
[params]
  palette = "adventure"   # or: classic-purple, coastal, vibrant, network
```

To **add your own palette**, edit `data/palettes.toml` in the theme (or
shadow it by creating `data/palettes.toml` in your own site — Hugo will
merge it). Each palette needs the keys: `name`, `description`, `primary`,
`primary_hover`, `secondary`, `secondary_hover`, `tertiary`, `accent`,
`bg`, `bg_muted`, `text`, `text_muted`, `text_on_primary`,
`text_on_secondary`. **Use only colours from the official Scouts palette**
to stay brand-compliant.

If the Scout Association updates the brand colours, edit the hex values in
`data/palettes.toml`. Nothing else needs to change.

---

## Section types

Each entry under `[[sections]]` in your page front matter must have a `type`
matching one of these. Full schemas are documented in the comment at the top
of each partial in `layouts/partials/sections/`.

| Type | Use for | Key params |
| --- | --- | --- |
| `hero` | Big welcome banner with title + intro text. | `title`, `text`, `background` |
| `two-col-cta` | Two text columns; one is a description, the other has primary CTAs. | `left.{title,text}`, `right.{title,text,buttons}` |
| `two-col-image-cta` | Image on one side, headline + body + button on the other. | `image.{src,alt}`, `title`, `text`, `buttons`, `reverse` |
| `section-grid` | Centred header and a responsive grid of cards (e.g. the four Scout sections). | `title`, `subtitle`, `cards[]` |
| `stacked-features` | Header with a left column of stacked text items and an image on the right. | `title`, `intro`, `items[]`, `image` |
| `section-header` | Centred title + subtitle, no body content. Use as a header above an embed or content area. | `title`, `subtitle` |
| `embed` | Generic responsive iframe (SnazzyMaps, YouTube, etc.). | `url`, `height`, `width`, `title` |
| `bso-membership` | Eligibility notice for BSO Groups (POR 3.2.1.1). Wraps `partials/bso-membership-notice.html`. | site-level `[params.bsoMembershipNotice]` |
| `palette-showcase` | Theme's own palette reference page. Lists every palette in `data/palettes.toml`. | `title`, `intro` |
| `prose` | Free-form Markdown body — the escape hatch. | `title`, `body` |

### Common section params

Every section type also accepts these:

| Param | Values | Effect |
| --- | --- | --- |
| `id` | string | HTML anchor id. Used by nav links like `/#sections`. |
| `bg` | `muted` / `primary` / `secondary` / `tertiary` / `accent` / `dark` | Section background tone. Pulls from the active palette. Text colour flips automatically for legibility. `dark` is Scouts Navy, fixed. |
| `title_color` | `primary` / `secondary` / `tertiary` / `accent` | Tints the section's main heading using a palette colour. Useful when a section has a default-white background but you want a brand-coloured heading. |

Example:

```toml
[[sections]]
  type        = "section-header"
  id          = "where-we-meet"
  title       = "Where we meet"
  title_color = "primary"   # heading in Scouts Purple
```

---

## BSO membership notice

For British Scouting Overseas (BSO) Groups, this theme ships a partial that
renders an eligibility notice in line with The Scout Association's POR
3.2.1.1 — youth membership of a BSO Group is for nationals other than those
of the host country, and host-country nationals are pointed to their own
WOSM-recognised National Scout Organisation. Volunteering is open to anyone.

**Configure it once, in `hugo.toml`:**

```toml
[params.bsoMembershipNotice]
  enable                  = true
  hostCountryName         = "the United Arab Emirates"   # natural article OK
  hostScoutingAssociation = "Emirates Scout Association"
```

**Place it in your page** as a section in `_index.md`:

```toml
[[sections]]
  type = "bso-membership"
  id   = "membership"
  bg   = "muted"
```

**Override the wording** by creating `i18n/en.toml` at your site root with
any of these keys: `bsoNoticeHeading`, `bsoNoticeIntro`,
`bsoNoticeAssociation`, `bsoNoticeVolunteering`, `bsoNoticeRuleReference`.
Placeholders `{{ .HostCountry }}` and `{{ .HostAssociation }}` are
interpolated from your `[params.bsoMembershipNotice]` config.

**Override per page** with front matter:

```toml
[bsoMembershipNotice]
  enable = false   # disable on this specific page
```

The partial is also callable directly from any layout for advanced
positioning (`{{ partial "bso-membership-notice.html" . }}`) — see the
header comment in `layouts/partials/bso-membership-notice.html`.

---

## Setting up a SnazzyMap (the "Where we meet" section)

SnazzyMaps gives you a styled Google Map with location pins and no Google
API key required.

1. Sign up at [snazzymaps.com](https://snazzymaps.com).
2. Click **Create a Map**, set the centre and zoom for your area.
3. Add place markers for each Scout Group meeting location. For each
   marker, fill in the title, description and an optional photo — these
   show in the popup.
4. Click **Save**. SnazzyMaps gives you an embed URL like
   `https://snazzymaps.com/embed/123456`.
5. In your `_index.md`, add an `embed` section:
   ```toml
   [[sections]]
     type = "embed"
     id = "where-we-meet-map"
     url = "https://snazzymaps.com/embed/123456"
     height = "600px"
     title = "Map of where we meet"
   ```

---

## Deploying to GitHub Pages

The example site includes a working `.github/workflows/hugo.yml`. Once your
site is pushed to GitHub:

1. **Settings → Pages → Build and deployment → Source** = "GitHub Actions".
2. Optional: add a `CNAME` file under `static/` containing your custom
   domain (e.g. `scouts.example.org`). Configure the matching DNS A/AAAA
   or CNAME records at your registrar.
3. Push to `main`. The workflow installs Hugo, builds the site, and
   publishes it.

The supplied workflow pins a Hugo version. To upgrade Hugo: edit the
`HUGO_VERSION` env in `.github/workflows/hugo.yml`.

If you cloned with submodules, ensure the workflow's checkout step uses
`with: submodules: recursive`.

---

## Brand assets — what you need to download yourself

This theme **does not redistribute** any Scout logos or brand images. Each
Group must download what it needs from
[scoutsbrand.org.uk](https://scoutsbrand.org.uk) and place the files under
`assets/images/` in your site (not the theme).

The minimum set for a typical home page:

| Asset | Where used |
| --- | --- |
| Group logo (your own) | Top-left of the nav (`params.logo`) |
| Beavers section logo | `section-grid` card |
| Cubs section logo | `section-grid` card |
| Scouts section logo | `section-grid` card |
| Explorers section logo | `section-grid` card |
| Network logo | `stacked-features` image (if you have a Network section) |
| Fleur-de-lis (favicon) | `params.favicon` |

WebP is preferred for size; PNG is fine.

---

## Local development tips

- `hugo server` — live reload on file change.
- `hugo server -D` — also build draft content.
- `hugo --gc --minify` — production build into `public/`.
- Section partials are in `layouts/partials/sections/`. Each starts with a
  comment block listing its expected params.
- The theme's own example site is in `exampleSite/`. To run it from the
  theme repo: `hugo server --source exampleSite --themesDir ../..`.

---

## Project structure

```
hugo-british-scout-group/
├── theme.toml                     # theme metadata
├── LICENSE                        # CC-BY-SA 4.0
├── README.md                      # this file
├── archetypes/
│   └── default.md                 # `hugo new` scaffold
├── data/
│   └── palettes.toml              # palette presets (edit to add more)
├── i18n/
│   └── en.toml                    # translatable strings
├── assets/
│   └── css/
│       └── theme.css              # all design tokens at the top
├── layouts/
│   ├── _default/                  # baseof, single, list templates
│   ├── index.html                 # home — dispatches to section partials
│   ├── partials/
│   │   ├── head.html              # meta + CSS pipeline + palette injection
│   │   ├── header.html            # sticky nav
│   │   ├── footer.html            # group's own copyright
│   │   ├── palette-style.html     # emits chosen palette as CSS vars
│   │   └── sections/              # one partial per section type
│   └── shortcodes/
└── exampleSite/                   # demo site (also doubles as test fixture)
    ├── hugo.toml
    └── content/
        ├── _index.md              # the home page
        └── palettes/_index.md     # palette reference page
```

---

## Licence

Theme code: **Creative Commons Attribution-ShareAlike 4.0 International**
(CC BY-SA 4.0). © Peter Mahon. See `LICENSE` for full text and important
notes on third-party Scout brand assets.

The example content uses placeholder text and the user-supplied imagery
must come from the Group's own files or from scoutsbrand.org.uk.
