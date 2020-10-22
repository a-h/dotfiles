# Use my local installs first, where I've overridden something.
export PATH="/Users/adrian/bin:$PATH"
export PATH="/usr/local/bin/:$PATH"
# Next, use Nix.
export PATH="/run/current-system/sw/bin:$PATH"
# Go comes next.
export PATH="/usr/local/go:/Users/adrian/go/bin/:$PATH"
# Other tools.
export PATH="$PATH:/Users/adrian/.dotnet/tools"
export PATH="$PATH:/Applications/SnowSQL.app/Contents/MacOS:$PATH"

# Configure aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# Add pass autocomplete.
fpath=(~/dotfiles/zsh-completion $fpath)
autoload -Uz compinit && compinit

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
if [ ! -f $HOME/.config/nvim/coc-settings.json ]; then
    ln -s $HOME/dotfiles/coc-settings.json $HOME/.config/nvim/coc-settings.json
fi
if [ ! -f $HOME/ssofresh ]; then
    ln -s $HOME/dotfiles/aws/ssofresh.py $HOME/ssofresh
    chmod +x $HOME/ssofresh
fi

# Configure nix package manager.
if [ -e /Users/adrian/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/adrian/.nix-profile/etc/profile.d/nix.sh; fi 

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

export KEYTIMEOUT=1

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

# Configure Nitrokey SSH.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
