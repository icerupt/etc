function simply-run --description "run source code without thinking"
	# need exactly one argument
	if test (count $argv) -ne 1
		die "bad argument: $argv"
	end

	# extract base and suffix name
	set -l name $argv[1]
	set -l suffix (echo -n $name | sed 's/.*\.//g')
	set -l base (basename $name .$suffix)

	# no support for suffix-less name
	if test "$name" = "$suffix"
		die "suffix-less filename not supported"
	end

	# dispatch by suffix name
	switch $suffix
		case cc cpp cxx
			run-cc $name $base
		case '*'
			die "unsupported suffix: $suffix"
	end
end


function run-cc
	set -l input $argv[1]
	set -l output $argv[2]
	set -l outfull (realpath $output)
	set -l flags -std=gnu++14 -O3 -Wall -Wextra

	########## dependency fix begin ##########
	if has_text $input "thread"
		set flags $flags -pthread
	end

	if has_text $input "cairo"
		set flags $flags (lib cairo)
	end
	########## dependency  fix  end ##########

	info "compiling" "clang++ -o $output $input $flags"
	clang++ -o $output $input $flags
	or die "compilation failed"

	info "running" "$outfull"
	eval $outfull
end


function has_text
	set -l file $argv[1]
	set -l text $argv[2]
	cat $file | grep $text > /dev/null
end

function error
	set -l msg $argv[1]
	echo -e "\e[1;31merror:\e[0m" $msg
end

function info
	set -l prompt $argv[1]
	set -l msg $argv[2]
	echo -e "\e[1;32m$prompt: \e[0;35m$msg\e[0m"
end

function die
	set -l msg $argv[1]
	set -l exit_status 1
	if test (count $argv) -gt 1
		set exit_status $argv[2]
	end
	error $msg
	exit $exit_status
end

function lib
	set -l name $argv[1]
	set -l flags (pkg-config --libs --cflags $name)
	echo $flags | sed 's/ \+$//g; s/ /\n/g'
end

