account = vungle
project = golang

all: build test push deploy

build:
	@echo "Building..."
	@docker build . | tail -n 1 | awk '{print $$3}' | xargs echo -n > .last_build
	@echo "Build ID: $$(cat .last_build)"

test:
	@docker run -ti --rm $$(cat .last_build) /bin/bash -c 'curl -s -o /dev/null -w "%{http_code}" http://www.example.org/'

tag:
	@docker tag $$(cat .last_build) $(account)/$(project):$$(cat .last_build) 

push: tag
	@echo "Pushing to $(account)/$(project):$$(cat .last_build)"
	@docker push $(account)/$(project):$$(cat .last_build)

push_latest:
	@echo "Pushing to $(account)/$(project)"
	@docker tag $$(cat .last_build) $(account)/$(project)
	@docker push $(account)/$(project)

push_release_tag:
	@echo "Pushing to $(account)/$(project):$(release_tag)"
	@docker tag $$(cat .last_build) $(account)/$(project):$(CIRCLE_TAG)
	@docker push $(account)/$(project):$(CIRCLE_TAG)
