#!/bin/bash

set -e
CC=clang
CXX=clang++
cp ./.test/Makefile.soft Makefile
echo "Step 1. Build"
make

echo "Step 2. Run test"
echo "echo '2 1 3 5 4 6 7 8 10 9' > in.txt | timeout 10s ./posix 7 9"

echo '2 1 3 5 4 6 7 8 10 9' > "in.txt"
OUT=$(timeout 10s ./posix 7 9)
RC=$?

git reset --hard HEAD
git clean -f

if [[ ${RC} != 0 ]]; then
    echo "FAIL! Return code: ${RC}"
    echo 1
fi

if (( ${OUT} == 55 )); then
    echo "OK"
    exit 0
else
    echo "FAIL! Out must be 55 but return ${OUT}" 
    exit 1
fi
