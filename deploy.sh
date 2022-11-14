#!/bin/sh -ex
ver=`cat .version`-pr-34-test-only
make build PROJECT_IMAGE=vungle/golang:${ver} PUSH_MULTIARCH=true

docker info
docker push vungle/golang:${ver}
docker push vungle/golang:${ver}-alpine
