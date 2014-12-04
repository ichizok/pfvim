#!/bin/sh
set -e

tmpfile=$(mktemp)
dstfile=$1

cleanup() {
    rm -f "$tmpfile"
}

trap "cleanup" EXIT

chmod --reference="$dstfile" "$tmpfile"
chown --reference="$dstfile" "$tmpfile"
tee >/dev/null 2>&1 "$tmpfile"
mv "$tmpfile" "$dstfile"
