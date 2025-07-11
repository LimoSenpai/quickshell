#!/usr/bin/env bash

# ── Paths ─────────────────────────────────────────────────────────────────────
base="$HOME/.config/quickshell"
qs="$base/scss/colors.scss"
js="$base/js/colors.js"
template="$base/templates/colors-quickshell.conf"

# ── Helper to pull the CURRENT wallpaper from swww ────────────────────────────
get_wall() {
  swww query \
    | grep 'currently displaying:' \
    | head -n1 \
    | sed -E 's/^.*currently displaying: image: (.*)$/\1/'
}

initial_wall="$(get_wall)"
echo "🖼️ Starting watcher (initial = $initial_wall)"
waypaper &

while true; do
  sleep 0.5
  current_wall="$(get_wall)"
  if [[ "$current_wall" != "$initial_wall" && -f "$current_wall" ]]; then
    echo "✅ Detected new wallpaper: $current_wall"
    pkill -f waypaper    # ← kills any process with "waypaper" in its cmdline
    break
  fi
done

# ── Now run your theme pipeline ─────────────────────────────────────────────
wall="$current_wall"
swww img "$wall"                           # reinforce consistency
wallust run "$wall"
echo "🎨 Converting hex → rgba…"
python3 "$HOME/.config/hypr/scripts/hex2rgba.py"

# ── Build colors.js from colors.scss ────────────────────────────────────────
echo "// AUTO-GENERATED COLORS" > "$js"
echo >> "$js"
grep '@define-color' "$qs" | while read -r line; do
  name=$(awk '{print $2}' <<<"$line")
  hex=$(grep -oE '#[0-9A-Fa-f]{6}' <<<"$line")
  echo "var $name = \"$hex\";" >> "$js"
done

echo >> "$js"
cat <<'EOF' >> "$js"
function getColors() {
    return {
EOF

grep '@define-color' "$qs" | while read -r line; do
  name=$(awk '{print $2}' <<<"$line")
  echo "        $name: $name," >> "$js"
done

cat <<'EOF' >> "$js"
    };
}
EOF

# ── Reload QuickShell ────────────────────────────────────────────────────────
echo "🔄 Reloading QuickShell…"
pkill quickshell
sleep 1
quickshell -d &

echo "🎉 Done! Wallpaper + theme applied from: $wall"
