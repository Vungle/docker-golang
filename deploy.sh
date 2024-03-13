#!/bin/sh -ex
VERSION=`cat .version`

make build BUILD_SCOPE=${VERSION} PUSH_MULTIARCH=true
make publish
