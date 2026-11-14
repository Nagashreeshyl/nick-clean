# nick-clean

A small macOS terminal tool that finds the **hidden** stuff eating your disk (caches, dev-tool downloads, and folders left behind by apps you already deleted), shows each item with its size, and deletes only what you pick.

```
   #       SIZE  TYPE      PATH
   1     4.7 GB  CACHE     ~/.konan
   2     3.0 GB  CACHE     ~/.cache/uv
   3   115.3 MB  LEFTOVER  ~/Library/Application Support/zen
   ...
Enter numbers to delete (e.g. 1 3 5-8), 'leftover', 'cache', or q to quit:
```

- One bash file, no dependencies. Works with the bash that ships with macOS.
- Nothing is deleted until you pick items **and** type `yes`.
- Never touches macOS's own folders, your keychain, mail, photos, iPhone backups, or `~/.ssh`.

## Install

```bash
git clone https://github.com/Nagashreeshyl/nick-clean.git
cd nick-clean
chmod +x nick-clean
mkdir -p ~/.local/bin
ln -sf "$PWD/nick-clean" ~/.local/bin/nick-clean
```

Make sure `~/.local/bin` is on your `PATH` (add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc` if it isn't). Then run:

```bash
nick-clean
```

## Usage

1. Run `nick-clean`. The scan takes about 30–60 seconds.
2. Read the list. It's sorted biggest first, and each row has a type:

   | Type | Meaning | Safe to delete? |
   |---|---|---|
   | `CACHE` | Caches and downloads (`~/.cache/*`, `~/Library/Caches/*`, `~/.gradle`, `~/.npm`, ...) | Yes. Rebuilt automatically when needed |
   | `LEFTOVER` | App data whose app is no longer installed | Usually. Check the name first (it's a best guess) |
   | `APP DATA` | Data of an app you still have | Resets that app (logins/settings lost) |
   | `TOOL` | Dev tools and config (`~/.nvm`, `~/.venv`, `~/.config`, ...) | Uninstalls that tool |

3. Type what to delete:
   - numbers: `1 4 7`
   - ranges: `5-9`
   - whole groups: `cache` or `leftover`
   - `q` to quit without deleting
4. Check the summary, then type `yes`. Anything else cancels.

Deletion is **permanent** (it does not go to the Trash).

## Options

Set these as environment variables:

| Variable | Default | What it does |
|---|---|---|
| `NICK_CLEAN_MIN_KB` | `10240` (10 MB) | Hide items smaller than this |
| `NICK_CLEAN_APP_DIRS` | `/Applications ~/Applications` | Where to look for installed apps |

Example: `NICK_CLEAN_MIN_KB=1024 nick-clean` shows everything over 1 MB.

## Test

```bash
./test.sh
```

Builds a fake home folder in a temp directory and checks that only the selected item is deleted, that Apple folders are hidden, and that cancelling deletes nothing.

## More

- [How it works](docs/HOW-IT-WORKS.md): what's scanned, how leftovers are detected, and the safety checks
- [FAQ & troubleshooting](docs/FAQ.md)
