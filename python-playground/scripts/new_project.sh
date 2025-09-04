#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <project-dir-name>"
  exit 1
fi

NAME="$1"
SRC="templates/project-skeleton"
DST="projects/$NAME"

if [ -d "$DST" ]; then
  echo "Already exists: $DST"
  exit 1
fi

cp -r "$SRC" "$DST"

PKG=$(echo "$NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]')
mkdir -p "$DST/src/$PKG"
sed -i.bak "s/REPLACE_ME/$NAME/g" "$DST/pyproject.toml" && rm "$DST/pyproject.toml.bak"

echo "Created $DST"
echo "Next:"
echo "  cd $DST"
echo "  python -m venv .venv && source .venv/bin/activate"
echo "  pip install -r ../../dev-requirements.txt"
echo "  pytest"
