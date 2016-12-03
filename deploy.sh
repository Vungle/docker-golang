#!/bin/sh -ex
ver=`cat .version`
minorver=`echo ${ver} | awk -F \. '{ print $1"."$2 }'`
majorver=`echo ${ver} | awk -F \. '{ print $1 }'`
make build PROJECT_IMAGE=vungle/golang:${ver}
docker tag vungle/golang:${ver} vungle/golang:${minorver}
docker tag vungle/golang:${ver} vungle/golang:${majorver}
docker tag vungle/golang:${ver}-alpine vungle/golang:${minorver}-alpine
docker tag vungle/golang:${ver}-alpine vungle/golang:${majorver}-alpine

docker info
docker push vungle/golang
