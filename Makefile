ifndef BUILD_SCOPE
BUILD_SCOPE=v1.21.5-dev
endif

PROJECT_BASE=vungle/golang

VERSION            := $(patsubst v%,%,$(BUILD_SCOPE))
LABEL_PARTS        ?= $(subst -, ,$(VERSION))

VERSION_PARTS      := $(subst ., ,$(word 1,$(LABEL_PARTS)))
MAJOR              := $(word 1,$(VERSION_PARTS))
MINOR              := $(word 2,$(VERSION_PARTS))
PATCH              := $(word 3,$(VERSION_PARTS))
LABEL	           := $(word 2,$(LABEL_PARTS))
ifdef LABEL
LABEL := -$(LABEL)
endif

ifeq ($(PUSH_MULTIARCH), true)
BUILDX_ARG_PUSH = '--push'
endif

.PHONY: all test clean

build-native:
	@echo "Build options: $(BUILD_OPTS)"
	@docker build \
	$(BUILD_OPTS) \
	-t $(PROJECT_BASE):$(VERSION) \
	-t $(PROJECT_BASE):$(MAJOR).$(MINOR)$(LABEL) \
	.
	@docker build \
	$(BUILD_OPTS) \
	-t $(PROJECT_BASE):$(VERSION)-alpine \
	-t $(PROJECT_BASE):$(MAJOR).$(MINOR)$(LABEL)-alpine \
	-f Dockerfile.alpine \
	.

build-multiarch: _prepare-multiarch
	@echo "Build multiarch options: $(BUILD_OPTS)"
	@docker buildx build \
	$(BUILD_OPTS) \
	--platform linux/amd64,linux/arm64 \
	$(BUILDX_ARG_PUSH) \
	-t "$(PROJECT_BASE):$(VERSION)-ma" \
	-t "$(PROJECT_BASE):$(MAJOR).$(MINOR)$(LABEL)-ma" \
	.
	@docker buildx build \
	$(BUILD_OPTS) \
	--platform linux/amd64,linux/arm64 \
	$(BUILDX_ARG_PUSH) \
	-t "$(PROJECT_BASE):$(VERSION)-alpine-ma" \
	-t "$(PROJECT_BASE):$(MAJOR).$(MINOR)$(LABEL)-alpine-ma" \
	-f Dockerfile.alpine \
	.

build: build-native build-multiarch

test:
	@echo "Testing standard image..."
	docker run --rm \
	-v `pwd`/test:/var/test \
	$(PROJECT_BASE):$(VERSION) \
	go run /var/test/mustcompile/mustcompile.go -version="$(MAJOR).$(MINOR).$(PATCH)"
	@echo "Testing alpine image..."
	docker run --rm \
	-v `pwd`/test:/var/test \
	$(PROJECT_BASE):$(VERSION)-alpine \
	go run /var/test/mustcompile/mustcompile.go -version="$(MAJOR).$(MINOR).$(PATCH)"

publish:
	@docker push $(PROJECT_BASE):$(VERSION)
	@docker push $(PROJECT_BASE):$(MAJOR).$(MINOR)$(LABEL)
	@docker push $(PROJECT_BASE):$(VERSION)-alpine
	@docker push $(PROJECT_BASE):$(MAJOR).$(MINOR)$(LABEL)-alpine

################
# Helper rules #
################
_prepare-multiarch:
	docker buildx inspect | grep 'Driver:' | grep 'docker-container' > /dev/null || { docker buildx create --use --name multiarch-builder; docker buildx inspect --bootstrap; }
