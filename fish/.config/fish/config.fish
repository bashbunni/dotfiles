# Places
set -gx GOPATH ~/Developer/Go
set -gx NVIM_PATH /usr/local/bin/nvim
set -gx TERM xterm-256color
set -gx DOTFILES ~/dotfiles
alias firefox="open -a /Applications/Firefox.app"

set ssh "kitty +kitten ssh"

alias g++="g++ -std=c++17"

# source env vars from cli pass manager.
source $HOME/.config/fish/env.fish

# Charm
alias releases="gitty --all-projects --namespace charmbracelet github.com"

# put /usr/local/bin before /usr/bin
set -gx PATH $PATH /usr/local/go/bin /usr/local/bin /sbin/ /usr/local/opt/sqlite/bin $HOME/.config/emacs/bin $HOME/.npm/bin $GOPATH $GOPATH/bin /opt/homebrew/bin /nix/var/nix/profiles/default/bin/nix /opt/homebrew/opt/llvm/bin

set LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

# Fun
# lolcat $DOTFILES/banner/banner

# Go
set -gx gomt "go mod tidy"
set -gx got "go test ./... -v"
set -gx gor "go run"

# for when Go ignores insteadof directive
# set -gx GOPROXY "https://proxy.golang.org,direct"
set -gx GOPROXY "direct"
set -gx GOSUMDB "off"
set -gx GOPRIVATE "off"

set -x GPG_TTY (tty)
set -x EDITOR nvim

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
    echo (set_color 87d7af)(date +%H:%M:%S) (set_color 87d7ff)(prompt_pwd) (set_color ffafff)'→ '
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
        set split $(gum choose "25/5" "50/10" --header "Choose a pomodoro split.")
    end

    switch $split
       case '25/5'
           set work "25m"
           set break "5m"
       case '50/10'
           set work "50m"
           set break "10m"
    end

    timer $work && terminal-notifier -message 'Pomodoro'\
        -title 'Work Timer is up! Take a Break 😊'\
        -sound Crystal

    timer $break && terminal-notifier -message 'Pomodoro'\
        -title 'Break is over! Get back to work 😬'\
        -sound Crystal
end
