# 🐚 ShellTools

A lightweight, modular toolkit to **improve shell productivity**.

---

## 🚀 Features

### 🔧 Persistent Environment Variables
Save, retrieve, and remove environment variables that **persist across shell sessions**.  
No more exporting the same stuff every time you open a terminal.

- `setv VAR=VALUE` — Save & export
- `getv VAR` — Read it
- `getv` - List all
- `unsetv VAR` — Delete it

### 📁 Smart Directory Navigation
Keep track of where you’ve been and jump there instantly.

- `cd some/path` — Tracks history
- `d` — Lists recently visited directories
- `1`, `2`, `3`, ..., `8` — Jump back to recent dirs

### 🔍 File & Text Search Utilities
Search smarter, not harder.

- `f name` — Find files by name (shortcut for `find . -iname`)
- `g pattern` — Grep recursively with color
- `fvim name pattern` — Open files in Vim that match both filename and content

### 🧠 CLI Memory Boosters
- `ff docker pull` — Fuzzy search and re-run past commands from history

### 📁 Directory Bookmarks
- `mark projX` — Save current dir
- `jump projX` — Instantly return there
- `marks` — See all bookmarks

### 🧪 Batch Command Execution
- `ls -d */ | execin "git pull"` — Run a command in each subdir

### 🌲 Tree View (no dependency!)
- `tree` — Directory tree with pretty UTF-8 lines

### 🛆 Maven Helpers
Because Java devs deserve nice things too.

- `mvnver` — Show GroupId / ArtifactId / Version at a glance
- `mvnless` — Clean Maven build output (no more log soup)

---

## 🛠 Installation

```bash
git clone https://github.com/Anc3vt/shelltools.git
cd shelltools
./install.sh
source ~/.bashrc   # or ~/.zshrc
```
---

## 🐧 Compatibility

- ✅ Bash
- ✅ Zsh
- ⚠️ Fish (some functions may require manual porting)

Works out of the box on Linux and macOS.  
No exotic dependencies — just POSIX tools (`grep`, `awk`, `find`, `sed`, etc.)

---

## 🥪 Try It Now

```bash
setv EDITOR=nvim
cd ~/projects
mark myapp
d         # shows recent dirs
2         # jump to second recent
ff docker run
```
## 🙋‍♂️ Why

I originally built ShellTools for myself — to streamline my daily workflow in the terminal, reduce repetitive typing, and make Bash/Zsh feel more like a personal toolbelt than just a shell.

## Contributing 
Pull requests, ideas, and issues are welcome.