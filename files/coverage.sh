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

profiles=()
for package in $(go list ./... | egrep -v "vendor"); do
  # Normalize package name to file name.
  filename=$OUTDIR/$(echo "$package-cover.out" | sed "s/\//-/g")

  # Leak only stdout for further processing.
  go test -v -coverprofile=$filename -covermode=count $package

  if [ -f "$filename" ]; then
    profiles+=($filename)
  fi
done

# Combine all inidividual cover profiles into one.
gocovmerge ${profiles[@]} > $OUTDIR/coverall.out
echo "${profiles[@]} " > $OUTDIR/tested.log
rm ${profiles[@]}

# Convert from cover profile to XML.
gocover-cobertura < $OUTDIR/coverall.out > $OUTDIR/coverall.xml
