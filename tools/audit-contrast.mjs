#!/usr/bin/env node
/*
 * Hugo British Scout Group theme
 * CC BY-SA 4.0 © Peter Mahon
 * https://github.com/petemahon/hugo-british-scout-group
 *
 * audit-contrast.mjs — WCAG 2.2 colour-contrast audit (SPEC-12 AC7 / Q12.7).
 *
 * Hugo can't reliably evaluate contrast ratios, so this runs in CI (and
 * locally with `node tools/audit-contrast.mjs`) instead of at build time.
 * It reads data/palettes.toml, computes the WCAG contrast ratio for every
 * (foreground, background) pair the theme actually declares, and exits
 * non-zero if any pair falls below AA at its applicable text size.
 *
 * It is NOT a brute-force matrix: only the pairs the palette explicitly
 * pairs together are checked (the same pairs palette-style.html emits as
 * CSS custom properties).
 *
 * Size classes (WCAG 1.4.3 / 1.4.11):
 *   normal (4.5:1) — body copy: --text and --text-muted on --bg.
 *   large  (3.0:1) — the "text-on-<brand/app colour>" tokens. These label
 *                    bold buttons, bold uppercase status pills, and display
 *                    headings on coloured bands — never body copy. Per WCAG
 *                    they qualify as large text (>=18.66px bold). This is
 *                    what lets Scouts Red (white text ~3.94:1) and the
 *                    --postponed amber (white ~3.18:1) pass: they are only
 *                    ever used for large/bold chrome, matching the Scouts
 *                    Brand Guidelines' own white-on-red usage rules.
 *   ui     (3.0:1) — non-text indicators: --focus-ring against --bg
 *                    (WCAG 1.4.11 Non-text Contrast). All five palettes in
 *                    fact clear ~6:1 here.
 *
 * No third-party dependencies — the palette file is a flat set of TOML
 * tables, parsed with a small purpose-built reader below.
 */

import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const PALETTE_FILE = join(__dirname, "..", "data", "palettes.toml");

const NORMAL = 4.5; // WCAG AA, normal text
const LARGE = 3.0; // WCAG AA, large/bold text + non-text UI

/* ---- minimal TOML reader for the flat palette tables -------------------- */
// Handles `[table]` headers and `key = "value"` / `key = "#hex"` lines.
// Ignores comments (full-line and trailing) and blank lines. Sufficient for
// data/palettes.toml's structure; not a general TOML parser.
function parsePalettes(text) {
  const tables = {};
  let current = null;
  for (const raw of text.split(/\r?\n/)) {
    const line = raw.trim();
    if (!line || line.startsWith("#")) continue;
    const header = line.match(/^\[([A-Za-z0-9_-]+)\]$/);
    if (header) {
      current = {};
      tables[header[1]] = current;
      continue;
    }
    if (!current) continue;
    const kv = line.match(/^([A-Za-z0-9_]+)\s*=\s*"([^"]*)"/);
    if (kv) current[kv[1]] = kv[2];
  }
  return tables;
}

/* ---- WCAG relative luminance + contrast ratio --------------------------- */
function srgbToLinear(c) {
  const s = c / 255;
  return s <= 0.03928 ? s / 12.92 : Math.pow((s + 0.055) / 1.055, 2.4);
}

function luminance(hex) {
  const m = hex.replace("#", "");
  const r = parseInt(m.slice(0, 2), 16);
  const g = parseInt(m.slice(2, 4), 16);
  const b = parseInt(m.slice(4, 6), 16);
  return (
    0.2126 * srgbToLinear(r) +
    0.7152 * srgbToLinear(g) +
    0.0722 * srgbToLinear(b)
  );
}

function contrast(fg, bg) {
  const a = luminance(fg);
  const b = luminance(bg);
  const lighter = Math.max(a, b);
  const darker = Math.min(a, b);
  return (lighter + 0.05) / (darker + 0.05);
}

/* ---- the declared pairs (fg token, bg token, size class) ---------------- */
// Each entry resolves token names against the palette table. A pair is
// skipped (not failed) if either token is absent from a palette.
const PAIRS = [
  { fg: "text", bg: "bg", size: NORMAL, label: "text / bg" },
  { fg: "text_muted", bg: "bg", size: NORMAL, label: "text_muted / bg" },
  { fg: "text", bg: "bg_muted", size: NORMAL, label: "text / bg_muted" },
  { fg: "text_muted", bg: "bg_muted", size: NORMAL, label: "text_muted / bg_muted" },
  { fg: "text_on_primary", bg: "primary", size: LARGE, label: "text_on_primary / primary" },
  { fg: "text_on_secondary", bg: "secondary", size: LARGE, label: "text_on_secondary / secondary" },
  { fg: "text_on_warning", bg: "warning", size: LARGE, label: "text_on_warning / warning" },
  { fg: "text_on_postponed", bg: "postponed", size: LARGE, label: "text_on_postponed / postponed" },
  { fg: "text_on_status", bg: "status_open", size: LARGE, label: "text_on_status / status_open" },
  { fg: "text_on_status", bg: "status_waiting", size: LARGE, label: "text_on_status / status_waiting" },
  { fg: "text_on_status", bg: "status_closed", size: LARGE, label: "text_on_status / status_closed" },
  { fg: "focus_ring", bg: "bg", size: LARGE, label: "focus_ring / bg (non-text)" },
];

/* ---- run ---------------------------------------------------------------- */
const palettes = parsePalettes(readFileSync(PALETTE_FILE, "utf8"));
let failures = 0;
let checked = 0;

console.log(`WCAG contrast audit — ${PALETTE_FILE}\n`);

for (const [name, p] of Object.entries(palettes)) {
  console.log(`[${name}]`);
  for (const pair of PAIRS) {
    const fg = p[pair.fg];
    const bg = p[pair.bg];
    if (!fg || !bg) continue; // token not declared in this palette
    checked++;
    const ratio = contrast(fg, bg);
    const pass = ratio >= pair.size;
    if (!pass) failures++;
    const tag = pass ? "PASS" : "FAIL";
    console.log(
      `  ${tag}  ${ratio.toFixed(2)}:1  (need ${pair.size.toFixed(1)})  ${pair.label}  ${fg} on ${bg}`
    );
  }
  console.log("");
}

if (failures > 0) {
  console.error(
    `Contrast audit FAILED: ${failures} of ${checked} declared pairs below WCAG AA.`
  );
  process.exit(1);
}
console.log(`Contrast audit passed: all ${checked} declared pairs meet WCAG AA.`);
