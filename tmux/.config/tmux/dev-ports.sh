#!/bin/sh
# Show active dev server ports in the tmux status bar.
# Called by tmux every status-interval (2s).
# Ports are colored by the tmux window whose pane owns the process.
#
# Monitored port ranges:
#   3000-3009  Next.js, React, Vite defaults
#   3030-3039  misc dev servers
#   3130-3139  Nuxt defaults
#   3330-3339  Sanity Studio (default 3333)
#   4321       Astro
#   4330-4339  misc dev servers
#   5170-5179  Vite (default 5173)
#   8000-8009  Gatsby, Django, misc
#   8080-8089  alt HTTP servers
#   9090-9099  misc dev servers

# Window index -> color (matches tmux.conf.local)
color_for_window() {
  case "$1" in
    1) echo "#d97a5b" ;; # orange
    2) echo "#a6e3a1" ;; # green
    3) echo "#cba6f7" ;; # mauve
    4) echo "#f9e2af" ;; # yellow
    5) echo "#f38ba8" ;; # pink
    6) echo "#94e2d5" ;; # teal
    *) echo "#6c7086" ;; # gray
  esac
}

# Build a map of PID -> window index from tmux panes
pane_map=$(tmux list-panes -a -F '#{pane_pid} #{window_index}' 2>/dev/null)

# Walk up process tree to find which tmux pane owns a PID
find_window() {
  pid=$1
  while [ "$pid" -gt 1 ] 2>/dev/null; do
    win=$(echo "$pane_map" | awk -v p="$pid" '$1==p {print $2; exit}')
    if [ -n "$win" ]; then
      echo "$win"
      return
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  done
}

# Get port+PID pairs for dev ports
port_pids=$(lsof -iTCP -sTCP:LISTEN -nP 2>/dev/null \
  | awk 'NR>1 {split($9,a,":"); port=a[length(a)]; if(port+0>0) print port, $2}' \
  | sort -t' ' -k1,1 -un)

[ -z "$port_pids" ] && exit 0

result=""
while read -r port pid; do
  # Filter to monitored ranges
  case 1 in
    $(( (port>=3000 && port<=3009) || (port>=3030 && port<=3039) || (port>=3130 && port<=3139) || (port>=3330 && port<=3339) || port==4321 || (port>=4330 && port<=4339) || (port>=5170 && port<=5179) || (port>=8000 && port<=8009) || (port>=8080 && port<=8089) || (port>=9090 && port<=9099) )) )
      win=$(find_window "$pid")
      col=$(color_for_window "$win")
      if [ -n "$result" ]; then
        result="${result}#[fg=#6c7086],#[fg=${col}]${port}"
      else
        result="#[fg=${col}]${port}"
      fi
      ;;
  esac
done <<EOF
$port_pids
EOF

[ -n "$result" ] && printf "#[fg=#6c7086]servers %s " "$result"
