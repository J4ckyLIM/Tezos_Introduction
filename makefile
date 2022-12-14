ifndef LIGO
	LIGO = docker run --rm -v "${PWD}":"${PWD}" -w "${PWD}" ligolang/ligo:0.57.0
endif

default: help

compile = $(LIGO) compile contract ./src/contracts/$(1) -o ./src/compiled/$(2)
testing = $(LIGO) run test ./tests/$(1)

help:
		@echo "Usage: make [target]"
		@echo "Targets:"
		@echo "  compile: Compiles the contracts"
		@echo "  test:    Runs the tests"
		@echo "  clean:   Removes compiled contracts"

compile:
		@echo "Compiling..."
		@$(call compile,main.mligo,main.tz)

test: test-ligo test-integration

test-ligo: 
		@echo "Testing Ligo..."
		@$(call testing,main.mligo)
		@echo "Testing Ligo... Successful"

test-integration:
		@echo "Testing integration..."

clean:
		@echo "Cleaning..."
		@rm -rf ./src/compiled/*