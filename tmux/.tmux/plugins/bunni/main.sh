# Pomoodoro Timer for Tmux

# sets refresh interval to every 5 seconds
tmux set-option -g status-interval $show_refresh

# Status right
source "HOME/pomodoro.sh"
output=$(wo)
tmux set-option -g status-right "$output"
