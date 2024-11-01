# Use my local installs first, where I've overridden something.
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/bin/tinygo/bin:$PATH"
export PATH="/usr/local/bin/:$PATH"
# Go comes next.
export PATH="/usr/local/go:$HOME/go/bin/:$PATH"
# JavaScript.
export PATH=$PATH:~/.npm/bin
# play.date
export PATH="$PATH:$HOME/Developer/PlaydateSDK/bin"
# Other tools.
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:/Applications/SnowSQL.app/Contents/MacOS:$PATH"
export PATH=$PATH:/usr/sbin
fpath=($HOME/.nix-profile/share/zsh/site-functions $fpath)
fpath=(~/dotfiles/autocomplete $fpath)
# Rancher Desktop.
export PATH="$PATH:$HOME/.rd/bin"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Raspberry Pi Pico SDK.
export PICO_SDK_PATH=$HOME/github.com/raspberrypi/pico-sdk
export PICO_EXTRAS_PATH=$HOME/github.com/raspberrypi/pico-extras

# Playdate SDK config.
export PLAYDATE_SDK_PATH=/Users/adrian/Developer/PlaydateSDK
alias pds="open $PLAYDATE_SDK_PATH/bin/Playdate\ Simulator.app"

# Configure aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# Use the dotfiles.
if [ ! -f $HOME/.gitconfig ]; then
    ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
fi
if [ ! -f $HOME/.tmux.conf ]; then
    ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
fi
if [ ! -f $HOME/.config/nixpkgs/darwin-configuration.nix ]; then
    ln -s $HOME/dotfiles/.config/nixpkgs $HOME/.nixpkgs
fi
if [ ! -f $HOME/.mailcap ]; then
    ln -s $HOME/dotfiles/.mailcap $HOME/.mailcap
fi
if [ ! -d "$HOME/.config/nvim/" ]; then
  ln -s $HOME/dotfiles/.config/nvim $HOME/.config/nvim
fi
if [ ! -d "$HOME/.config/nixpkgs/" ]; then
  ln -sf $HOME/dotfiles/.config/nixpkgs/ ~/.config/
fi
if [ ! -d "$HOME/.config/alacritty/" ]; then
  ln -sf $HOME/dotfiles/.config/alacritty/ ~/.config/
fi

# Git aliases.
alias gs="git status -s"
alias gl='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'
alias gd="git diff"
alias gp="git push"
alias gu="git pull"
alias gcp="git commit && git push"
alias gaacp='git add --all && git status && printf "%s " "Press enter to continue" && read ans && git commit && git push"'

# Take over from the annoying Gnome keyring.
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# Configure globally installed NPM modules to be in a sensible location.
# I don't want any globally installed NPM modules, but CDK is a nuisance.
if [ ! -f $HOME/.npmrc ]; then
  echo "prefix=$HOME/.npm" >> ~/.npmrc
fi

# Enable vi mode for zsh.
# See https://dougblack.io/words/zsh-vi-mode.html
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey "^[[3~" delete-char
# On OSX, might need to update the terminal to send home and end as ctrl-a, ctrle.

# number of jobs, return code of previous command, current directory, % if not root, or # if root.
PROMPT="%j %? %d %# "
RPROMPT=""
# Ensure that the prompt doesn't overwrite output that doesn't terminate with a new line.
setopt PROMPT_SP

export KEYTIMEOUT=1

# Enable colours in ls etc.
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxgggdabagacad

# Get rid of telemetry.
export SAM_CLI_TELEMETRY=0
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Go module proxies mess with private repos. Waiting for https://github.com/golang/go/issues/33985
export GONOSUMDB=*

# Create an alias for listening.
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# Automatically configure direnv.
eval "$(direnv hook zsh)"
