#!/bin/bash

set -e

[ "$(../bin)" = $'Hello, World!' ]            && echo Test 1 Passed
[ "$(../bin A)" = $'Hello, A!' ]              && echo Test 2 Passed
[ "$(../bin B)" = $'Hello, B!' ]              && echo Test 3 Passed
[ "$(../bin C D)" = $'Hello, C!\nHello, D!' ] && echo Test 4 Passed
[ "$(../bin -h)" = $'Hello, -h!' ]            && echo Test 5 Passed
[ "$(../bin World)" = $'Hello, World!' ]      && echo Test 6 Passed
[ "$(../bin '')" = $'Hello, !' ]              && echo Test 7 Passed
