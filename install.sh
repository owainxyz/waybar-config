#!/bin/sh
set -e

dir=$(cd "$(dirname "$0")" && pwd)
target=${XDG_CONFIG_HOME:-$HOME/.config}/waybar

if [ -d "$target" ]; then
    mv "$target" "$target.bak.$(date +%s)"
fi
mkdir -p "$target"

if [ "$1" = v1 ]; then
    cp "$dir/v1/config.jsonc" "$dir/v1/style.css" "$target/"
    pkill -USR2 waybar 2>/dev/null || true
    echo "v1 installed"
    exit 0
fi

wm=$2
[ "$1" != v2 ] && [ -n "$1" ] && wm=$1
if [ -z "$wm" ]; then
    desk=$(echo "${XDG_CURRENT_DESKTOP:-}" | tr 'A-Z' 'a-z')
    if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then wm=hyprland
    elif [ -n "$NIRI_SOCKET" ]; then wm=niri
    elif [ -n "$SWAYSOCK" ]; then wm=sway
    else
        case $desk in
            *hyprland*) wm=hyprland ;;
            *sway*) wm=sway ;;
            *niri*) wm=niri ;;
            *river*) wm=river ;;
            *dwl*) wm=dwl ;;
            *) wm=other ;;
        esac
    fi
fi
[ -f "$dir/workspaces/$wm.jsonc" ] || { echo "dont know $wm, pick one of: $(ls "$dir/workspaces" | sed 's/.jsonc//' | tr '\n' ' ')"; exit 1; }

cp "$dir/config.jsonc" "$dir/style.css" "$target/"
cp "$dir/workspaces/$wm.jsonc" "$target/workspaces.jsonc"
mkdir -p "$target/scripts"
cp "$dir/scripts/mem.sh" "$target/scripts/"
chmod +x "$target/scripts/mem.sh"

pkill -USR2 waybar 2>/dev/null || true
echo "v2 installed for $wm"
