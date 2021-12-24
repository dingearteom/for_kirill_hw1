#!/bin/bash

set -e
CC=clang
CXX=clang++
cp ./.test/Makefile.asan Makefile
echo "Step 1. Build"
make

VALUES="$((( RANDOM )))"
for i in {1..100}; do
    VALUES+=" $((( RANDOM )))"
done

SUM=$(echo "$VALUES" | sed 's/ /+/g' | bc)

echo "Step 2. Run test"
echo "echo '${VALUES}' > in.txt && timeout 30s ./posix 5 1000"

echo "${VALUES}" > "in.txt"
OUT=$(timeout 30s ./posix 5 1000)
RC=$?

git reset --hard HEAD
git clean -f

if [[ ${RC} != 0 ]]; then
    echo "FAIL! Return code: ${RC}"
    echo 1
fi

if (( ${OUT} == ${SUM} )); then
    echo "OK"
    exit 0
else
    echo "FAIL! Out must be ${SUM} but return ${OUT}" 
    exit 1
fi
