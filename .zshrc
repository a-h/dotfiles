# Enable profiling, see end of file for usage.
# zmodload zsh/zprof 

# Use Nix.
export PATH="/run/current-system/sw/bin:$PATH"
# Use my local installs first, where I've overridden something.
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/bin/tinygo/bin:$PATH"
export PATH="/usr/local/bin/:$PATH"
# Go comes next.
export PATH="/usr/local/go:$HOME/go/bin/:$PATH"
# JavaScript.
export PATH=$PATH:~/.npm/bin
# Other tools.
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:/Applications/SnowSQL.app/Contents/MacOS:$PATH"
export PATH=$PATH:/usr/sbin

# Raspberry Pi Pico SDK
export PICO_SDK_PATH=$HOME/github.com/raspberrypi/pico-sdk
export PICO_EXTRAS_PATH=$HOME/github.com/raspberrypi/pico-extras

# Configure aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# Add pass autocomplete.
fpath+="$HOME/dotfiles/autocomplete"
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
# Cache for 1 day.
# comp_last_updated=`date -r ~/.zcompdump +%s` &> /dev/null;
# now=$(date +%s)
# file_age=$((now - comp_last_updated))
# if [[ $file_age -gt 86400 || $file_age -eq 0 ]]; then;
#  echo "Updating completion..."
  complete -C 'aws_completer' aws;
  complete -o nospace -C /run/current-system/sw/bin/xc xc
  compinit;
# else
#  compinit -C;
# fi;

# Use the dotfiles.
if [ ! -f $HOME/.gitconfig ]; then
    ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
fi
if [ ! -f $HOME/.tmux.conf ]; then
    ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
fi
if [ ! -f $HOME/.zshrc ]; then
    ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
fi
if [ ! -f $HOME/.nixpkgs/darwin-configuration.nix ]; then
    ln -s $HOME/dotfiles/.nixpkgs $HOME/.nixpkgs
fi
if [ ! -f $HOME/.mailcap ]; then
    ln -s $HOME/dotfiles/.mailcap $HOME/.mailcap
fi

# Git aliases.
alias gs="git status -s"
alias gl='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'
alias gd="git diff"
alias gp="git push"
alias gu="git pull"

# Configure nix package manager.
if [ -e /Users/adrian/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/adrian/.nix-profile/etc/profile.d/nix.sh; fi 
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

# Configure Nitrokey SSH.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  if command -v gpgconf &> /dev/null
  then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  else
    echo "gpgconf is not installed, skipping starting GPG SSH agent..."
  fi
fi

# Execute profiling, see start of file to load.
# zprof

