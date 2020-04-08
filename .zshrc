export PATH=/usr/local/go:/Users/adrian/go/bin/:$PATH
export PATH=/usr/local/bin/:$PATH
export PATH="$PATH:/Users/adrian/.dotnet/tools"
export PATH="$PATH:/Users/adrian/bin"

# Set the prompt.
NT_PROMPT_SYMBOL=❱

function precmd(){
  autoload -U add-zsh-hook
  setopt prompt_subst

  PROMPT='${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}%(?.%F{green}${NT_PROMPT_SYMBOL}%f.%F{red}${NT_PROMPT_SYMBOL}%f) '

  if [[ "$NT_HIDE_EXIT_CODE" == '1' ]]; then
          RPROMPT=''
  else
          RPROMPT='%(?..%F{red}%B%S  $?  %s%b%f)'
  fi
}

# Configure Nitrokey SSH.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Use brewed vim.
alias vi=/usr/local/bin/nvim
alias vim=/usr/local/bin/nvim

# Get rid of telemetry.
export SAM_CLI_TELEMETRY=0
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Java configuration.
export JAVA_HOME=$(/usr/libexec/java_home)

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

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1
