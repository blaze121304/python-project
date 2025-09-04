#!/usr/bin/env bash
set -euo pipefail

ruff check --fix
black .
isort .

for p in projects/*; do
  if [ -d "$p/tests" ]; then
    echo "==> pytest in $p"
    (cd "$p" && pytest)
  fi
done
