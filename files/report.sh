#!/bin/bash
# report.sh generates an XML version of the Go unit test report from the stdout
# of any `go test -v` command. report.xml will be generated as an output of
# report.sh.
if [ -z "$OUTDIR" ]; then
  echo "Missing environment variable: OUTDIR"
  exit 1
fi

go-junit-report > $OUTDIR/report.xml
