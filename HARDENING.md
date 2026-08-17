<!-- markdownlint-disable -->

# Hardening Report: Songmu--tagpr/v1.20.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **Songmu--tagpr/v1.20.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The action.yml run block fetches a remote install script via curl and pipes it directly to sh without first saving it to a file for inspection or verification. The command is: `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION" 2>&1`. If the remote URL is compromised or the content is tampered with in transit, arbitrary code will be executed on the runner.

Locations:

- `action.yml:31`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the unsafe curl-pipe-to-shell pattern in action.yml line 31. Changed from `curl ... | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION"` to downloading the script to a temp file first (`curl -sfL ... -o "$INSTALL_SCRIPT"`) and then executing it (`sh "$INSTALL_SCRIPT" -b "$TEMP_PATH" "$TAGPR_VERSION"`). The `--` was dropped because it was the shell's own option terminator for stdin-reading mode (`sh -s`), which is no longer needed when executing a file directly. The script's arguments `-b "$TEMP_PATH" "$TAGPR_VERSION"` are preserved correctly.

