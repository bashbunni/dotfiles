# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh
export GOROOT=
export GOPATH=~/go
export GPG_TTY=$TTY

# export CARGO=$HOME/.cargo/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:"$HOME/.config/emacs/bin"

# on my hands and knees using nvm so I can write elm.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
# plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'
export PATH="$HOME/.npm/bin:$PATH"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias sourcetmux='tmux source ~/.tmux.conf'
alias lint='golangci-lint run'
alias pj='cd ~/projects/project-management'

# Kitty shortcuts
alias theme="kitty +kitten themes --reload-in=all" # then add theme name
alias icat="kitty +kitten icat"
alias connect="kitty +kitten ssh" # prevent weird keypress handling over ssh
alias olm="libolm"

# Dotfiles management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
# dotfiles are stored in ${HOME}/dotfiles/.config/${PKGNAME}` with GNU stow. Thanks Brandon!
# TODO: link his blog post
# e.g.
# home/
#    /brandon/
#        .config/
#        .local/
#            .share/
#        dotfiles/
#            bash/
#                .bashrc
#                .bash_profile
#                .bash_logout
#            uzbl/
#                .config/
#                    uzbl/
#                        [...some files]
#                .local/
#                    share/
#                        uzbl/
#                            [...some files]
#            vim/
#                .vim/
#                    [...some files]
#                .vimrc

# productivity corner
declare -A pomo_options
pomo_options["work"]="45"
pomo_options["break"]="10"

pomodoro () {
  if [ -n "$1" -a -n "${pomo_options["$1"]}" ]; then
  val=$1
  echo $val | lolcat
  timer ${pomo_options["$val"]}m
  spd-say "'$val' session done"
  fi
}

alias work="pomodoro 'work'"
alias br="pomodoro 'break'"
