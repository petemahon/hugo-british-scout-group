# Self-hosted webfonts

These are the theme's webfonts, shipped in the repo so that **no visitor
request ever reaches a third-party font CDN** (Google Fonts or otherwise).
This is what makes the theme's "no tracking" promise literally true.

| Family | Role | Weights | Subsets |
| --- | --- | --- | --- |
| **Manrope** | body / UI (`--font-family`) | 400, 500, 600, 700, 800 | latin, latin-ext |
| **Nunito Sans** | poster display (`--font-display`) | 800, 900 | latin, latin-ext |

`woff2` only - universally supported and the smallest format. The `@font-face`
declarations (with `unicode-range` per subset and `font-display: swap`) are
emitted by `layouts/partials/fonts.html`, fingerprinted in production.

## Licence

Both families are licensed under the **SIL Open Font License 1.1**:

- Manrope - Copyright 2018 The Manrope Project Authors
  (https://github.com/sharanda/manrope) - see `OFL-Manrope.txt`
- Nunito Sans - Copyright 2016 The Nunito Sans Project Authors
  (https://github.com/Fonthausen/NunitoSans) - see `OFL-NunitoSans.txt`

## (Re)downloading the binaries

The `*.woff2` files and the two `OFL-*.txt` files are produced by:

```sh
./scripts/fetch-fonts.sh
```

Run it once and commit the result; re-run it only to refresh the fonts (e.g.
when bumping the upstream version pinned in that script). If the binaries are
missing, the build fails fast with a message pointing back at the script,
rather than silently dropping to system fonts.
