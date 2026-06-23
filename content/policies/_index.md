+++
# Theme-shipped /policies/ branch bundle. Hugo merges theme content with
# site content - a consuming Group that doesn't create its own
# content/policies/_index.md inherits this one. Override at the same path
# in your site repo to change the listing title or intro.
#
# The four policy files in this directory ship as `draft = true` and
# `starter = true`: they DO NOT publish under the deploy policy
# (--buildDrafts=false) until a Group has reviewed one and set
# draft = false. That is deliberate - un-reviewed boilerplate must not go
# live as if it were the Group's agreed policy. The workflow is: copy the
# file's intent, edit it with your Trustees, clear `starter`, set
# `draft = false`. Requires params.features.policies = true.

title       = "Policies"
description = "How this Group keeps young people safe, looks after your data, and handles photos."

# Belt-and-braces: force /policies/ to use list.html.
layout = "list"
+++
