ifndef BUILD_SCOPE
BUILD_SCOPE=dev
endif

PROJECT_IMAGE=vungle/golang:$(BUILD_SCOPE)

.PHONY: all test clean

build:
	@docker build . -t $(PROJECT_IMAGE)

build-alpine:
	@docker build . -t $(PROJECT_IMAGE) -f Dockerfile.alpine

publish:
	@docker push $(PROJECT_IMAGE)

test:
	@echo "Verify Go version"
	@docker run --rm \
	$(PROJECT_IMAGE) \
	go version | grep $$(cat test/version)
	@echo "Verify Go compilation"
	@docker run --rm \
	-v `pwd`/test/cmd:/var/test \
	$(PROJECT_IMAGE) \
	go run /var/test/mustcompile.go