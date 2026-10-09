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
mkdir -p "$malicious_dir"
has_bad_extension(){
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
has_bad_content(){
    local filename="$1"
    local word
    for word in $KEYWORDS; do
        if grep -q -i "$word" "$filename" 2>/dev/null; then
            return 0
        fi
    done
    return 1
}
scan_dir(){
    local f
    local name
    for f in "$dir"/*; do
        if [ ! -f "$f" ]; then
            continue
        fi
        if has_bad_extension "$f" || has_bad_content "$f"; then
            name=$(basename "$f")
            echo "$name is malicious and it is DELETED"
            cp "$f" "$malicious_dir/$name"
            rm "$f"
        fi
    done
}
scan_dir
ls -l "$dir" > directory-info.last
while true; do
    sleep "$interval_secs"
    ls -l "$dir" > directory-info.new
    if ! diff directory-info.last directory-info.new > /dev/null; then
        echo "Change detected, scanning.."
        scan_dir
        ls -l "$dir" > directory-info.last
    fi
done
