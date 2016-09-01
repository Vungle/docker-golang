ifndef BUILD_SCOPE
BUILD_SCOPE=dev
endif

PROJECT_IMAGE=vungle/golang:$(BUILD_SCOPE)

build:
	@docker build . -t $(PROJECT_IMAGE)

publish:
	@docker push $(PROJECT_IMAGE)

