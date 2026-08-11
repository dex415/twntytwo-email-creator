#!/usr/bin/env bash
# Push the current index.html to GitHub Pages.
set -euo pipefail
cd "$(dirname "$0")"
git add -A
git commit -m "${1:-update email creator}" || { echo "nothing to commit"; exit 0; }
git push origin main
echo "pushed — Pages rebuilds in ~1 min"
