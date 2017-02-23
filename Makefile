ifndef BUILD_SCOPE
BUILD_SCOPE=dev
endif

PROJECT_IMAGE=vungle/golang:$(BUILD_SCOPE)

.PHONY: all test clean

build:
	@echo "Build options: $(BUILD_OPTS)"
	@docker build \
	$(BUILD_OPTS) \
	-t $(PROJECT_IMAGE) \
	.
	@docker build \
	$(BUILD_OPTS) \
	-t $(PROJECT_IMAGE)-alpine \
	-f Dockerfile.alpine \
	.

test:
	@echo "Testing standard image..."
	docker run --rm \
	$(PROJECT_IMAGE) \
	go version | grep $$(cat .version)
	docker run --rm \
	-v `pwd`/test:/var/test \
	$(PROJECT_IMAGE) \
	go run /var/test/mustcompile/mustcompile.go
	@echo "Testing alpine image..."
	docker run --rm \
	$(PROJECT_IMAGE)-alpine \
	go version | grep $$(cat .version)
	docker run --rm \
	-v `pwd`/test:/var/test \
	$(PROJECT_IMAGE)-alpine \
	go run /var/test/mustcompile/mustcompile.go

publish:
	@docker push $(PROJECT_IMAGE)
	@docker push $(PROJECT_IMAGE)-alpine
