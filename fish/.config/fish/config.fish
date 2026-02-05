# Places
set -gx GOPATH ~/Developer/Go
set -gx NVIM_PATH /usr/local/bin/nvim
set -gx TERM xterm-256color
set -gx DOTFILES ~/dotfiles
alias firefox="open -a /Applications/Firefox.app"
set -gx EMACSDIR $HOME/.config/emacs
set -gx NIXPKGS_ALLOW_UNFREE 1

alias nix-go="nix-shell -p go"

set ssh "kitty +kitten ssh"

alias g++="g++ -std=c++17"

# source env vars from cli pass manager.
source $HOME/.config/fish/env.fish

# Charm
alias releases="gitty --all-projects --namespace charmbracelet github.com"
function nix-crush
  nix-channel --add https://github.com/nix-community/NUR/archive/main.tar.gz nur
  nix-channel --update
  nix-shell -p '(import <nur> { pkgs = import <nixpkgs> {}; }).repos.charmbracelet.crush'
end

# put /usr/local/bin before /usr/bin
set -gx PATH $PATH /usr/local/go/bin /usr/local/bin /sbin/ /usr/local/opt/sqlite/bin $HOME/.config/emacs/bin $HOME/.npm/bin $GOPATH $GOPATH/bin /opt/homebrew/bin /nix/var/nix/profiles/default/bin/nix /opt/homebrew/opt/llvm/bin

set LDFLAGS -L/opt/homebrew/opt/llvm/lib
set CPPFLAGS -I/opt/homebrew/opt/llvm/include

# Fun
# lolcat $DOTFILES/banner/banner

# Go
set -gx gomt "go mod tidy"
set -gx got "go test ./... -v"
set -gx gor "go run"

# for when Go ignores insteadof directive
# set -gx GOPROXY "https://proxy.golang.org,direct"
set -gx GOPROXY direct
set -gx GOSUMDB off
set -gx GOPRIVATE off

set -x GPG_TTY (tty)
set -x EDITOR nano

# shortcuts
set -x ta "tmux new -A -s"

# git
alias g="git"
alias gd="git diff"
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git pull"
alias latest="git describe --tags --abbrev=0"


# Custom prompt
set fish_greeting
set fish_prompt

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_prompt
    echo (set_color 87d7af)(date +%H:%M:%S) (set_color 87d7ff)(prompt_pwd) (set_color ffafff)(fish_git_prompt) (set_color ffafff)'→ '
end

function fish_greeting
    lolcat ~/banner
end


# I don't remember how this got here.
function gofailed
    go test ./... | rg FAIL: | sed 's/^--- FAIL: //' | sed 's/ ([[:digit:]]*.[[:digit:]]*s)//'
end

function pom
    set split $POMO_SPLIT
    if ! test -n "$split"
        set split $(gum choose "25/5" "50/10" "all done" --header "Choose a pomodoro split.")
    end

    switch $split
        case 25/5
            set work 25m
            set break 5m
        case 50/10
            set work 50m
            set break 10m
        case 'all done'
            return
    end

    timer $work && terminal-notifier -message Pomodoro \
        -title 'Work Timer is up! Take a Break 😊' \
        -sound Crystal

    gum confirm "Ready for a break?" && timer $break && terminal-notifier -message Pomodoro \
            -title 'Break is over! Get back to work 😬' \
        -sound Crystal \
        || pom
end

# Game Development with Love 2D
set -gx love /Applications/love.app/Contents/MacOS/love

# Run crush with nix shell
function crush-func
    # Add the NUR channel.
    nix-channel --add https://github.com/nix-community/NUR/archive/main.tar.gz nur
    nix-channel --update
    
    # Get Crush in a Nix shell.
    nix-shell -p '(import <nur> { pkgs = import <nixpkgs> {}; }).repos.charmbracelet.crush'
end


# Convert ssh-agent output to fish shell (not done by default when you start fish)
eval (ssh-agent -c)

function delve-run
    echo "dlv debug --headless --api-version=2 --listen=127.0.0.1:43000 ." | fish_clipboard_copy
end

function toggle-display
  if command -q jq
    set output "eDP-1"
    set highRes "2880x1920"
    set lowRes "1920x1080"
    
    set width (swaymsg -t get_outputs | jq -r ".[] | select(.name == \"$output\") | .current_mode.width")
    echo $width
    
    if test "$width" = "2880"
      swaymsg output $output resolution $lowRes
    else
      swaymsg output $output resolution $highRes
    end
  else
    echo "jq required and not found on PATH. Run with nix-shell -p jq --run fish then toggle-display. This command has been copied to your clipboard"
    echo "nix-shell -p jq --run fish" | fish_clipboard_copy
  end
end
