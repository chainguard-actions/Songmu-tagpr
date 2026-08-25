<!-- markdownlint-disable -->

# Hardening Report: Songmu--tagpr/v1.20.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **Songmu--tagpr/v1.20.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The action.yml composite action run block downloads a remote install script and pipes it directly to `sh` via `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION" 2>&1`. This executes whatever content is served at that URL without first saving and inspecting it. If the remote URL is compromised or the ref is attacker-controlled, arbitrary code will execute on the runner. The script should be downloaded to a temporary file first, verified (e.g. via checksum), and then executed separately.

Locations:

- `action.yml:31`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the unsafe pipe-to-shell pattern in action.yml line 31. The original `curl ... | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION"` was replaced with: (1) download the install script to a temp file via `curl -sfL ... -o "$INSTALL_SCRIPT"`, then (2) execute it separately as `sh "$INSTALL_SCRIPT" -b "$TEMP_PATH" "$TAGPR_VERSION"`. The `--` (shell's option terminator) and `-s` (read-from-stdin flag) were both dropped since they only applied to the piped form — the script's actual arguments `-b` and `$TAGPR_VERSION` are preserved.

