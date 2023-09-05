BUILD_DIR = build/out
GOLANGCI_VERSION = v1.54.1

SHELL=/bin/bash

.PHONY: all

all: build test audit

### Build ###

.PHONY: dep build valami

dep:
	go mod download

build-dev: $(BUILD_DIR)/dev
$(BUILD_DIR)/dev: dep
	go build -gcflags "all=-N -l" -o=$(BUILD_DIR)/dev ./...

build-prod: export CGO_ENABLED=0
build-prod: $(BUILD_DIR)/prod
$(BUILD_DIR)/prod: dep
	go build -o=$(BUILD_DIR)/prod ./...

### QA ###

.PHONY: qa tidy lint test coverage audit

qa: tidy lint test coverage audit

tidy:
	go fmt ./...
	go mod tidy -v

lint:
	golangci-lint run --enable-all

test:
	go test -v -race -buildvcs ./...

coverage:
	go test -v -race -buildvcs -coverprofile=$(BUILD_DIR)/coverage.out ./...
#	go tool cover -html=$(BUILD_DIR)/coverage.out

audit:
	go mod verify
	go vet ./...
	go run honnef.co/go/tools/cmd/staticcheck@latest -checks=all,-ST1000,-U1000 ./...
	go run golang.org/x/vuln/cmd/govulncheck@latest ./...
	go test -race -buildvcs -vet=off ./...

### Misc ###

.PHONY: get-golangci

get-golangci:
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $$(go env GOPATH)/bin $(GOLANGCI_VERSION)
	golangci-lint --version
