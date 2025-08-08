#!/usr/bin/env bash
set -euo pipefail

URL_BASE="http://connectivity-hub.com/terms/"
SCHEME_FILE="scheme.ttl"
MERGED_OUT="concepts.ttl"

curl -sSfL -H 'Accept: text/turtle' "$URL_BASE" -o "$SCHEME_FILE"

mkdir -p concepts
> uris.txt

grep -Eo "${URL_BASE}[0-9a-f-]{36}" "$SCHEME_FILE" \
  | sort -u >> uris.txt           # unique, sorted list

URI_COUNT=$(wc -l < uris.txt)

cat "$SCHEME_FILE" >> "$MERGED_OUT"

while read -r URI; do
  ID=$(basename "$URI")
  TARGET="concepts/${ID}.ttl"

  echo "Fetching $URI"
  curl -sSfL -H 'Accept: text/turtle' "$URI" -o "$TARGET"

  cat "$TARGET" >> "$MERGED_OUT"
  echo >> "$MERGED_OUT"
done < uris.txt

echo "Merged file: $MERGED_OUT"

rm -rf concepts
rm uris.txt
rm scheme.ttl