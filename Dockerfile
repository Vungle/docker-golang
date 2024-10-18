# Dockerfile provides minimal tooling and source dependency management for
# any Go projects at Vungle.
#
# Tag: vungle/golang[:<go-semver>]; e.g. vungle/golang:1.5, vungle/golang:1.5.2.
FROM golang:1.22.4

# OUTDIR specifies a directory in which projects can create output files so that
# these output files can be consumed by other processes. Downstream projects can
# choose to mount OUTDIR to a volume directly or create a directory and perform
# `docker cp ...` later.
ENV OUTDIR=/out

##########################
# Testing and Tooling
#
# NOTE: For testing and tooling binaries that are actually built with Go, we
# want to only retain its binaries to avoid unexpected source dependencies bleed
# into the project source code.
##########################
RUN go install \
        github.com/jstemmer/go-junit-report@latest
RUN go install \
        github.com/t-yuki/gocover-cobertura@latest
RUN go install \
        github.com/wadey/gocovmerge@latest
RUN go install \
        golang.org/x/lint/golint@latest
RUN go install \
        golang.org/x/tools/cmd/goimports@latest
RUN rm -rf $GOPATH/src/* && rm -rf $GOPATH/pkg/*

##########################
# Dependency Management
##########################

# TODO: Benchmark report tools.

##########################
# Testing scripts
##########################
COPY files/report.sh /usr/local/bin/report.sh
COPY files/coverage.sh /usr/local/bin/coverage.sh

##########################
# Code Analysis scripts
##########################
COPY files/lint.sh /usr/local/bin/lint.sh
