export PATH=/usr/local/go:/Users/adrian/go/bin/:$PATH
export PATH=/usr/local/bin/:$PATH
export PATH="$PATH:/Users/adrian/.dotnet/tools"
export PATH="$PATH:/Users/adrian/bin"

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
    ln -s $HOME/dotfiles/.nixpkgs/darwin-configuration.nix $HOME/.nixpkgs
fi

# Configure Nitrokey SSH.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Get rid of telemetry.
export SAM_CLI_TELEMETRY=0
export DOTNET_CLI_TELEMETRY_OPTOUT=1

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

# Enable vi mode for zsh.
# See https://dougblack.io/words/zsh-vi-mode.html
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey "${key[Home]}"     beginning-of-line
bindkey "${key[End]}"      end-of-line
bindkey "^[[3~" delete-char

# number of jobs, return code of previous command, current directory, % if not root, or # if root.
PROMPT="%j %? %d %# "

zle -N zle-keymap-select
export KEYTIMEOUT=1

# Configure nix package manager.
if [ -e /Users/adrian/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/adrian/.nix-profile/etc/profile.d/nix.sh; fi 
