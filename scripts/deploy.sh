#!/bin/sh -ex
ver=`cat ../.version`
make build publish PROJECT_IMAGE=vungle/golang:${ver}
make build publish PROJECT_IMAGE=vungle/golang:`echo ${ver} | awk -F \. '{ print $1"."$2 }'`
make build publish PROJECT_IMAGE=vungle/golang:`echo ${ver} | awk -F \. '{ print $1 }'`

git tag ${ver} && git push origin ${ver}