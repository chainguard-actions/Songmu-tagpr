<!-- markdownlint-disable -->

# Hardening Report: Songmu--tagpr/v1.20.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **Songmu--tagpr/v1.20.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

In action.yml, the composite action's run block downloads a remote install script and pipes it directly to `sh` without first saving it to a file for inspection: `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION" 2>&1`. This allows arbitrary code execution if the remote URL is compromised or if ACTION_REF (derived from github.action_ref) is manipulated to point to a malicious ref.

Locations:

- `action.yml:32`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the unsafe pipe-to-shell pattern in action.yml line 32. Changed from `curl ... | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION"` to downloading the script to a temp file first (`curl -o "$INSTALL_SCRIPT"`) and then executing it separately (`sh "$INSTALL_SCRIPT" -b "$TEMP_PATH" "$TAGPR_VERSION"`). The `--` shell option terminator was correctly dropped since it was part of the pipe form's `sh -s --` syntax, not an argument to the install script itself.

