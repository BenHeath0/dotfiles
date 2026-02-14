#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
dir=$(basename "$cwd")

branch=$(cd "$cwd" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

context_bar=''
if [ -n "$used_pct" ]; then
  used_int=${used_pct%.*}
  filled=$((used_int / 5))
  empty=$((20 - filled))
  bar=''
  for ((i = 0; i < filled; i++)); do bar+='▓'; done
  for ((i = 0; i < empty; i++)); do bar+='░'; done
  context_bar=" [${bar} ${used_pct}%]"
fi

printf '%s (%s)%s' "$dir" "$branch" "$context_bar"
