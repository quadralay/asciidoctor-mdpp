#!/usr/bin/env bash
set -euo pipefail

# Usage: convert-mdpp.sh <SRC_DIR> <OUT_DIR>
if [ $# -lt 2 ]; then
  echo "Usage: $0 SRC_DIR OUT_DIR"
  exit 1
fi

# remove trailing slashes
SRC_DIR="${1%/}"
OUT_DIR="${2%/}"

# locate converter
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONVERTER="$PROJECT_ROOT/lib/asciidoctor/converter/mdpp.rb"

find "$SRC_DIR" -type f '(' -iname '*.adoc' -o -iname '*.asciidoc' ')' -print0 |
while IFS= read -r -d '' src; do
  rel="${src#$SRC_DIR/}"
  dst="$OUT_DIR/${rel%.*}.mdpp"
  mkdir -p "$(dirname "$dst")"

  asciidoctor -r "$CONVERTER" -b mdpp -o "$dst" "$src"
done