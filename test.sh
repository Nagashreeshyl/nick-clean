#!/bin/bash
# Self-check: fake HOME, select item 1 (the biggest = OldApp leftover), confirm, assert only it was deleted.
set -e
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
mkdir -p "$T/Library/Application Support/OldApp1234" "$T/Library/Caches/somecache" "$T/.venv" "$T/Library/Application Support/com.apple.keep"
mkfile 3m "$T/Library/Application Support/OldApp1234/big"
mkfile 2m "$T/Library/Caches/somecache/c"
mkfile 1m "$T/.venv/v"
mkfile 4m "$T/Library/Application Support/com.apple.keep/k"
out=$(printf '1\nyes\n' | HOME="$T" NICK_CLEAN_MIN_KB=500 NICK_CLEAN_APP_DIRS=/nonexistent ./nick-clean)
echo "$out"
echo "$out" | grep -q 'LEFTOVER.*OldApp1234'
echo "$out" | grep -q 'CACHE.*somecache'
echo "$out" | grep -qv 'com.apple.keep'
[ ! -e "$T/Library/Application Support/OldApp1234" ]
[ -e "$T/Library/Caches/somecache" ] && [ -e "$T/.venv" ] && [ -e "$T/Library/Application Support/com.apple.keep" ]
# cancel path deletes nothing
printf '1\nno\n' | HOME="$T" NICK_CLEAN_MIN_KB=500 NICK_CLEAN_APP_DIRS=/nonexistent ./nick-clean >/dev/null
[ -e "$T/Library/Caches/somecache" ]
echo "ALL TESTS PASSED"
