local sel=$(fc -rl 1 | fzf --tiebreak=index --height=50%)
if [[ -n $sel ]]; then
	sel=$(echo $sel | sed -E 's/^[[:space:]]*[0-9]+[*+]?[[:space:]]+//')
	LBUFFER=$sel
fi
zle redisplay
