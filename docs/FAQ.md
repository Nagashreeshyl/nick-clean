# FAQ & troubleshooting

**Is it safe?**
Nothing is deleted until you choose items and type `yes`. macOS system folders and personal data (keychain, mail, photos, iPhone backups, SSH keys) are never listed. Deletion is permanent, so read each path you select.

**What should I delete first?**
`CACHE` items. They're rebuilt automatically, the only cost being a re-download or slower first run. `~/.cache/huggingface` holds downloaded AI models, which can be large to download again.

**A `LEFTOVER` belongs to an app I still use. Why?**
Detection matches folder names against installed app names and bundle ids. Apps installed outside `/Applications`, command-line tools, and folders named after a company can all be flagged wrongly. Skip that item.

**It says `FAILED`.**
Either the app is still running (quit it and run again), or macOS is protecting the folder. For protected folders, give your terminal app Full Disk Access in System Settings → Privacy & Security → Full Disk Access.

**`nick-clean: command not found`**
`~/.local/bin` isn't on your `PATH`. Add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc` and open a new terminal. Or run `./nick-clean` from the repo folder.

**Freed space looks smaller than what I deleted.**
macOS may keep APFS snapshots (Time Machine local snapshots) and purgeable space. The space shows up after macOS frees it, which can take a while.

**The scan is slow.**
Measuring hundreds of folders takes 30–60 seconds. That's normal.

**Can I see smaller items?**
`NICK_CLEAN_MIN_KB=1024 nick-clean` lists everything over 1 MB.
