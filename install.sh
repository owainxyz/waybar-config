#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config/waybar"

if [ -d "$TARGET" ]; then
    mv "$TARGET" "$TARGET.bak.$(date +%s)"
fi

mkdir -p "$TARGET"
cp "$DIR/config.jsonc" "$TARGET/config.jsonc"
cp "$DIR/style.css" "$TARGET/style.css"

pkill -SIGUSR2 waybar 2>/dev/null || true

echo "done"
