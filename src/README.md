# Grow With Us monthly schedule flyer

Files in this folder:

- `flyer-template.html`: the layout. Edit this, re-render.
- `_assets/`: artwork cut out of the original August/September Canva export
  (flowers, bunting, butterflies, bottom botanical band, logo card, QR).
- `2026-09 Grow With Us Schedule.png`: 1428x2000, screen/social.
- `2026-09 Grow With Us Schedule @2x.png`: 2856x4000, print.

## Render

```bash
cd "02_Projects/2026-Grow-With-Us/03_Working/Sunday-Schedule"

# screen
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu \
  --hide-scrollbars --force-device-scale-factor=1 --window-size=1428,2000 \
  --screenshot="2026-10 Grow With Us Schedule.png" "file://$PWD/flyer-template.html"

# print (2x)
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu \
  --hide-scrollbars --force-device-scale-factor=2 --window-size=1428,2000 \
  --screenshot="2026-10 Grow With Us Schedule @2x.png" "file://$PWD/flyer-template.html"
```

## Making next month

1. Change `.titlepill .l2` to the month.
2. One `.row` per Sunday in the month. Every Sunday gets a row. If nothing is
   planned, the row reads `Open garden. Drop in, help out, or just visit.`
3. One row per month gets `class="row feature"`. That is the month's public event.
   If there is no public event that month, no row gets it.
4. Update the `.footer .arc` line to name the current series and its closing event.
5. Leave the `.know` box alone. It is the same every month.
6. Check the dates against a calendar before rendering.

## Row types

| Tag class | Label | Use for |
|---|---|---|
| `t-work` | WORKDAY | Garden maintenance. Say what the task is in plain words. |
| `t-theme` | THEMED SUNDAY | Games, crafts, social. |
| `t-event` | COMMUNITY EVENT | Public draw. Pair with `class="row feature"`. |

## Naming

`YYYY-MM Grow With Us Schedule.png`. No `Aug (2)`, no bare numbers.

## Colors

| | |
|---|---|
| Background sage | `#CBD6AB` |
| Cream | `#FFFACD` / `#FFFAEA` |
| Schedule card | `#CFF0A0` |
| Title pill | `#DBF1DE` |
| Address lavender | `#EBE1F6` |
| Dark green (QR, footer) | `#3A5E1E` |
| Event orange | `#E4632F` |
| Workday green | `#8FBF5A` |
| Themed yellow | `#F2C14E` |

Fonts: Poppins (body), DM Serif Display italic (title). Both installed locally.

## Landing page (landing-page-mockup.html)

Add a month's rows:

1. Set the `<h2>` in `#schedule` to the month and year.
2. Add one `.row` per Sunday. Give each `data-date="YYYY-MM-DD"` and set its `<small>Sun<br>Sep</small>` to the month.
3. Give the month's public event `class="row featured"`. One row at most.
4. Pick the tag: `tag` (Workday), `tag themed` (Themed Sunday), `tag event` (Community event).

Mark a cancelled Sunday: add `cancelled` to the row class, and replace its tag with `<span class="tag off">Cancelled</span>`.

Next-Sunday marker: the script at the end of the file reads `data-date` on every row. The first date on or after today prints "This Sunday" when it is 6 days out or less, "Next Sunday" beyond that. Earlier dates go muted. Keep the dates correct and set nothing else.

Photo gallery: 16 tiles, `gallery-NN-name.jpg` at 1200px wide in `_assets/photos/`, each with a 480px copy of the same name in `_assets/photos/thumbs/`. The page loads the thumb; clicking opens the 1200px version in the lightbox. Add a photo by writing both sizes, then adding one `<button data-full="...">` with a thumb `<img>` and alt text inside `#gallery`.

Card photos: each schedule row carries a `.bg` photo that fades in on hover, and the three `<details>` rows hold three more in `.more .pics`. A row's hover photo must not repeat one of its own expanded photos. Per-row `--glow` is the dominant colour of that row's hover photo; it tints the wash and the edge glow.

Photo sources: Sips & Scents June 28 2026 (`02_Projects/2026-Grow-With-Us/Sips-and-Scents/builds/recap/photos/` in the Plantify repo), plus workday, seed-collecting and game day photos from the Plantify Drive. Only add photos taken at this garden; write alt text for each. Photos with no location record, and photos cut from the page, are kept out of this repo.

Spanish lines (`lang="es"`) come from `2026-09 Grow With Us Schedule (Figma rebuild v3) ES.png` in this folder. Change them only when that flyer changes.

Fonts: `_assets/fonts/`, loaded by the `@font-face` rules at the top of the file.

## Embedding on plantify.org

The page is published for embedding at https://bigdudd3.github.io/plantify-schedule/ (repo `bigdudd3/plantify-schedule`, GitHub Pages from `main`). `embed-code.html` in this folder is the block to paste into a Weebly Embed Code element on `/grow-with-us.html`.

To publish a change:

```bash
cd "02_Projects/2026-Grow-With-Us/03_Working/Sunday-Schedule"
./build-embed.sh          # writes build/ with index.html + only the referenced assets
```

Then copy `build/` into a clone of `bigdudd3/plantify-schedule` and push. The published repo also needs `.nojekyll` at its root: GitHub Pages runs Jekyll by default and Jekyll skips directories starting with an underscore, so without it `_assets/` 404s and the page loads with no photos and no fonts.

`build-embed.sh` appends a script that posts the page height to the parent window so the iframe sizes itself. It measures the body, not `documentElement.scrollHeight`, because that value inflates to the viewport height inside an iframe and feeds back through the parent, growing the frame on every measurement.

