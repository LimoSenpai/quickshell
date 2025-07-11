#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/wallpaper.jpg"
  exit 1
fi

wall="$1"
base="$HOME/.config/quickshell"
scss="$base/scss/colors.scss"
js="$base/js/colors.js"

# Set wallpaper
swww img "$wall"

# Extract colors to SCSS
wallust run "$wall" --template "$base/templates/colors-quickshell.conf" > "$scss"

# Convert SCSS to JS color constants
{
  echo "// AUTO-GENERATED COLORS FROM WALLUST"
  grep -Po '@define-color\s+\K\w+' "$scss" | while read -r name; do
    col=$(grep -Po "@define-color\s+$name\s+#\K[0-9A-Fa-f]{6}" "$scss")
    echo "export const $name = \"#$col\";"
  done
} > "$js"

echo "Theme updated from $wall"
