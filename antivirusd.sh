#!/bin/bash
if [ "$#" -ne 3 ]; then
echo "Usage: $0 dir malicious_dir interval-secs"
exit 1
fi
dir="$1"
malicious_dir="$2"
interval_secs="$3"
echo "Source directory: $dir"
echo "Quarantine directory: $malicious_dir"
echo "Interval seconds: $interval_secs"
