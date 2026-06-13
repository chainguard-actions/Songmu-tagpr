<!-- markdownlint-disable -->

# Hardening Report: Songmu--tagpr/v1.18.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **Songmu--tagpr/v1.18.3** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The run: block in action.yml downloads a remote install script and pipes it directly to `sh` for execution: `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION" 2>&1`. This is unsafe because the script is never saved to disk for inspection, and if the remote URL is compromised or the ref is attacker-controlled, arbitrary code will execute on the runner. The script should be downloaded to a file first, verified (e.g., via checksum), and then executed separately.

Locations:

- `action.yml:31`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Replaced the unsafe `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s -- ...` pattern with `sh "${{ github.action_path }}/install.sh" -b "$TEMP_PATH" "$TAGPR_VERSION" 2>&1`. The `install.sh` script is already bundled in the action directory (confirmed by listing the directory), so it can be executed directly without downloading from the internet. The `ACTION_REF` environment variable was also removed since it was only used to construct the remote URL and is no longer needed.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Replaced `${{ github.action_path }}` in the run: block with `${GITHUB_ACTION_PATH}` (the pre-set environment variable automatically provided by GitHub Actions). This eliminates the script-injection risk where the expression was being substituted into the shell command string before shell parsing. No other changes were needed.

