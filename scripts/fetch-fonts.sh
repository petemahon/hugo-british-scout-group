#!/usr/bin/env bash
#
# Hugo British Scout Group theme - CC BY-SA 4.0 (c) Peter Mahon
# https://github.com/petemahon/hugo-british-scout-group
#
# fetch-fonts.sh - download the self-hosted webfont binaries into
# assets/fonts/ so the theme makes NO runtime request to a font CDN.
#
# This is a MAINTENANCE step, not a build step: run it once, commit the
# resulting *.woff2 files, and they ship in the repo from then on. Re-run it
# only to refresh the fonts (e.g. when bumping the upstream version below).
#
# Fonts: Manrope (400/500/600/700/800) + Nunito Sans (800/900), latin and
# latin-ext subsets, woff2 only. All under the SIL Open Font License 1.1 -
# the matching OFL.txt for each family is fetched alongside.
#
# Usage:  ./scripts/fetch-fonts.sh        (from anywhere; resolves repo root)
#
# Pinned upstream versions (gstatic):  Manrope v20, Nunito Sans v19.

set -euo pipefail

# Resolve repo root from this script's location, then target assets/fonts/.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEST="${SCRIPT_DIR}/../assets/fonts"
mkdir -p "$DEST"

# filename|url  (latin: Manrope "_C-bk", Nunito "Xs1Ul"; latin-ext: "_M-bk" / "XvVUl")
FONTS=(
  "manrope-latin-400.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk79FN_C-bk.woff2"
  "manrope-latin-500.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk7PFN_C-bk.woff2"
  "manrope-latin-600.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk4jE9_C-bk.woff2"
  "manrope-latin-700.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk4aE9_C-bk.woff2"
  "manrope-latin-800.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk59E9_C-bk.woff2"
  "manrope-latin-ext-400.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk79FN_M-bk.woff2"
  "manrope-latin-ext-500.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk7PFN_M-bk.woff2"
  "manrope-latin-ext-600.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk4jE9_M-bk.woff2"
  "manrope-latin-ext-700.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk4aE9_M-bk.woff2"
  "manrope-latin-ext-800.woff2|https://fonts.gstatic.com/s/manrope/v20/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk59E9_M-bk.woff2"
  "nunito-sans-latin-800.woff2|https://fonts.gstatic.com/s/nunitosans/v19/pe1mMImSLYBIv1o4X1M8ce2xCx3yop4tQpF_MeTm0lfGWVpNn64CL7U8upHZIbMV51Q42ptCp5F5bxqqtQ1yiU4GVi5Xs1Ul.woff2"
  "nunito-sans-latin-900.woff2|https://fonts.gstatic.com/s/nunitosans/v19/pe1mMImSLYBIv1o4X1M8ce2xCx3yop4tQpF_MeTm0lfGWVpNn64CL7U8upHZIbMV51Q42ptCp5F5bxqqtQ1yiU4Gfy5Xs1Ul.woff2"
  "nunito-sans-latin-ext-800.woff2|https://fonts.gstatic.com/s/nunitosans/v19/pe1mMImSLYBIv1o4X1M8ce2xCx3yop4tQpF_MeTm0lfGWVpNn64CL7U8upHZIbMV51Q42ptCp5F5bxqqtQ1yiU4GVi5XvVUl.woff2"
  "nunito-sans-latin-ext-900.woff2|https://fonts.gstatic.com/s/nunitosans/v19/pe1mMImSLYBIv1o4X1M8ce2xCx3yop4tQpF_MeTm0lfGWVpNn64CL7U8upHZIbMV51Q42ptCp5F5bxqqtQ1yiU4Gfy5XvVUl.woff2"
)

# filename|url  - upstream OFL licence text, committed alongside the binaries.
LICENCES=(
  "OFL-Manrope.txt|https://raw.githubusercontent.com/google/fonts/main/ofl/manrope/OFL.txt"
  "OFL-NunitoSans.txt|https://raw.githubusercontent.com/google/fonts/main/ofl/nunitosans/OFL.txt"
)

fetch() {
  local name="${1%%|*}" url="${1#*|}"
  echo "  -> ${name}"
  # Direct gstatic/raw URLs serve the file as-is; UA set for good measure.
  curl -fSL --retry 3 --retry-delay 2 \
    -A "Mozilla/5.0 (self-hosting fetch; british-scout-group theme)" \
    -o "${DEST}/${name}" "${url}"
}

echo "Downloading webfonts into ${DEST} ..."
for entry in "${FONTS[@]}"; do fetch "$entry"; done
echo "Downloading OFL licences ..."
for entry in "${LICENCES[@]}"; do fetch "$entry"; done

echo
echo "Done. ${#FONTS[@]} woff2 files + ${#LICENCES[@]} licences in assets/fonts/."
echo "Review, then commit assets/fonts/ together with the theme changes."
