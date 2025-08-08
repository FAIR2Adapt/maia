#!/usr/bin/env bash
set -euo pipefail

if [[ -f /workspaces/.postcreate_done ]]; then
  BASE="https://${CODESPACE_NAME//_/-}"
  echo
  echo "✅ Setup complete"
  echo "   Skosmos: ${BASE}-9090.app.github.dev/"
  echo
fi
