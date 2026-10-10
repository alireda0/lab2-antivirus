#!/bin/bash

dir="/home/ali/lab2-antivirus/test_dir"
malicious_dir="/home/ali/lab2-antivirus/quarantine"
whitelist="/home/ali/lab2-antivirus/whitelist.txt"
snapshot="/home/ali/lab2-antivirus/directory-info.last"
newsnap="/home/ali/lab2-antivirus/directory-info.new"
log="/home/ali/lab2-antivirus/antivirus-cron.log"

KEYWORDS="virus trojan malware worm ransomware"

mkdir -p "$malicious_dir"
touch "$whitelist"

log_msg(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$log"
}

has_bad_extension(){
    local filename="$1"
    case "$filename" in
        *.exe|*.bat|*.vbs|*.scr|*.ps1) return 0 ;;
        *) return 1 ;;
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

is_whitelisted(){
    grep -Fxq "$1" "$whitelist"
}

scan_dir(){
    local f name
    for f in "$dir"/*; do
        [ ! -f "$f" ] && continue
        name=$(basename "$f")
        is_whitelisted "$name" && continue
        if has_bad_extension "$f" || has_bad_content "$f"; then
            log_msg "$name is malicious and it is DELETED"
            cp "$f" "$malicious_dir/$name"
            rm "$f"
        fi
    done
}

if [ ! -f "$snapshot" ]; then
    scan_dir
    ls -l "$dir" > "$snapshot"
    log_msg "First run: initial scan complete"
    exit 0
fi

ls -l "$dir" > "$newsnap"
if ! diff "$snapshot" "$newsnap" > /dev/null; then
    log_msg "Change detected, scanning..."
    scan_dir
    ls -l "$dir" > "$snapshot"
fi
