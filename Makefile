# Hugo British Scout Group theme - development helpers.
#
#   make serve   Roll example dates forward, then run `hugo serve`.
#   make build   Roll example dates forward, then run `hugo --minify`.
#   make roll    Just run the date-roller.
#   make clean   Discard the date-roller's edits to example events.
#
# All Hugo invocations use --buildDrafts=false --buildFuture=false to
# match the deploy policy (drafts hidden, future-dated content gated by
# publishDate which is always in the past after the roller has run).

PY ?= python3

.PHONY: roll serve build clean

roll:
	$(PY) scripts/roll-example-dates.py

serve: roll
	cd exampleSite && hugo serve --buildDrafts=false --buildFuture=false

build: roll
	cd exampleSite && hugo --minify --buildDrafts=false --buildFuture=false

clean:
	@echo "Reverting in-flight date changes to example events..."
	git checkout -- exampleSite/content/events/
