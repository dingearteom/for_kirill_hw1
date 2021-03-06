#!/bin/bash

set -e
CC=clang
CXX=clang++
cp ./.test/Makefile.soft Makefile
echo "Step 1. Build"
make

echo "Step 2. Run test"
echo "echo '1' > in.txt && timeout 10s ./posix 1 5"

echo '1' > "in.txt"
OUT=$(timeout 10s ./posix 1 5)
RC=$?

git reset --hard HEAD
git clean -f

if [[ ${RC} != 0 ]]; then
    echo "FAIL! Return code: ${RC}"
    echo 1
fi

if (( ${OUT} == 1 )); then
    echo "OK"
    exit 0
else
    echo "FAIL! Out must be 1 but return ${OUT}" 
    exit 1
fi
