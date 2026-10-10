#!/bin/bash
if [ "$#" -ne 2 ]; then
echo "Usage: $0 dir malicious_dir"
exit 1
fi
dir="$1"
malicious_dir="$2"
mkdir -p "$dir"
mkdir -p "$malicious_dir"
whitelist="whitelist.txt"
touch "$whitelist"
shopt -s nullglob
while true; do
files=("$malicious_dir"/*)
if [ ! -e "${files[0]}" ]; then
echo "No malicious files to review."
exit 0
fi
i=1
for f in "${files[@]}"; do
echo "$i) $(basename "$f")"
i=$((i + 1))
done
read -p "Pick a file number (or q to quit): " choice
if [ "$choice" = "q" ]; then
exit 0
fi
if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
echo "Invalid choice."
continue
fi
if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]; then
echo "Invalid choice"
continue
fi
selected="${files[$((choice - 1))]}"
name=$(basename "$selected")
echo "1) Restore this file back into $dir"
echo "2) Permanently delete this file"
echo "3) Leave this file and go back to the list"
read -p "Choose 1, 2 or 3: " action
case "$action" in
1)
    mv "$selected" "$dir/$name"
    echo "Restored $name to $dir."
    if ! grep -Fxq "$name" "$whitelist"; then
        echo "$name" >> "$whitelist"
    fi
    ;;
2)
rm "$selected"
echo "$name permanently deleted."
;;
3)
;;
*)
echo "Invalid option."
;;
esac
done
