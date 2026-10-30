# Install Orchestrator for Codex

This is a first-party installation bundle. It is not an official marketplace plugin. No license has been specified. The installer is publicly hosted on GitHub.

## One-command install

Requirements: macOS or Linux, Bash, curl, Node.js 22 or newer with npm, and the Codex CLI.

Run this command to download and install Orchestrator:

```sh
bash -o pipefail -c 'curl -fsSL https://raw.githubusercontent.com/guiligan/codex-orchestrator/v1.2.0/install.sh | bash'
```

The command downloads the installer to a temporary directory, verifies its SHA-256 checksum, runs it, and removes the temporary download. No GitHub login or browser download is required.

You can inspect the [installation files on GitHub](https://github.com/guiligan/codex-orchestrator) first. If you prefer a browser download from the website, save `install-orchestrator.cjs` and run it with its actual path:

```sh
node /actual/path/install-orchestrator.cjs
```

The installer verifies its embedded files, installs locked runtime dependencies, places the selector under `CODEX_HOME` (or `~/.codex`), installs the shared planner skill under `~/.agents`, merges one prompt hook without replacing unrelated hook settings, and registers the selector with the Codex CLI. Existing files that it replaces are backed up under `CODEX_HOME/backups/orchestrator`.

When the command finishes, open `/hooks` in Codex, review and trust the Orchestrator hook, then restart Codex and start a new chat. This final trust step is required by Codex.

## Models and host compatibility

Version 1.2.0 updates the editable starting preferences to `gpt-6.1-sol` for implementation and design, `gpt-6-luna` for focused exploration and research, and `gpt-6-astra` for independent review. `gpt-6.1-terra` and `gpt-6-sol` are selectable alternatives when supported by your host. These are preferences, not benchmark or cost guarantees.

The active Codex runtime supplies the available models and reasoning efforts for each proposal; the bundled demo is only an example catalog. Valid catalogs from older hosts remain supported. `gpt-6.1-terra` requires Codex CLI 0.159.0 or later when using the CLI; other hosts may expose different choices. Updating Orchestrator does not upgrade Codex or grant model access.

## Manual fallback from the ZIP

The ZIP offered on the website also contains the readable runtime, planner skill, hook snippet, and this installer. To install manually, extract it into a stable directory, run `npm ci` inside `delegation-selector`, copy `delegation-planner/SKILL.md` to `~/.agents/skills/delegation-planner/SKILL.md`, and register the server with actual absolute paths:

```sh
codex mcp add delegation-selector -- /absolute/path/to/node /absolute/path/to/delegation-selector/server.mjs --stdio
```

Merge the hook snippet into `CODEX_HOME/hooks.json` while preserving unrelated settings. Replace its placeholder skill path with the real absolute path, then perform the same `/hooks` review, trust, restart, and new-chat steps.

The runtime keeps proposals in memory for two hours. Restarting the server clears them. Local selector URLs and MCP bearer tokens are capabilities and must remain private.
