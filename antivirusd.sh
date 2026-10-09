#!/bin/bash
if [ "$#" -ne 3 ]; then
echo "Usage: $0 dir malicious_dir interval-secs"
exit 1
fi
dir="$1"
malicious_dir="$2"
interval_dir="$3"
FLAGGED_EXTENSIONS=(.exe .bat .vbs .scr .ps1)
has_bad_extension() {
local filename="$1"
case "$filename" in
*.exe|*.bat|*.vbs|*.scr|*.ps1)
 return 0
;;
*)
return 1
;;
esac
}
for f in "$dir"/*; do
if has_bad_extension "$f"; then
echo "$f: BAD extension"
else
echo "$f: ok"
fi
done
