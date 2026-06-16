<!-- markdownlint-disable -->

# Hardening Report: Songmu--tagpr/v1.20.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **Songmu--tagpr/v1.20.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

In action.yml, the run block fetches a remote script via curl and pipes it directly to `sh` without first saving it to disk: `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s -- -b "$TEMP_PATH" "$TAGPR_VERSION" 2>&1`. This is unsafe because (1) if the network connection is interrupted mid-stream, a partial script may execute, and (2) the URL path includes `${ACTION_REF}` which is sourced from `${{ github.action_ref }}` — a workflow-controlled value — meaning a caller could potentially influence which remote script is fetched and executed. The script should be downloaded to a temporary file first, verified, and then executed separately.

Locations:

- `action.yml:32`

### script-injection (severity: high)

Sub-rule (b): In action.yml, the env var `ACTION_REF` is set from `${{ github.action_ref }}` (a workflow-controlled expression) and is then interpolated unquoted-within-a-string into a curl URL that is piped directly to `sh`: `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s ...`. While the variable is inside double quotes (preventing word-splitting), the value is still injected into the URL path used to fetch and execute a remote script, allowing a caller controlling `github.action_ref` to influence which script is fetched and run.

Locations:

- `action.yml:32`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection

**Notes:**

Replaced the unsafe `curl -sfL "https://raw.githubusercontent.com/Songmu/tagpr/${ACTION_REF}/install.sh" | sh -s ...` pattern with `sh "${ACTION_PATH}/install.sh" -b "$TEMP_PATH" "$TAGPR_VERSION" 2>&1`, using the `install.sh` script that is already bundled in the action directory. The `ACTION_REF` env var (sourced from `${{ github.action_ref }}`) was removed entirely and replaced with `ACTION_PATH` (sourced from `${{ github.action_path }}`), which provides the local filesystem path to the action directory. This eliminates both the unsafe curl-pipe-to-shell pattern and the script-injection risk from using a workflow-controlled value in a remote URL.

