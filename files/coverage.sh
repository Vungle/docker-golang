#!/bin/bash
# coverage.sh runs coverage analysis tests on all non-vendored Go packages under
# the current directory. It generates a combined coverage profile,
# `coverall.out`, an XML version of the coverage report, `coverall.xml`, and
# dumps verbose test results of each package to stdout.
set -e

if [ -z "$OUTDIR" ]; then
  echo "Missing environment variable: OUTDIR"
  exit 1
fi

# grep_ignore is the expression which will inversely grepped for the Go packages
# to be tested. E.g., "vendor", or "vendor|cmd\/integration".
ignore_package=$1
ignore_file=$2

if [ -z "$ignore_package" ]; then
  ignore_package="vendor"
fi

if [ -z "$ignore_file" ]; then
  ignore_file="vendor"
fi

profiles=()
for package in $(go list ./... | egrep -v "${ignore_package}"); do
  # Normalize package name to file name.
  filename=$OUTDIR/$(echo "$package-cover.out" | sed "s/\//-/g")

  # Leak only stdout for further processing.
  go test -v -coverprofile=$filename -covermode=count $package

  if [ -f "$filename" ]; then
    profiles+=($filename)
  fi
done

# Combine all inidividual cover profiles into one.
gocovmerge ${profiles[@]} | egrep -v "${ignore_file}" > $OUTDIR/coverall.out
echo "${profiles[@]} " > $OUTDIR/tested.log
rm ${profiles[@]}

# Convert from cover profile to XML.
gocover-cobertura < $OUTDIR/coverall.out > $OUTDIR/coverall.xml
