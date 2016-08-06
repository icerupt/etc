function wrap --description 'wrap a command line application in rlwrap'
	set -l sh $argv[1]
	set -l prompt $sh
	if test (count $argv) = 2
		set prompt $argv[2]
	end
	rlwrap -S "$prompt"'$ ' -pblue $sh
end
