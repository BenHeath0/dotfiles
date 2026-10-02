# git worktrees live outside the checkout at ~/Developer/worktrees/<repo>/<branch>
# usage: wta <branch> [base]   (base defaults to the remote's default branch)
wta() {
  local branch=$1 base=${2:-origin/HEAD} common dir
  [[ -z $branch ]] && { echo "usage: wta <branch> [base]"; return 1; }
  common=$(git rev-parse --path-format=absolute --git-common-dir) || return 1
  dir=~/Developer/worktrees/${${common%/.git}:t}/$branch
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$dir" "$branch"
  else
    # --no-track so the new branch doesn't treat stage/master as its upstream
    git fetch --quiet origin && git worktree add --no-track -b "$branch" "$dir" "$base"
  fi && cd "$dir"
}

# usage: wtc [branch]   (no branch = back to the main checkout)
wtc() {
  local common
  common=$(git rev-parse --path-format=absolute --git-common-dir) || return 1
  cd ${1:+~/Developer/worktrees/${${common%/.git}:t}/}${1:-${common%/.git}}
}
_wtc() {
  local -a branches
  branches=(${(f)"$(git worktree list --porcelain 2>/dev/null | sed -n 's|^branch refs/heads/||p' | tail -n +2)"})
  compadd -a branches
}
compdef _wtc wtc
