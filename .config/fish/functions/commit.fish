function commit
	git add .
	git commit -vem \#(date -Iseconds) $argv
end
