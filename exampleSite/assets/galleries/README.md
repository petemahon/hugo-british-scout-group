# `exampleSite/assets/galleries/`

Demo galleries shipped with the example site need binary JPGs that
the theme repo can't generate from text. Before running `make serve`
with the galleries feature enabled, drop placeholder JPGs into the
slots below. Filenames must match what the gallery `_index.md` and
sidecar TOMLs reference.

The simplest approach: reuse the two cover JPGs that already live
under `exampleSite/assets/news/`. Copy / link / duplicate as
convenient.

| Gallery slug                       | Filenames needed                |
| ---------------------------------- | ------------------------------- |
| `2026-04-19-st-georges-day/`       | `001.webp`, `002.webp`, `003.webp` |
| `2026-03-30-cubs-cooking-cup/`     | `001.webp`, `002.webp`          |
| `2025-11-15-night-hike/`           | `001.webp`, `002.webp`          |
| `2026-07-12-summer-fete/`          | `001.webp`, `002.webp`          |
| `2026-08-14-cubs-summer-camp/`     | `001.webp` (draft — only built with `--buildDrafts`) |

PNG and WebP are also fine; the content adapter picks up any
`.jpg`, `.jpeg`, `.png`, `.webp` file in the directory and registers
it as a photo page.
