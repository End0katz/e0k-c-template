
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

$(LOG)/testbin.log: $(BIN)
	@echo
	./testbin.bash | tee $@
	@echo

