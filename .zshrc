# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export CARGO=$HOME/.cargo/bin
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$CARGO
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'
export PATH="$HOME/.npm/bin:$PATH"

# Aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
echo "$(cat $HOME/banner)" | lolcat
# figlet -f standard "bashbunni" | lolcat
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
alias stream='cd ~/Documents/Hobbies/'
alias bb='cd ~/Documents/bashbunni'
alias notes='cd ~/Documents/Hobbies/dev-notebook'
alias config='nvim ~/.config/nvim/init.vim'
alias luaconf='nvim ~/.config/nvim/lua/bashbunni.lua'
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias sourcetmux='tmux source ~/.tmux.conf'
