#!/bin/sh
# stax installer — downloads the latest release from glassa-work/stax-cli and
# installs it to /usr/local/bin (falls back to ~/.local/bin without sudo).
set -eu

REPO="glassa-work/stax-cli"
BIN="stax"

# ── platform detection ──
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$OS" in
  darwin|linux) ;;
  *) echo "stax: unsupported OS '$OS' (darwin/linux only)" >&2; exit 1 ;;
esac
case "$ARCH" in
  x86_64|amd64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "stax: unsupported architecture '$ARCH'" >&2; exit 1 ;;
esac

# ── latest release tag ──
TAG="${STAX_VERSION:-}"
if [ -z "$TAG" ]; then
  TAG="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')"
fi
if [ -z "$TAG" ]; then
  echo "stax: could not resolve the latest release tag" >&2; exit 1
fi

ASSET="stax-${OS}-${ARCH}.tar.gz"
URL="https://github.com/$REPO/releases/download/$TAG/$ASSET"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
echo "stax: downloading $URL"
curl -fsSL "$URL" -o "$TMP/$ASSET"
tar -xzf "$TMP/$ASSET" -C "$TMP"

# ── checksum verify (best-effort) ──
SUMS_URL="https://github.com/$REPO/releases/download/$TAG/checksums.txt"
if curl -fsSL "$SUMS_URL" -o "$TMP/checksums.txt" 2>/dev/null; then
  EXPECTED="$(grep " $ASSET\$" "$TMP/checksums.txt" | awk '{print $1}')"
  if [ -n "$EXPECTED" ]; then
    if command -v shasum >/dev/null 2>&1; then
      ACTUAL="$(shasum -a 256 "$TMP/$ASSET" | awk '{print $1}')"
      if [ "$ACTUAL" != "$EXPECTED" ]; then
        echo "stax: checksum mismatch — aborting" >&2; exit 1
      fi
      echo "stax: checksum verified"
    fi
  fi
fi

# ── install ──
DEST="/usr/local/bin"
if [ ! -w "$DEST" ]; then
  DEST="$HOME/.local/bin"
  mkdir -p "$DEST"
fi
install -m 0755 "$TMP/$BIN" "$DEST/$BIN"
echo "stax: installed to $DEST/$BIN"

case ":$PATH:" in
  *":$DEST:"*) ;;
  *) echo "stax: add $DEST to your PATH" ;;
esac

"$DEST/$BIN" --version || true
