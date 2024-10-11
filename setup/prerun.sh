#!/bin/bash

# Remove all .current files that may have been left over from a previous run
rm -f .*.current

# Make sure the user has the following dependencies installed
if ! command -v fzf &>/dev/null; then
	echo "fzf could not be found, please install it."
	exit 1
fi

if ! command -v git &>/dev/null; then
	echo "git could not be found, please install it."
	exit 1
fi

if ! command -v shasum &>/dev/null; then
	echo "shasum could not be found, please install it."
	exit 1
fi

if ! command -v bash &>/dev/null; then
	echo "bash could not be found, please install it."
	exit 1
fi

if ! command -v sed &>/dev/null; then
	echo "sed could not be found, please install it."
	exit 1
fi

if ! command -v cat &>/dev/null; then
	echo "cat could not be found, please install it."
	exit 1
fi

if ! command -v python3 &>/dev/null; then
	if ! command -v python &>/dev/null; then
		echo "python could not be found, please install it."
		exit 1
	fi
fi

# Check if the --debug flag is enabled
if [ "$1" == "--debug" ]; then
	echo "Debug mode enabled"
	DEBUG=true

	# Print all the variables in .env.sh that start with GBPM_
	compgen -A variable | while read -r var; do
		if [[ $var == GBPM_* ]]; then
			echo "$var=${!var}"
		fi
	done
fi

# Check if the user is running the script from the correct directory & has the correct dependencies installed
if [ ! -f .env.sh ]; then
	echo "Please run this script from the root directory of the project using the Makefile"
	exit 1
fi
