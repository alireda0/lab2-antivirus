#!/bin/bash
if [ "$#" -ne 3 ]; then
echo "Usage: $0 dir malicious_dir interval-secs"
exit 1
fi
dir="$1"
malicious_dir="$2"
interval_secs="$3"
FLAGGED_EXTENSIONS=(.exe .bat .vbs .scr .ps1)
KEYWORDS="virus trojan malware worm ransomware"
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
has_bad_content() {
local filename="$1"
local word
for word in $KEYWORDS; do
if grep -q -i "$word" "$filename" 2>/dev/null; then
return 0
fi
done
return 1
}
for f in "$dir"/*; do
if has_bad_extension "$f"; then
echo "$f: BAD extension"
else
echo "$f: ok extension"
fi
if has_bad_content "$f"; then
echo "$f: BAD content"
else
echo "$f: ok content"
fi
done
