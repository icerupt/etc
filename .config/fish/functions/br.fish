function br --description 'Break into lists by spaces.'
	sed 's/^ \+//g; s/ \+$//g; s/ /\n/g'
end
