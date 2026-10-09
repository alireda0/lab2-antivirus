#!/bin/bash
if [ "$#" -ne 3 ]; then
echo "Usage: $0 dir malicious_dir interval-secs"
exit 1
fi
dir="$1"

malicious_dir="$2"
interval_secs="$3"
ls -l "$dir" > directory-info.last
ls -l "$dir" > directory-info.new
if diff directory-info.last directory-info.new > /dev/null; then
echo "No change"
else
echo "Change detected"
cp directory-info.new directory-info.last
fi
