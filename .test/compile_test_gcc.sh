#!/bin/bash

set -e

CC=gcc
CXX=g++
cp ./.test/Makefile.hard Makefile
if make; then
    echo "OK"
    git reset --hard HEAD
    git clean -f
    exit 0
else
    echo "FAIL"
    git reset --hard HEAD
    git clean -f
    exit 1
fi
