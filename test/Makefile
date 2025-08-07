
LOG := ../out/log

NAME ?= unnamed
BIN := ../$(NAME)
SO := ../lib$(NAME).so
A := ../lib$(NAME).a

test: $(LOG)/ log/testbin

.PHONY: test

$(LOG)/:
	mkdir -p $@

log/%: $(LOG)/%.log
	@:

### TESTS

$(LOG)/testbin.log: SHELL:=/bin/bash
$(LOG)/testbin.log: $(BIN) testbin.bash
	@echo
	set -o pipefail; ./testbin.bash | tee $@
	@echo

