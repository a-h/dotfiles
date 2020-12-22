# Use my local installs first, in case I've overridden something.
export PATH="/home/adrian/bin:$PATH"

# Configure aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# Add pass autocomplete.
fpath=(~/zsh-completion $fpath)
autoload -Uz compinit && compinit
complete -C 'aws_completer' aws

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

# number of jobs, return code of previous command, current directory, % if not root, or # if root.
PROMPT="%j %? %d %# "
RPROMPT=""
# Ensure that the prompt doesn't overwrite output that doesn't terminate with a new line.
setopt PROMPT_SP

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
