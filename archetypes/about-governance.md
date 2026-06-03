+++
# Governance page archetype. SPEC-07.
#
# Create with:  hugo new about/governance.md
# Renders at:   /about/governance/  via layouts/about/governance.html
layout      = "governance"

title       = "Governance"

# Optional HTML intro above the trustee list.
# intro     = "We are a registered charity run by a volunteer Trustee Board."

# Next AGM — all free text, all optional.
# agm_date      = "Tuesday 13 May 2026, 19:30"
# agm_location  = "Anytown Scout Hut, 11 Hut Lane"
# agm_papers_url = "/about/reports/2026-agm-papers.pdf"

# Surface the /about/reports/ archive link (Trustee Annual Reports +
# AGM minutes). Reads data/reports.toml.
show_reports_archive = true

draft = true
+++

Optional Markdown body — renders below the trustee list and AGM
details. The charity number and regulator come from
`[params.governance]` in hugo.toml (not this page); the trustee board
comes from `data/trustees.toml`.
