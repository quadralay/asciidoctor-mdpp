#!/usr/bin/env bash
set -euo pipefail

# Usage: convert-mdpp-file.sh <INPUT.adoc>
if [ $# -ne 1 ]; then
  echo "Usage: $0 <INPUT.adoc>"
  exit 1
fi

INPUT="$1"

# Verify the input file exists
if [ ! -f "$INPUT" ]; then
  echo "Error: File not found: $INPUT"
  exit 1
fi

# Ensure correct extension
EXT="${INPUT##*.}"
if [[ "$EXT" != "adoc" && "$EXT" != "asciidoc" ]]; then
  echo "Error: Input file must have .adoc or .asciidoc extension"
  exit 1
fi

# Locate converter script relative to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONVERTER="$PROJECT_ROOT/lib/asciidoctor/converter/mdpp.rb"

# Determine output file path (.md extension in same directory)
DIR="$(dirname "$INPUT")"
BASE="$(basename "$INPUT" ."$EXT")"
OUTPUT="$DIR/$BASE.md"

echo "Converting: $INPUT -> $OUTPUT"
asciidoctor -r "$CONVERTER" -b mdpp -o "$OUTPUT" "$INPUT"

# Ensure output ends with a newline
if [ -s "$OUTPUT" ] && [ "$(tail -c1 "$OUTPUT")" != $'\n' ]; then
  printf "\n" >> "$OUTPUT"
fi