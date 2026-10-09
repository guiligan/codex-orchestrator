#!/usr/bin/env bash
set -euo pipefail

install_orchestrator() {
  command -v node >/dev/null || { echo 'Node.js 22 or newer is required.' >&2; return 1; }
  command -v curl >/dev/null || { echo 'curl is required.' >&2; return 1; }
  orchestrator_stage=$(mktemp -d)
  trap 'rm -rf "$orchestrator_stage"' EXIT
  curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    'https://raw.githubusercontent.com/guiligan/codex-orchestrator/v1.1.0/install-orchestrator.cjs' \
    --output "$orchestrator_stage/install-orchestrator.cjs"
  node - "$orchestrator_stage/install-orchestrator.cjs" <<'NODE'
const fs = require('node:fs');
const crypto = require('node:crypto');
const hash = crypto.createHash('sha256').update(fs.readFileSync(process.argv[2])).digest('hex');
if (hash !== '40717a3b217e3abffb9eaab7c19b1ef031a17aa77069f8f65cff7aafc088bb38') {
  throw new Error('Downloaded installer checksum mismatch; installation stopped.');
}
NODE
  node "$orchestrator_stage/install-orchestrator.cjs"
}

install_orchestrator "$@"
