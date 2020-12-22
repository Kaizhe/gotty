.PHONY: all build push 

all: build push 

build:
	@echo "+ $@"
	./scripts/build
push:
	@echo "+ $@"
	./scripts/push
