.PHONY: do_script

do_script:
	bash script.sh

prerequisites: do_script

target: prerequisites