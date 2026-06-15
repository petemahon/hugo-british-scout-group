+++
title = "Kit lists"
intro = "What to pack for each kind of camp. Print any list as a checkbox sheet and tick items off as you pack - and remember, if there's something you don't have, just ask: we'd always rather lend kit than have anyone miss out."

# Cascade: every kit-list page (descendant of /kit-lists/) emits HTML
# plus a printable checkbox view at /kit-lists/<slug>/print.html,
# rendered by layouts/kit-lists/single.kitlistprint.html. Group authors
# don't set `outputs` per list. Requires [outputFormats.KitListPrint]
# in hugo.toml. See SPEC-05.
[cascade]
  outputs = ["html", "KitListPrint"]
+++

Pick the list that matches the camp. Each one shows a version and the
date a leader last checked it, so you know it's current.
