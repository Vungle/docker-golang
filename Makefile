ifndef BUILD_SCOPE
BUILD_SCOPE=dev
endif

PROJECT_IMAGE=vungle/golang:$(BUILD_SCOPE)

build:
	@docker build . -t $(PROJECT_IMAGE)

build-alpine:
	@docker build . -t $(PROJECT_IMAGE) -f Dockerfile.alpine

test:
	@echo "Testing standard image..."
	@docker build . -t vungle/golang:test
	@docker run --rm vungle/golang:test \
	go version | grep 1.7.4
	@docker run --rm -v `pwd`/tests/shouldpass.go:/opt/shouldpass.go vungle/golang:test \
	go run /opt/shouldpass.go
	@echo "Testing alpine image..."
	@docker build . -t vungle/golang:test-alpine -f Dockerfile.alpine
	@docker run --rm vungle/golang:test-alpine \
	go version | grep 1.7.4
	@docker run --rm -v `pwd`/tests/shouldpass.go:/opt/shouldpass.go vungle/golang:test \
	go run /opt/shouldpass.go

publish:
	@docker push $(PROJECT_IMAGE)
