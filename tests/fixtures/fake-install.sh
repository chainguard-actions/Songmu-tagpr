#!/bin/sh
# Fake tagpr install script
# Parses -b <bindir> and <version> args like the real install.sh
BINDIR=""
VERSION=""
while [ $# -gt 0 ]; do
  case "$1" in
    -b)
      BINDIR="$2"
      shift 2
      ;;
    *)
      VERSION="$1"
      shift
      ;;
  esac
done

if [ -z "$BINDIR" ]; then
  BINDIR="/usr/local/bin"
fi

cat > "${BINDIR}/tagpr" << 'EOF'
#!/bin/sh
# Fake tagpr binary for testing
echo "tagpr: running (fake)"
# Output mock values via GITHUB_OUTPUT
if [ -n "$GITHUB_OUTPUT" ]; then
  echo "tag=" >> "$GITHUB_OUTPUT"
  echo "pull_request=" >> "$GITHUB_OUTPUT"
  echo "base_tag=" >> "$GITHUB_OUTPUT"
fi
# Exit 0 to simulate success
exit 0
EOF
chmod +x "${BINDIR}/tagpr"
echo "Installed fake tagpr to ${BINDIR}/tagpr (version: ${VERSION})"
