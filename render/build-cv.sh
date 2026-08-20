#!/usr/bin/env bash
#
# Render readme.md into a PDF CV.
#
#   pandoc  markdown -> typst
#   sed     add the two bits of CV layout markdown can't express
#   typst   typst -> PDF
#
#   ./render/build-cv.sh [output.pdf]
#
# readme.md is never modified: it is copied into render/.build/ first.
# All styling lives in render/header.typ and render/meta.yaml.
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."   # repo root; every path below is relative to it

REPO_URL="${REPO_URL:-https://github.com/sunrise-designs/CV}"
LEARNINGS_URL="${LEARNINGS_URL:-$REPO_URL/blob/main/learnings/readme.md}"

for tool in pandoc typst; do
  command -v "$tool" >/dev/null || { echo "error: $tool not found on PATH" >&2; exit 1; }
done

rm -rf render/.build && mkdir -p render/.build
cp readme.md render/.build/cv.md

# readme.md centres its headings with raw <h1>, which pandoc's typst writer
# drops on the floor. The first one is the name (-> document title and file
# name), the rest become real headings for header.typ to style.
NAME=$(sed -n 's|.*<h1[^>]*>\(.*\)</h1>.*|\1|p' render/.build/cv.md | head -1)
sed -i -e '0,/<h1/{/<h1/d}' -e 's|<h1[^>]*>\(.*\)</h1>|# \1|' render/.build/cv.md

OUT="${1:-render/out/$NAME CV $(date +%F).pdf}"
mkdir -p "$(dirname "$OUT")"

# --wrap=none is load-bearing: the seds below match " | " on a single line,
# and pandoc would otherwise hard-wrap its output at 72 columns.
pandoc render/.build/cv.md -o render/.build/cv.typ \
  --to=typst --standalone --wrap=none \
  --metadata-file=render/meta.yaml --metadata=title="$NAME" \
  --include-in-header=render/header.typ

# "Employer | Role | Dates" -> employer left, role and dates together right.
sed -i 's/ | / #h(1fr) /'         render/.build/cv.typ   # 1st separator: elastic
sed -i 's/ | / #h(1.5em) /g'      render/.build/cv.typ   # the rest: fixed gap
sed -i '/#h(1fr)/s|.*|#entry[&]|' render/.build/cv.typ   # spacing, see header.typ
printf '\n#source-link("%s", "%s")\n' "$REPO_URL" "$LEARNINGS_URL" >> render/.build/cv.typ

typst compile --root render/.build render/.build/cv.typ "$OUT"
echo "built: $OUT"

# Let the workflow name its artifact after the PDF, rather than have both
# compute today's date independently.
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  printf 'pdf-path=%s\npdf-name=%s\n' "$OUT" "$(basename "$OUT" .pdf)" >> "$GITHUB_OUTPUT"
fi
