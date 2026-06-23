+++
# Policy archetype. SPEC-14.
#
# Filename convention:  <slug>.md  (policies are not dated like news)
# Example:              content/policies/privacy.md
# Run:                  hugo new policies/privacy.md
#
# Each policy is a prose page rendered by layouts/policies/single.html
# (the balanced info-page treatment: readable measure on the left, an
# auto "On this page" contents rail + contact card on the right). The
# /policies/ index lists every PUBLISHED policy, and footer.html shows a
# single "Policies" link once one is live. Requires
# params.features.policies = true.
#
# SAFEGUARDING / ACCURACY - READ BEFORE PUBLISHING.
# A published page on this site is fully public (the theme has no backend
# and no auth). Do NOT reproduce The Scout Association's own policies
# (Yellow Card, POR, data-protection terms) as if they were yours - LINK
# to the canonical source and describe how THIS Group applies it. Anything
# you publish here should reflect a position your Trustees have agreed.

title         = "{{ replace .Name "-" " " | title }}"

# One-line summary. Shown on the /policies/ index card and as the page
# lede. Optional but recommended.
description   = ""

# Provenance. Surfaced to readers as "Last reviewed: <date>" on both the
# index card and the page header, so families can see the policy is
# current. Update it whenever the Trustees re-approve the wording.
last_reviewed = {{ now.Format "2006-01-02" }}

# Starter-wording flag. While true, the page renders a prominent banner
# telling readers this is un-adopted theme boilerplate. Set to false (or
# delete the line) once the policy reflects your Group's agreed position.
starter       = true

# Optional. The "Questions about this policy?" card links here, then falls
# back to site params.email, then to /join/. A mailto: address or "".
contact_email = ""

# Standard Hugo. Set to false to publish. Theme-shipped starter policies
# ship as drafts so nothing goes live before a Group has reviewed it.
draft         = true
+++

Replace this body with the policy your Group has agreed. Use `##`
headings - they populate the "On this page" rail automatically. Keep the
page title as the only `<h1>` (the build lints for stray `<h1>`s in the
body - see SPEC-COMMON §17).

## Why this matters

A sentence or two on why the Group has this policy.

## What we do

The substance of the policy.

## Who to contact

How a parent or carer raises a question or a change of consent.
