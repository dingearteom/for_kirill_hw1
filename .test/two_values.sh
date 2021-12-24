#!/bin/bash

set -e
CC=clang
CXX=clang++
cp ./.test/Makefile.soft Makefile
echo "Step 1. Build"
make

echo "Step 2. Run test"
echo "echo '1 2' > in.txt && timeout 10s ./posix 2 0"

echo '1 2' > "in.txt"
OUT=$(timeout 10s ./posix 2 0)

RC=$?

git reset --hard HEAD
git clean -f

if [[ ${RC} != 0 ]]; then
    echo "FAIL! Return code: ${RC}"
    echo 1
fi

if (( ${OUT} == 3 )); then
    echo "OK"
    exit 0
else
    echo "FAIL! Out must be 3 but return ${OUT}" 
    exit 1
fi
