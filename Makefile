__PREFIX=./asset/tpl-td-w9970/wifi_resetter
__GOOS=$(pwd)
LINUX=$(__PREFIX)
VERSION=$(shell git describe --tags --always --long)

.PHONY: all clean build

all: clean build
	$(warning [${MAKEFLAGS}])

build: linux
	@echo versão: $(VERSION)

clean: $(shell rm -rf $(WINDOWS) $(LINUX) $(DARWIN))

linux: $(LINUX)

$(LINUX):
	env GOPATH=$(echo $__GOOS) GOOS=linux GOARCH=arm64 		\
			go build -v -o $(LINUX) 						\
			-ldflags="-s -w -X main.version=$(VERSION)" 	\
			-gcflags '-m' 									\
			-tags netgo ./startup/main.go