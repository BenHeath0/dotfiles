# Enable zsh completion system
autoload -Uz compinit && compinit

# Add local bin to PATH (for poetry, pipx, etc.)
export PATH="$PATH:/Users/benheath/.local/bin"

# Git branch in prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Commands I forget about all the time
# docker rmi -f $(docker images -a -q)
# psql -h localhost -p 5432 -U scengen -d scengen_meta
# docker exec -it scengen_postgres_1 bash

# Set up prompt (zsh uses PROMPT instead of PS1, but PS1 also works)
# Note: In zsh, %n=username, %m=hostname, %1~=current directory (just basename)
# Using PS1 for compatibility, but you can use PROMPT as well
setopt PROMPT_SUBST
export PS1='ben@local %1~%F{green}$(parse_git_branch)%f $ '

# Function to update the prompt based on virtual environment status
update_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Add (venv) only if it's not already in the prompt
        if [[ "$PS1" != "(venv) "* ]]; then
            PS1="(venv) ${ORIGINAL_PS1:-$PS1}"
        fi
    else
        # Reset PS1 if the virtual environment is deactivated
        PS1="${ORIGINAL_PS1:-$PS1}"
    fi
}

# Save the original PS1 to restore later
ORIGINAL_PS1=$PS1

# Set precmd hook to run update_prompt before displaying each prompt
# In zsh, we use precmd instead of PROMPT_COMMAND
precmd() {
    update_prompt
}

# docker
alias dockerps="docker ps  --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"
alias dc="docker compose"

# K8s
alias k="kubectl"
alias kg="kubectl get"
alias kl="kubectl logs"

# Git
alias g="git"
alias push="git push origin head"

# Git Completion
# source ~/dotfiles/.git-completion.zsh

# LLM
alias ca="cursor-agent"
alias clod="claude"
alias dot="cd ~/dotfiles"

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    if ! IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)); then
      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    if ! IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)); then

      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

# Source machine-specific config if it exists
[[ -f ~/dotfiles/.zshrc.local ]] && source ~/dotfiles/.zshrc.local

export PATH="/opt/homebrew/opt/python@3.11/bin:$PATH"
