# Grow With Us schedule: handoff for Jonathan

The September Sunday schedule is built and published. It goes on plantify.org as an
embed. Nothing needs to be rebuilt.

**Live page:** https://bigdudd3.github.io/plantify-schedule/
**Source repo:** https://github.com/bigdudd3/plantify-schedule (public, GitHub Pages from `main`)

## Where it goes

`/grow-with-us.html`, above the FAQ. That page is the target because the QR code on the
printed September flyer already points there, and the page currently has no schedule on it.

## How to add it (Weebly)

1. Edit `/grow-with-us.html`.
2. Drag an **Embed Code** element to the position above the FAQ.
3. Click it, choose **Edit Custom HTML**, paste the contents of `embed-code.html`.
4. Publish.

The embed box usually renders blank or as a grey placeholder inside the Weebly editor.
Check the published page, not the editor. (Standard Weebly behaviour, not verified on
this specific site.)

## What the embed code does

The iframe starts at a fixed 2600px. The embedded page measures itself and posts its real
height to the parent, which resizes the iframe. On window resize the parent pings the
iframe and it re-measures. Result: no inner scrollbar, no dead space below.

If the script is stripped or fails, the iframe stays at 2600px and everything is still
readable and usable, just with some empty space at the bottom.

## Traffic and SEO

All traffic lands on plantify.org. The GitHub Pages URL is the frame's source, not a
destination: visitors stay on `/grow-with-us.html`, the address bar never changes, and
links inside the embed (Open in Maps, Instagram, Facebook, the mailing list form, the FAQ
link) either open a new tab or post to Mailchimp.

The embedded copy is set to `noindex, nofollow` and serves a `robots.txt` that disallows
everything, so it cannot appear in search results or compete with plantify.org for the
same content. Verified live on 2026-09-03.

Two known limits of embedding this way:

- Google indexes the text of plantify.org's own page, not text inside a third-party
  iframe. The schedule copy will not contribute to plantify.org's search ranking. If the
  schedule needs to be searchable, it has to be native HTML on the Weebly page rather than
  an iframe.
- The site's Google Analytics tag runs on the Weebly page and will record the pageview.
  It will not see clicks inside the iframe (photo opens, card expands), since that is a
  separate origin.

## Verified

Tested in a simulated host page at 1280px and 390px:

- Iframe fills the host content column, no horizontal overflow at either width
- Height tracks content in both directions (2515px desktop, 3496px phone)
- No inner scrollbar, no visible frame border, 14px gap to the next element
- All 51 assets load over HTTPS from the Pages host
- Photo rail: click opens the lightbox, drag pans without opening it
- Schedule: 4 cards, next-Sunday marker sets itself from the system date

## Changing the content later

The source lives in this repo under `src/`. Edit `src/landing-page-mockup.html`, run
`src/build-embed.sh`, commit, push. Pages redeploys in about a minute. The embed on
plantify.org picks it up with no change to the pasted code.

`src/README.md` has the row format, the tag classes, and the cancelled-Sunday state.

## Two things to decide

1. **Hosting.** It is on a GitHub Pages URL under a personal account
   (`bigdudd3.github.io`). If that should be a Plantify-owned URL, say so and it can move
   to a Plantify GitHub org or a subdomain like `schedule.plantify.org`. The embed code
   only needs its `src` changed.
2. **October.** The page covers September only. After Sept 27 it reads "October dates are
   posted here at the end of the month" and nothing else. October rows need adding before
   then.
