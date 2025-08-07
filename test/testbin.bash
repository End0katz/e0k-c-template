#!/bin/bash

set -e

[ "$(../bin)" = $'Hello, World!' ]            && echo Test 1 Passed || exit 1
[ "$(../bin A)" = $'Hello, A!' ]              && echo Test 2 Passed || exit 1
[ "$(../bin B)" = $'Hello, B!' ]              && echo Test 3 Passed || exit 1
[ "$(../bin C D)" = $'Hello, C!\nHello, D!' ] && echo Test 4 Passed || exit 1
[ "$(../bin -h)" = $'Hello, -h!' ]            && echo Test 5 Passed || exit 1
[ "$(../bin World)" = $'Hello, World!' ]      && echo Test 6 Passed || exit 1
[ "$(../bin '')" = $'Hello, !' ]              && echo Test 7 Passed || exit 1
