#!/bin/bash

input=$(cat)

# Extract data from JSON
model=$(echo "$input" | jq -r '.model.display_name // empty')
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_total=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

output=""

# 1. Model name
if [ -n "$model" ]; then
  output="$model"
fi

# 2. Context window usage as visual bar
if [ -n "$context_used" ]; then
  # Create a 10-character bar (5 filled blocks per 50%)
  filled=$(printf "%.0f" "$(echo "$context_used / 10" | bc -l)")
  empty=$((10 - filled))
  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}▓"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done
  [ -n "$output" ] && output="$output │"
  output="$output [$bar] $(printf '%.0f' "$context_used")%"
fi

# Helper function to format time remaining
format_time_remaining() {
  local reset_time=$1
  if [ -z "$reset_time" ] || [ "$reset_time" = "null" ]; then
    echo ""
    return
  fi
  local now=$(date +%s)
  local diff=$((reset_time - now))
  
  if [ $diff -le 0 ]; then
    echo "now"
  elif [ $diff -lt 3600 ]; then
    printf "%dm" $((diff / 60))
  elif [ $diff -lt 86400 ]; then
    printf "%dh%dm" $((diff / 3600)) $(( (diff % 3600) / 60 ))
  else
    printf "%dd%dh" $((diff / 86400)) $((( diff % 86400) / 3600))
  fi
}

# 3. Session limit (5-hour)
if [ -n "$five_hour_pct" ] && [ "$five_hour_pct" != "null" ]; then
  time_remaining=$(format_time_remaining "$five_hour_reset")
  [ -n "$output" ] && output="$output │"
  output="$output 5h: $(printf '%.0f' "$five_hour_pct")%"
  if [ -n "$time_remaining" ]; then
    output="$output ($time_remaining)"
  fi
fi

# 4. Weekly limit (7-day)
if [ -n "$seven_day_pct" ] && [ "$seven_day_pct" != "null" ]; then
  time_remaining=$(format_time_remaining "$seven_day_reset")
  [ -n "$output" ] && output="$output │"
  output="$output 7d: $(printf '%.0f' "$seven_day_pct")%"
  if [ -n "$time_remaining" ]; then
    output="$output ($time_remaining)"
  fi
fi

echo "$output"
