# Bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# cd # Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Commands I forget about all the time
# docker rmi -f $(docker images -a -q)
# psql -h localhost -p 5432 -U scengen -d scengen_meta
# docker exec -it scengen_postgres_1 bash

# Override $PS1 bc want to confirm in prestage AND name is too long
# export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
export PS1="ben@local \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

# Function to update the prompt based on virtual environment status
update_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Add (venv) only if it’s not already in the prompt
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

# Set PROMPT_COMMAND to run update_prompt before displaying each prompt
PROMPT_COMMAND=update_prompt

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
source ~/dev/.git-completion.bash

# LLM
alias ca="cursor-agent"
alias clod="claude"

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
