 **this is the old version of README, new version in progress*
# **ShellTools**

ShellTools is a collection of handy shell scripts and functions designed to boost your command-line productivity. It includes utilities for persistent environment variables, directory navigation history, quick file search, and more. These tools are written in pure Bash and can be easily integrated into your daily shell workflow.

## **Features**

* Persistent environment variables using setv/getv/unsetv

* Quick file and text search with f and g

* Enhanced directory navigation with history and shortcuts

* Batch command execution across directories

* Concise Maven build summaries

* Shell argument parser library

* Easy timestamping

* Zero external dependencies beyond standard POSIX tools

## **Installation**

Clone this repository:

`git clone https://github.com/Anc3vt/shelltools.git ~/shelltools`

1.

Add the following lines to your ~/.bashrc, ~/.zshrc or other shell config:

`export ST_HOME=~/shelltools`  
`. "$ST_HOME/stinit.sh"`

2.

Restart your terminal or source your shell config:

`source ~/.bashrc  # or ~/.zshrc`

3.

Now all ShellTools functions and scripts are available.

## **Tools Overview**

### **Persistent Variables**

* setv VAR=VALUE — store a variable permanently

* getv \[VAR\] — retrieve a variable (or all)

* unsetv VAR — remove a stored variable

Variables are stored in ~/.shelltools/env and auto-loaded.

Autocomplete is enabled for getv/unsetv/setv.

Example:

`setv MY_TOKEN=abc123`  
`getv MY_TOKEN`  
`unsetv MY_TOKEN`

---

### **Directory History & Shortcuts**

Automatically tracks cd history. Use:

* d — show last 8 dirs

* 1 to 8 — cd into nth recent dir

Example:

`cd ~/project1`  
`cd ~/project2`  
`d        # list recent dirs`  
`2        # jump back to ~/project1`

Your last directory is also restored on new shell session.

---

### **File & Text Search**

* f pattern — find files/dirs by name (case-insensitive)

* g "text" \[path\] — grep recursively for text with color

Example:

`f settings.json`  
`g "TODO" ./src`

---

### **fvim**

Open all matching files in Vim for review.

Usage:

`fvim "*.sh" "FIXME"`

---

### **execin**

Run a command in each directory read from stdin.

Usage:

`find . -maxdepth 1 -type d | execin "git pull"`

---

### **mvnver**

Print groupId, artifactId, version from pom.xml.

Usage:

`mvnver       # read first 20 lines`  
`mvnver 50    # read first 50 lines`

---

### **mvnless**

Run mvn clean install with minimal output (BUILD SUCCESS/FAILURE only).

Usage:

`mvnless`

---

### **fdate**

Print current timestamp in YYYY-MM-DD\_HH-MM-SS format.

Usage:

`fdate`  
`# → 2025-04-07_13-42-10`

---

### **args.sh**

A small Bash library for parsing CLI arguments like \-foo value into shell variables.

Usage inside your script:

`. "$ST_HOME/lib/args.sh"`  
`echo "user=$user port=$port"`

Run with:

`myscript.sh -user alice -port 8080`

---

## **Project Structure**

* stinit.sh — initialization script

* functions — shell functions

* common/ — executable tools

* lib/ — libraries (e.g. args.sh)

* \~/.shelltools/ — created automatically to store state

## **Requirements**

* Bash (\>=4 recommended)

* POSIX tools (grep, find, sed, etc.)

* Optional: Maven (for mvnver/mvnless), Vim (for fvim)

No external dependencies.

## **Contributing**

Contributions welcome\!

* Fork and branch

* Follow current script style

* Test your tools

* Send a pull request

Add new tools to common/, new functions to functions, libraries to lib/.

----

Contact me: 

- E-mail: [me@ancevt.com](mailto:me@ancevt.com)
- Telegram: [@the148th](https://t.me/the148th)