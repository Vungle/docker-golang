[![Build Status](https://travis-ci.org/Vungle/docker-golang.svg?branch=master)](https://travis-ci.org/Vungle/docker-golang)

# docker-golang

Vungle's unified Go SDK for development and continuous integration.

    docker run --rm vungle/golang:1 go version

## Builds

Docker image can be built with:

    make build

Then tested with:

    make test

We're using Travis-CI to continuously deploying on commits to master branch. Make sure changes
passes `make build test` command.

### Future improvements

- Integration other go projects in this repo as dependency breakage.
