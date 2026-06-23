# SPEC-14: Policies

Read `SPEC-COMMON.md` first. Completes the half-built `policies`
section (the `layouts/policies/single.html` balanced-info-page layout
and its i18n strings already shipped; the listing, footer link,
archetype and theme-shipped boilerplate did not).

## Goal

Give every Group a small set of **review-before-use** policy pages out
of the box - photo consent, privacy/data protection, a safeguarding
statement, social media/communications - so the safeguarding checklist
in the setup guide points at something real, not a blank. Ship the
boilerplate **in the theme** (not just in `exampleSite/`), and surface
published policies with a single automatic footer link.

## Why theme-shipped drafts (the safe-publish decision)

The theme has **no backend and no authentication** (a locked
invariant), so anything rendered is fully public. Un-reviewed
boilerplate must therefore never go live as if it were the Group's
agreed policy - that is exactly the "don't publish wording you haven't
adopted" risk.

So the four starter policies ship in `content/policies/` as
**`draft = true`**. Under the deploy policy (`--buildDrafts=false`)
they do not render until a Group has reviewed one and set
`draft = false`. They also carry **`starter = true`**, which renders a
prominent "review this wording" banner for as long as the flag is
present - a second safety net for a Group that publishes before fully
adopting the text. The safeguarding policy in particular **links** to
The Scout Association's canonical Yellow Card / POR rather than
reproducing them.

Decided via the 4-question slate on 2026-06-22:

| Q | Decision |
| --- | --- |
| Boilerplate delivery | **Draft files + archetype + banner.** Theme ships `content/policies/*.md` as `draft = true` / `starter = true`; `archetypes/policies.md` scaffolds new ones; a rendered banner warns while `starter` is set. |
| Footer link | **Single "Policies" link → `/policies/` index.** Shown only when `features.policies` is on AND at least one policy is published. The index lists every published policy, so the footer stays one link as the set grows. |
| Starter set | **Photo consent, Privacy & data protection, Safeguarding statement, Social media / communications** - each a clearly-marked, review-before-use draft. |
| Flag & nav | **`features.policies` (default OFF), footer-only.** No main-nav entry - the locked SPEC-11 five-group nav contract is untouched; policy links are conventional footer utility links. |

## Acceptance criteria

1. `params.features.policies` gates the feature (default OFF; `true`
   in `exampleSite/hugo.toml`).
2. `/policies/` renders a listing (`layouts/policies/list.html`) of
   every **published** policy with title, description and
   "Last reviewed" date; empty-state copy when none are published.
3. Per-policy pages keep the existing balanced-info-page treatment and
   render the starter banner whenever `starter = true`.
4. `footer.html` shows a single "Policies" link to `/policies/` only
   when `features.policies` AND `where site.RegularPages "Section"
   "policies"` is non-empty. Hidden in print.
5. The theme ships `content/policies/_index.md` plus four starter
   policies as `draft = true` / `starter = true`. `exampleSite/`
   publishes its own adopted copies (photo-consent, privacy,
   safeguarding) and one deliberate `starter` (social-media) to
   demonstrate the banner.
6. `archetypes/policies.md` scaffolds a new policy as a draft starter
   with the accuracy/safeguarding warning in its comments.
7. No new `<h1>` in any policy body (SPEC-COMMON §17 heading lint
   applies). No JavaScript; pure CSS (`59-section-policies.css`).

## Files

- `layouts/policies/list.html` - new listing.
- `layouts/policies/single.html` - adds the `starter` banner + the
  `last_reviewed` meta line.
- `layouts/partials/footer.html` - adds the gated "Policies" link.
- `assets/css/59-section-policies.css` - new: list cards, starter
  banner (`--warning`), meta, footer link.
- `archetypes/policies.md` - new.
- `content/policies/_index.md` + `photo-consent.md` / `privacy.md` /
  `safeguarding.md` / `social-media.md` - new theme-shipped drafts.
- `i18n/en.toml` - `policiesHeading`, `policiesIntro`,
  `policiesEmptyList`, `policiesFooterLink`, `policyStarterNotice`,
  `policyLastReviewed`.
- `exampleSite/hugo.toml` - `features.policies = true`.
- `exampleSite/content/policies/*.md` - published demo copies.

## Notes

- The existing `[params.galleries].consent_policy_url` link from each
  gallery to the photo-consent policy is unchanged - it is a
  contextual link and complements, rather than duplicates, the
  site-wide footer link. When a Group publishes the photo-consent
  policy, that link resolves naturally.
- Consuming sites inherit the four theme drafts. To publish one, copy
  its intent into a same-path file in the site repo (or edit in place),
  review with the Trustees, clear `starter`, and set `draft = false` -
  the workflow `archetypes/policies.md` documents.
