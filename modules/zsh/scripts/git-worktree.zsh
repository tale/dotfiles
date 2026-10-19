set -e

is_new=0
if [[ "$1" == -n ]]; then
  is_new=1
  shift
fi

if (( $# != 1 )) || [[ "$1" == -* ]]; then
  print -u2 'Usage: git-worktree [-n] <branch>'
  exit 1
fi

branch=$1
git check-ref-format "refs/heads/$branch"
git rev-parse --git-common-dir > /dev/null

main_root=
while IFS= read -r -d '' field; do
  case "$field" in
    worktree\ *)
      dir=${field#worktree }
      main_root=${main_root:-$dir}
      ;;
    "branch refs/heads/$branch")
      if [[ ! -d "$dir" ]]; then
        print -u2 "Worktree missing: $dir"
        exit 1
      fi
      print -r -- "$dir"
      exit 0
      ;;
  esac
done < <(git worktree list --porcelain -z)

default=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null) || default=main
default=${default#origin/}
if [[ "$branch" == "$default" ]]; then
  print -u2 "Default branch is not checked out in the primary worktree: $main_root"
  exit 1
fi

dir="${main_root}@${branch//\//-}"
if git show-ref --verify --quiet "refs/heads/$branch"; then
  git worktree add "$dir" "$branch" >&2
elif (( is_new )); then
  git fetch origin "$default" >&2
  git worktree add -b "$branch" "$dir" "origin/$default" >&2
else
  git fetch origin "$branch" >&2
  git worktree add --track -b "$branch" "$dir" "origin/$branch" >&2
fi

print -r -- "$dir"
