function words --description 'Run command and break the output into list by spaces.' --argument command
	(eval $command) | br
end
