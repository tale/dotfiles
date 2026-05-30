local base
if [[ -n "$1" ]]; then
	base="$1"
else
	base=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null)
fi

if [[ -z "$base" ]]; then
	echo "No PR found and no base specified, falling back to 'main'"
	base="main"
fi

echo "Rebasing onto origin/$base..."
git fetch origin "$base"
git rebase --committer-date-is-author-date "origin/$base"
