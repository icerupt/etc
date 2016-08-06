set -l name "acbox.0"
if [ "$fish_user_environment" != "$name" ]
	set -U fish_color_host			-o cyan
	set -U fish_color_status		red
	set -U fish_color_user			-o green
	set -U fish_user_environment	$name
end

if [ -z "$TMUX" ]
	set -x TERM xterm-256color
else
	set -x TERM screen-256color
end
set -x DIFFPROG vim

