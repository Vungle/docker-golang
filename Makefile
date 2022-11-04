ifndef BUILD_SCOPE
BUILD_SCOPE=dev
endif

PROJECT_IMAGE=vungle/golang:$(BUILD_SCOPE)

ifeq ($(PUSH_MULTIARCH), true)
BUILDX_ARG_PUSH = '--push'
endif

.PHONY: all test clean

build-native:
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

build-multiarch: _prepare-multiarch
	@echo "Build multiarch options: $(BUILD_OPTS)"
	@docker buildx build \
	$(BUILD_OPTS) \
	--platform linux/amd64,linux/arm64 \
	$(BUILDX_ARG_PUSH) \
	-t "$(PROJECT_IMAGE)-ma" \
	.
	@docker buildx build \
	$(BUILD_OPTS) \
	--platform linux/amd64,linux/arm64 \
	$(BUILDX_ARG_PUSH) \
	-t "$(PROJECT_IMAGE)-alpine-ma" \
	-f Dockerfile.alpine \
	.

build: build-native build-multiarch

test:
	@echo "Testing standard image..."
	docker run --rm \
	-v `pwd`/test:/var/test \
	$(PROJECT_IMAGE) \
	go run /var/test/mustcompile/mustcompile.go -version="$$(cat .version)"
	@echo "Testing alpine image..."
	docker run --rm \
	-v `pwd`/test:/var/test \
	$(PROJECT_IMAGE)-alpine \
	go run /var/test/mustcompile/mustcompile.go -version="$$(cat .version)"

publish:
	@docker push $(PROJECT_IMAGE)
	@docker push $(PROJECT_IMAGE)-alpine

################
# Helper rules #
################
_prepare-multiarch:
	docker buildx ls | grep 'Driver:' | grep 'docker-container' > /dev/null || { docker buildx create --use --name multiarch-builder; docker buildx inspect --bootstrap; }
