#!/bin/sh -ex
ver=`cat .version`

# Ensure that when .version file is missing patch version part, amend the
# default '0' patch version.
IFS='.' read -r -a verparts <<< "${ver}"
if [ "${#verparts[@]}" -eq "2" ]; then
  ver="${ver}.0"
fi

minorver=`echo ${ver} | awk -F \. '{ print $1"."$2 }'`
majorver=`echo ${ver} | awk -F \. '{ print $1 }'`
make build PROJECT_IMAGE=vungle/golang:${ver}
docker tag vungle/golang:${ver} vungle/golang:${minorver}
docker tag vungle/golang:${ver} vungle/golang:${majorver}
docker tag vungle/golang:${ver}-alpine vungle/golang:${minorver}-alpine
docker tag vungle/golang:${ver}-alpine vungle/golang:${majorver}-alpine

docker info
docker push vungle/golang
