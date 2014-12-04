#!/bin/sh
set -e

tmpfile=$(mktemp)
dstfile=$1

cleanup() {
    rm -f "$tmpfile"
}

trap "cleanup" EXIT

if [ -f "$dstfile" ]; then
    chmod --reference="$dstfile" "$tmpfile"
    chown --reference="$dstfile" "$tmpfile"
else
    chmod "$(umask -S),-x" "$tmpfile"
fi

tee >/dev/null 2>&1 "$tmpfile"
mv "$tmpfile" "$dstfile"
