ifndef BUILD_SCOPE
BUILD_SCOPE=dev
endif

PROJECT_IMAGE=vungle/golang:$(BUILD_SCOPE)

build:
	@docker build . -t $(PROJECT_IMAGE)

build-alpine:
	@docker build . -t $(PROJECT_IMAGE) -f Dockerfile.alpine

publish:
	@docker push $(PROJECT_IMAGE)
