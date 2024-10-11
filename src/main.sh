#!/bin/bash

# Remove all .current files that may have been left over from a previous run
rm -f .*.current

# Load the configuration file and helper functions
source .env.sh
source src/helpers.sh

# Run the setup/prerun.sh script
source setup/prerun.sh

function run_script {

	# Ask the user for their name (give them a dropdown list to scroll through with the arrow keys)
	# https://stackoverflow.com/a/6779351 for the `read` command trick
	OPTIONS=$(cat options.fzf)
	USERS=$(cat users.fzf.env)
	echo "$USERS" | grep 'user:' | sed 's/user://g' | fzf --preview 'echo "Make a change as {}"' --header="Start typing a name to select a user..." --header-first >.user.current
	log "Completing actions as: $(cat .user.current)"

	# Ask the user what they want to do
	OPTIONS=$(cat options.fzf)
	echo "$OPTIONS" | grep 'action:' | sed 's/action://g' | fzf --preview 'echo "Complete the task: {}"' --header="Start typing to select an action..." --header-first >.action.current
	log "Completing the task: $(cat .action.current)"

	# Ask for the SN of the property to act on
	PROPERTY=$(cat index.flat | sed 's/property://g')
	echo "$PROPERTY" | fzf --preview 'echo "Select {} as the property you are dealing with"' --header="Start typing to search for a Serial Number..." --header-first >.property.current
	log "Property selected: $(cat .property.current)"

	# If .property.current is empty, ask the user to add a new property identifier (max of 2 attempts)
	if [ ! -s .property.current ]; then
		echo "No property selected. Please add a new property identifier."
		read -p "Enter the new property identifier: " NEW_PROPERTY
		echo "What is the model name of the new property?"
		read -p "Model name: " MODEL_NAME
		echo "Who is the owner of the new property?"
		read -p "Owner: " TYPICAL_OWNER
		echo "What is the typical location of the new property?"
		read -p "Location: " TYPICAL_LOCATION
		echo "Please confirm: $NEW_PROPERTY is a $MODEL_NAME owned by $TYPICAL_OWNER and is typically located at $TYPICAL_LOCATION"
		echo "Is this information correct?"
		read -p "[Y]/n: " CONFIRM
		if [ "$CONFIRM" == "n" ]; then
			echo "Select where you would like to make a change:"
			OPTIONS=$(cat options.fzf)
			echo "$OPTIONS" | grep 'error_entry:' | sed 's/error_entry://g' | fzf --preview 'echo "The error is related to the {}"' >.error.current

			# case statement to handle the different error entries
			case $(cat .error.current) in
			'error_entry:Model Name')
				echo "What is the model name of the new property?"
				read -p "Model name: " MODEL_NAME
				;;
			"error_entry:Owner")
				echo "Who is the owner of the new property?"
				read -p "Owner: " TYPICAL_OWNER
				;;
			"error_entry:Location")
				echo "What is the typical location of the new property?"
				read -p "Location: " TYPICAL_LOCATION
				;;
			*)
				echo "Invalid option"
				;;
			esac
			echo "Please confirm: $NEW_PROPERTY is a $MODEL_NAME owned by $TYPICAL_OWNER and is typically located at $TYPICAL_LOCATION"
			read -p "[Y]/n: " CONFIRM
			if [ "$CONFIRM" == "n" ]; then
				echo "Please run the script again to make the necessary changes."
				exit 1
			else

				# Ask, confirm, and set the new property identifier
				echo $NEW_PROPERTY >.property.current
				echo $NEW_PROPERTY >>index.flat
				echo "New property identifier added: $NEW_PROPERTY is a $MODEL_NAME owned by $TYPICAL_OWNER and is typically located at $TYPICAL_LOCATION"
			fi
		else
			log "New property identifier added: $NEW_PROPERTY is a $MODEL_NAME owned by $TYPICAL_OWNER and is typically located at $TYPICAL_LOCATION"

			# Ask, confirm, and set the new property identifier:
			echo $NEW_PROPERTY >.property.current

			# Append the new property identifier to the index.flat file
			echo $NEW_PROPERTY >>index.flat
		fi
	else
		log "Property selected: $(cat .property.current)"
	fi

	# Ask the user for the owner of the property
	# if [ ! -s .owners.current ||  ]; then
	OWNERS=$(cat owners.fzf.env)
	echo "$OWNERS" | grep 'owner:' | sed 's/owner://g' | fzf --preview 'echo "Owner: {}"' --header="Start typing to search for an owner..." --header-first >.owner.current
	log "Owner of the property: $(cat .owner.current)"

}

# Parse the command line arguments
for arg in "$@"; do
	case $arg in
	--search)
		search
		exit 0
		;;
	-s)
		search
		exit 0
		;;
	--help)
		echo "Usage: ./make.sh [-hs]"
		echo "  -h, --help  Display help"
		echo "  -s, --search Search for a string in the git log and in the database"
		exit 0
		;;
	-h)
		echo "Usage: ./make.sh [-hs]"
		echo "  -h, --help  Display help"
		echo "  -s, --search Search for a string in the git log and in the database"
		exit 0
		;;
	-r)
		run_script
		;;
	--run)
		run_script
		;;
	-d)
		DEBUG=true
		;;
	--debug)
		DEBUG=true
		;;
	*)
		echo "Invalid option: $OPTARG" 1>&2
		exit 1
		;;
	esac
done

# Dont commit if we're in debug mode --debug
if [ "$DEBUG" == "true" ]; then
	echo "Completed actions as: $(cat .user.current) on $(cat .property.current) which is owned by $(cat .owner.current)"
else
	# Append what we did and the date to the history.flat file 
	echo "$(date) - $(cat .user.current) - $(cat .action.current) - $(cat .property.current) - $(cat .owner.current)" >>history.flat
	# Commit the changes to the git repository using the .current files
	git add index.flat history.flat
	git commit -m "Completed actions as: $(cat .user.current) on $(cat .property.current) which is owned by $(cat .owner.current)"
fi

# Delete the .current files
rm -f .*.current
