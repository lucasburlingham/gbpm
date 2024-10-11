#!/bin/bash

function log() {
	# Log a message to the .log.current file so we can use it as a git commit message but don't print to the console
	echo -e "- $1" >>.log.current

	# Print the message to the console
	echo -e "$1"
}

function search {
	# Search for a property in the index.flat file and in the git log
	echo "Search for a string in the log file"
	read -p "Enter the string to search: " search_string
	git log --all -i --grep="$search_string">.search_results.current

	# if the search results are empty, print a message to the console
	if [ ! -s .search_results.current ]; then
		echo "No results found for query \"$search_string\""
	else
		# Print the search results to the console
		cat .search_results.current
	fi

	# remove the search results file
	rm .*.current
}
