SHELL := /bin/bash

clean_previous: 
	@chmod +x src/main.sh
	@rm -rf .*.current
run: clean_previous
	@bash src/main.sh --run
debug: clean_previous
	@bash src/main.sh --debug --run
search: clean_previous
	@bash src/main.sh --search
