#!/bin/bash
# lint.sh runs code analysis on the current source code and fails in case any analysis result was
# indicates ill-intended code.

# Run go fmt.
files=$(go fmt $(go list ./... | grep -v vendor))
if [[ -n $files ]]; then
  echo "The following files are malformatted; please run go fmt!"
  echo $files
  exit 1
fi

# Run go vet.
go vet $(go list ./... | grep -v vendor)
if [[ $? -ne 0 ]]; then
  echo "Some files may contain mistakes; please run go vet!"
  exit 1
fi

golint ./... | egrep -v "vendor|ALL_CAPS"
