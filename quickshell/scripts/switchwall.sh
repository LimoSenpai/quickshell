#!/usr/bin/env bash

wall="$1"
base="$HOME/.config/quickshell"
scss="$base/scss/colors.scss"
js="$base/js/colors.js"
template="$base/templates/colors-quickshell.conf"

# Check if wall exists
[[ -f "$wall" ]] || { echo "❌ Wallpaper not found: $wall"; exit 1; }

# Set wallpaper with swww
swww img "$wall"

# Run wallust with your template to generate SCSS
wallust run "$wall"

# Convert colors.scss to colors.js for QML use
echo "// AUTO-GENERATED COLORS" > "$js"
echo "" >> "$js"

# Define each color variable
grep '@define-color' "$scss" | while read -r line; do
    name=$(echo "$line" | awk '{print $2}')
    hex=$(echo "$line" | grep -oE '#[0-9a-fA-F]{6}')
    echo "var $name = \"$hex\";" >> "$js"
done

# Now generate the function
echo "" >> "$js"
echo "function getColors() {" >> "$js"
echo "    return {" >> "$js"

grep '@define-color' "$scss" | while read -r line; do
    name=$(echo "$line" | awk '{print $2}')
    echo "        $name: $name," >> "$js"
done

echo "    };" >> "$js"
echo "}" >> "$js"



echo "✅ Wallpaper and theme applied from: $wall"
