local new_branch="${1:?Usage: git-stack-new <new-branch> [base|pr/<number>]}"
local base_arg="$2"
local base

if [[ -z "$base_arg" ]]; then
	base=$(gh pr view --json headRefName -q .headRefName 2>/dev/null)
	if [[ -z "$base" ]]; then
		base=$(git branch --show-current)
	fi
elif [[ "$base_arg" == pr/* ]]; then
	local pr_number="${base_arg#pr/}"
	base=$(gh pr view "$pr_number" --json headRefName -q .headRefName)
else
	base="$base_arg"
fi

echo "Stacking onto $base"
git fetch origin "$base"
git checkout "origin/$base" -b "$new_branch"
