#!/usr/bin/env bash
# After `flutter build web --base-href /cookbook/web/`, GitHub Pages needs 404.html
# identical to index.html so deep links reload correctly.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:-$root/build/web}"
if [[ ! -f "$out/index.html" ]]; then
  echo "Missing $out/index.html — run flutter build web first." >&2
  exit 1
fi
cp "$out/index.html" "$out/404.html"
echo "Wrote $out/404.html"
