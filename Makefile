__PREFIX=./bin/wifi_resetter
WINDOWS=$(__PREFIX)_windows_amd64.exe
LINUX=$(__PREFIX)_linux_amd64
DARWIN=$(__PREFIX)_macos_amd64
VERSION=$(shell git describe --tags --always --long)

.PHONY: all clean build

all: clean build
	$(warning [${MAKEFLAGS}])
#Jobs paralelos dependendo do número de núcleos do processador

build: windows linux macos
	@echo versão: $(VERSION)

clean: $(shell rm -rf $(WINDOWS) $(LINUX) $(DARWIN))

windows: $(WINDOWS)

linux: $(LINUX)

macos: $(DARWIN)

$(WINDOWS):
	env GOOS=windows GOARCH=amd64 \
			go build -v -o $(WINDOWS) \
			-ldflags="-s -w -X main.version=$(VERSION)"	\
			-gcflags '-m' \
			-tags netgo ./startup/main.go

$(LINUX):
	env GOOS=linux GOARCH=amd64 \
			go build -v -o $(LINUX) \
			-ldflags="-s -w -X main.version=$(VERSION)" \
			-gcflags '-m' \
			-tags netgo ./startup/main.go

$(DARWIN):
	env GOOS=darwin GOARCH=amd64 \
			go build -v -o $(DARWIN) \
			-ldflags="-s -w -X main.version=$(VERSION)" \
			-gcflags '-m' \
			-tags netgo ./startup/main.go