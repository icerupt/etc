#
# make ls always use colors and remove uppercase char.
#

function ls --description "list contents of directory"
	set -l ncolumn (tput cols)
	if test "$ncolumn" -gt 100
		set ncolumn (expr '(' $ncolumn '-' 100 ')' '/' 3 '+' 100)
	end
	set -l param -xF --color=always -w $ncolumn
	command ls $param $argv
end

