#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.cwd')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
wk_left=$(echo "$input" | jq -r '100 - (.rate_limits.seven_day.used_percentage // 0) | floor')

printf "[%s] %s | %d%% ctx | \$%.2f session | %d%% wk left\n" \
  "$model" "$cwd" "$ctx_pct" "$cost" "$wk_left"
