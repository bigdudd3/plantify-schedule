#!/usr/bin/env bash
# Builds the embeddable copy of the Sunday schedule and publishes it to the
# repo root, which is what GitHub Pages serves. Copies only the files the page
# actually references, then adds the iframe auto-height script.
# Re-run after editing landing-page-mockup.html, then commit and push.
set -euo pipefail
cd "$(dirname "$0")"

SRC="landing-page-mockup.html"
OUT=".."

rm -rf "$OUT/_assets" "$OUT/index.html"
mkdir -p "$OUT"

python3 - "$SRC" "$OUT" <<'PY'
import os, re, shutil, sys

src, out = sys.argv[1], sys.argv[2]
html = open(src, encoding="utf-8").read()

# Copy every asset the page references, and nothing else.
assets = sorted(set(re.findall(r'_assets/[A-Za-z0-9._/-]+', html)))
missing = [a for a in assets if not os.path.exists(a)]
if missing:
    sys.exit("missing assets:\n  " + "\n  ".join(missing))
for a in assets:
    os.makedirs(os.path.join(out, os.path.dirname(a)), exist_ok=True)
    shutil.copy2(a, os.path.join(out, a))

# This copy exists only to be framed by plantify.org. Keep it out of search
# results so it cannot outrank or compete with the page that embeds it.
noindex = '<meta name="robots" content="noindex, nofollow">\n'
assert "<head>" in html
html = html.replace("<head>", "<head>\n" + noindex, 1)

# Report its height to the embedding page so the iframe can size itself.
resize = """
(function(){
  if (window.parent === window) return;
  var last = 0, timer = null;
  function measure(){
    // Measure the BODY only. documentElement.scrollHeight inflates to the
    // viewport height, which feeds back through the parent's iframe height.
    var b = document.body;
    if (!b) return 0;
    var cs = getComputedStyle(b);
    return Math.ceil(b.getBoundingClientRect().height +
                     parseFloat(cs.marginTop) + parseFloat(cs.marginBottom));
  }
  function post(){
    var h = measure();
    if (h && Math.abs(h - last) > 1){ last = h; parent.postMessage({plantifyEmbedHeight: h}, '*'); }
  }
  function soon(){ clearTimeout(timer); timer = setTimeout(post, 120); }
  addEventListener('load', post);
  addEventListener('resize', soon);
  if (window.ResizeObserver){
    var ro = new ResizeObserver(soon);
    ro.observe(document.documentElement);
    if (document.body) ro.observe(document.body);
  }
  addEventListener('message', function(e){
    if (e.data !== 'plantifyEmbedPing') return;
    last = 0; post();
    requestAnimationFrame(function(){ last = 0; post(); });
    [120, 400].forEach(function(t){ setTimeout(function(){ last = 0; post(); }, t); });
  });
  document.addEventListener('toggle', function(){ setTimeout(post, 280); }, true);
  addEventListener('load', function(){
    document.querySelectorAll('img').forEach(function(i){ i.addEventListener('load', soon); });
  });
  [60, 400, 1200, 2500].forEach(function(t){ setTimeout(post, t); });
})();
</script>"""

assert html.count("</script>") >= 1
html = html[:html.rindex("</script>")] + resize + html[html.rindex("</script>") + len("</script>"):]

open(os.path.join(out, "index.html"), "w", encoding="utf-8").write(html)
print("assets copied:", len(assets))
PY

cat > "$OUT/robots.txt" <<'TXT'
User-agent: *
Disallow: /
TXT

du -sh "$OUT"
echo "built $OUT/index.html"
