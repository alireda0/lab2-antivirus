# Lab 2 — Simple Antivirus Daemon

A polling antivirus daemon written in Bash. It watches a directory, and whenever the directory changes, it scans for files that look malicious (by extension or by content), moves them into a quarantine directory, and deletes the originals. A separate restore tool lets the user review quarantined files and either restore them or delete them permanently. A Makefile ties everything together.

## Overview

The project has three main pieces:

- `antivirusd.sh` — the daemon. Takes a source directory, a quarantine directory, and a polling interval. It takes an `ls -l` snapshot of the source directory, sleeps, takes another snapshot, and uses `diff` to detect changes. When a change is detected, it scans every file in the source directory. A file is flagged if its extension is one of `.exe`, `.bat`, `.vbs`, `.scr`, `.ps1`, or if its contents contain one of `virus`, `trojan`, `malware`, `worm`, `ransomware` (case-insensitive). Flagged files are printed to the terminal, copied into the quarantine directory, and deleted from the source.
- `restore.sh` — the restore tool. Lists the files in the quarantine directory with numbers, lets the user pick one, and offers three actions: restore it back to the source directory, permanently delete it, or leave it and go back to the list.
- `Makefile` — provides `make`, `make restore`, and a `prepare` pre-build step that creates the quarantine directory.

### Folder hierarchy

```text
lab2-antivirus/
├── antivirusd.sh
├── restore.sh
├── Makefile
├── README.md
└── .gitignore# lab2-antivirus
## Bonus 2: Whitelist

Files restored through `restore.sh` (option 1) are remembered as safe so they are not flagged again. This works across daemon restarts because the memory lives in a file on disk.

- Whitelist file: `whitelist.txt`, in the same directory as the scripts, one filename per line.
- How a file gets added: when the user picks option 1 in `restore.sh`, the filename is appended to `whitelist.txt` (if not already present).
- How the daemon checks it: in `scan_dir`, right after computing the basename, `is_whitelisted` runs `grep -Fxq "$name" whitelist.txt`. If it matches, the file is skipped before the extension and content checks.
- Limitation: whitelisting is by filename, not content. Any future file with the same name is also trusted. A stronger design would use `sha256sum` to whitelist exact content.

## Bonus 1: Cron Job

Instead of the long-running daemon, `antivirus-cron.sh` runs once and exits. It is meant to be started by cron on a schedule.

### Prerequisites

```bash
sudo apt update
sudo apt install cron
sudo systemctl enable --now cron
systemctl status cron
