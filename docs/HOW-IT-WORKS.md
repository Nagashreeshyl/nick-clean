# How nick-clean works

Everything is in the single script [`nick-clean`](../nick-clean). It runs in five steps.

## 1. Find installed apps

For every `.app` in `/Applications` and `~/Applications`, it records:

- the app name (`Microsoft Edge`)
- its bundle id from `Info.plist` (`com.microsoft.edgemac`)
- the vendor part of the bundle id (`microsoft`)

These become the "known app" keys used in step 3.

## 2. Scan

It measures (`du -sk`) each item in:

| Location | Labelled |
|---|---|
| `~/.*` (hidden home folders) | `CACHE` if it's a known cache (`.npm`, `.gradle`, `.konan`, `.m2`, `.yarn`, `.cocoapods`, `.pub-cache`, ...), else `TOOL` |
| `~/.cache/*` (listed one by one) | `CACHE` |
| `~/Library/Caches/*`, `~/Library/Logs/*` | `CACHE` |
| `~/Library/Application Support/*`, `Containers/*`, `Group Containers/*`, `Preferences/*`, `Saved Application State/*`, `HTTPStorages/*`, `WebKit/*` | `APP DATA` or `LEFTOVER` (step 3) |

Items smaller than `NICK_CLEAN_MIN_KB` (10 MB by default) are hidden.

**Never listed:** anything named `com.apple.*`, plus macOS and personal folders such as AddressBook, CallHistory, CloudDocs, Keychains, Mail, Messages, Safari, Photos, MobileSync (iPhone backups), `.ssh`, `.gnupg` and `.local`. See `SKIP` at the top of the script.

## 3. Detect leftovers

A Library folder is `APP DATA` if its name (lower-case, spaces removed) contains a known-app key or is contained in one, for keys of 4 or more characters. Otherwise it's `LEFTOVER`.

This is a heuristic. It leans toward calling things `APP DATA`, because wrongly calling app data a leftover is the dangerous mistake. Some folders are named after the company rather than the app, or after a helper tool, so always read the path before deleting a `LEFTOVER`.

## 4. Select

You type numbers, ranges (`3-7`), or `cache`/`leftover`. Anything that isn't a number, range or keyword stops the program without deleting.

## 5. Confirm and delete

The program shows what you picked and its total size, and deletes only after you type exactly `yes`. Before each `rm -rf` it checks:

- the path came from the scanned list (selection is by index only)
- the path is inside `$HOME/` and is not `$HOME` itself
- the path has no `..` segments

It also refuses to run as root. Afterwards it reports each item as deleted or failed, plus how much space was freed.

## Not covered

- System-wide `/Library` leftovers (they need `sudo`)
- Large ordinary files in Documents/Downloads (that's your data, not hidden junk)
- Moving items to the Trash instead of deleting them
