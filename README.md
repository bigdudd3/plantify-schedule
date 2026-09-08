# Grow With Us Sunday schedule

Powers the schedule embedded on plantify.org/grow-with-us.html.

**Live:** https://bigdudd3.github.io/plantify-schedule/
Served by GitHub Pages from `main`, repo root.

## Editing

Edit `src/landing-page-mockup.html`. That is the source.

Then from `src/`:

```bash
./build-embed.sh
```

That regenerates `index.html` and `_assets/` at the repo root. Commit and push.
Pages redeploys in about a minute. Nothing changes on plantify.org.

Do not edit `index.html` at the root. The next build overwrites it.

## What is in src/

| File | What it is |
|---|---|
| `landing-page-mockup.html` | The schedule page. Edit this. |
| `build-embed.sh` | Regenerates the published copy at the repo root. |
| `README.md` | Row format, tag classes, colors, cancelled-Sunday state. |
| `HANDOFF-jonathan.md` | How the embed works on plantify.org, and open questions. |
| `flyer-template.html` | Separate thing: the printed monthly flyer. |
| `_assets/` | Artwork, photos, fonts. |

## Adding a month

`src/README.md` has the row format and tag classes.

## Embed code

`src/embed-code.html` is what is pasted into the Weebly page. It only needs
changing if the Pages URL moves.
