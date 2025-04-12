![ShellTools logo](https://github.com/Anc3vt/shelltools/blob/main/doc/shell-tools-logo.png?raw=true)


# ShellTools v0.1 

**ShellTools** is a collection of handy shell scripts and functions designed to boost your command-line productivity. It enhances your shell with persistent environment variables, quick directory navigation, search utilities, and other tools for developers. ShellTools works with common Unix shells (Bash, Zsh, etc.) and is easy to install, integrating seamlessly into your shell’s startup configuration.

## **Features**

* **Persistent Environment Variables:** Easily save environment variables so they persist across shell sessions with `setv`, and retrieve or remove them with `getv`/`unsetv`.

* **Directory Navigation History:** Enhanced `cd` command that remembers visited directories. Use `d` to list recent dirs and number keys `1`\-`8` to jump back quickly.

* **Search Utilities:** Convenient shortcuts like `f` to find files by name, `g` to grep recursively with color, and `fvim` to find files and open in Vim if they contain a search term.

* **Developer Tools:** Quick-check Maven project info with `mvnver` and streamlined Maven output with `mvnless`. A `git-branches` script shows an overview of recent commits on multiple branches.

* **Bulk Command Execution:** The `execin` script lets you run a given command inside each of multiple directories (e.g. run a git or build command in all subfolders).

* **Tree Listing:** A `tree` script to display the directory structure in a tree-like format (similar to the Unix `tree` command), with an option to include hidden files.

## **Installation**

**Clone the Repository** (or download the project):

 `git clone https://github.com/Anc3vt/shelltools.git`  
`cd shelltools`

1. **Run the Installer:** Execute the provided install script. This will set up ShellTools by adding lines to your shell’s startup file (`~/.bashrc`, `~/.zshrc`, or Fish config, depending on your `$SHELL`).

 `./install.sh`

2.  *The installer will append ShellTools init code to your shell config, setting the `ST_HOME` environment variable and sourcing `stinit.sh` on shell startup.*

**Reload Your Shell:** After installation, open a new terminal **or** re-source your shell config to start using ShellTools. For example, if you use Bash:

 `source ~/.bashrc`

3.  You should see a ShellTools version banner upon installation. Now the `shelltools` functions and scripts are ready to use in your shell.

**Dependencies:** ShellTools uses standard Unix utilities (`bash`, `grep`, `find`, `awk`, etc.) which are typically available on Linux and macOS. For certain features, you’ll need additional tools installed (e.g. `git` for `git-branches`, Maven for `mvnver/mvnless` if you use those).

## **Usage**

ShellTools provides **shell functions** (available in your interactive shell after installation) and **executable scripts** (available on your `$PATH`). Below is a detailed guide for each:

### **Shell Functions**

*(All shell functions are loaded into your shell session via `stinit.sh`. You can use them directly in your terminal.)*

**`setv VAR_NAME=VALUE` – Persist a Shell Variable:**  
 Saves an environment variable persistently. This writes the variable to `~/.shelltools/env` and exports it for the current session. Use it just like an assignment.

 `setv EDITOR=nano`

*  The above will export `EDITOR="nano"` and remember it for future sessions. If you open a new shell, `EDITOR` will still be set (because `stinit.sh` re-loads saved vars). If you call `setv` with an incorrect syntax or without `VAR=VALUE`, it will print a usage message.

**`getv VAR_NAME` – Get a Persisted Variable’s Value:**  
 Retrieves the value of a variable saved with `setv`. Provide the variable name (no `$`). It will output the value if set.

 bash

`getv EDITOR   # prints "nano"`

*  If used with no arguments, it will list all variables stored in ShellTools’ env file (showing lines of `export VAR=value`). This is a quick way to review what you’ve saved.

**`unsetv VAR_NAME` – Remove a Persisted Variable:**  
 Deletes an environment variable that was set with `setv`. This removes its entry from the `~/.shelltools/env` file and unsets it from the current shell.

`unsetv EDITOR`

*  After this, the `EDITOR` variable will no longer be defined in new shells (and is removed from the persistent store). Calling `unsetv` without an argument will show a usage message.

* **Auto-Completion for `getv/unsetv/setv`:** ShellTools includes tab-completion for these commands. When you press \<kbd\>TAB\</kbd\> after `getv` or `unsetv`, it will suggest variable names you’ve saved. After `setv`, pressing \<kbd\>TAB\</kbd\> will suggest existing variable names (appending `=` for convenience). This makes managing variables even easier.

**Enhanced `cd` (Directory Change):** ShellTools overrides the `cd` command to keep a history of the directories you visit. It functions exactly like the normal `cd`, but every time you successfully change directory, the new path is recorded in `~/.shelltools/cd_history`.

`cd projects/my-app`  
`cd ../another-folder`

*  This history is used by other ShellTools functions (described next). The override is safe: it still calls the builtin `cd` under the hood, so all normal `cd` behavior is preserved.

**`d` – Directory History List:**  
 Displays the recent directories you have visited (up to 8 entries, excluding the current directory). The output is numbered for easy reference. For example:

`1  /home/user/projects/my-app`  
`2  /home/user/another-folder`  
`3  /var/log`

*  Use this list to quickly jump back to a directory by its number. The history is updated automatically by the `cd` command.

**Quick Directory Jump –** ShellTools defines **numeric shortcuts** `1`, `2`, ..., `8` as functions to jump to the corresponding entry from `d`. After using `d` to see your recent locations, simply type the number:

``1   # jumps to the directory listed as 1 in `d` output``

*  This will `cd` you into the directory that was number 1 in the `d` list. Similarly `2` would take you to the second entry, and so on. This provides a fast way to hop around recently used directories without retyping long paths. *(Note: these number shortcuts correspond to the `d` list output. If a slot is empty or does not exist, nothing happens.)*

* **Internal `st_go N` Function:** The numeric jump functions internally call `st_go <index>`. You can also use `st_go` directly with an index (1–8) to achieve the same effect of going to that history entry. This is the underlying helper that performs the directory lookup and `cd`. Usually you’ll just use the number functions for convenience.

**`f <pattern>` – Find Files by Name:**  
 Searches for files and directories in the current directory tree (recursively) with names matching the given pattern (case-insensitive). It’s a shortcut for a `find` command:

`f report`  
 This will find all files/folders in the current directory (and subdirectories) whose names contain “report” (case-insensitively) and print their paths. It’s equivalent to:

`find . -iname "*report*"`

*  Use this to quickly locate files by name without typing the full `find` syntax.

**`g <pattern> [<path>...]` – Grep in Files Recursively:**  
 Recursively searches for a regex or text pattern in the current directory (or a specified path) and highlights matches. It’s essentially a shortcut for a recursive grep:

`g TODO`  
`g "function init" src/`  

*  By default, it searches all files under the current directory (`.`) for the given pattern, case-insensitively, and prints matches with line numbers and color highlighting. You can pass additional options or specify a subdirectory or file pattern as extra arguments if needed, since `g` will accept any arguments that `grep` would (it always includes `-rinI --color` by default for recursive, case-insensitive search skipping binary files).

**`fvim <name-pattern> [content-pattern]` – Find and Vim Open:**  
 Finds files by name (like the `f` function) and opens them in the Vim editor **if** they contain a specific text. Usage: provide a filename pattern and optionally a content search pattern. For example:

`fvim .java initialize`

*  This will locate all files with “.java” in their name, then for each, check if the file’s content contains “initialize” (case-insensitive). Any file that matches both criteria will be opened in Vim. If you omit the content pattern, `fvim` will open all files matching the name pattern (skipping those that are empty). Each file opens one by one in Vim for you to inspect/edit; when you exit Vim, the next file (if any) will open. This is useful for quickly finding all relevant files and editing them. *(You can also use another editor by editing the script if needed, but Vim is the default.)*

**`mvnver [N]` – Quick Maven Coordinates Check:**  
 In a Maven project directory, this function prints out the GroupId, ArtifactId, and Version from the top of the `pom.xml`. By default it looks at the first 20 lines of `pom.xml` (which usually contain these coordinates). You can specify a number `N` to scan more lines if needed.

`mvnver        # checks first 20 lines for GAV`  
`mvnver 50     # checks first 50 lines`

*  It highlights occurrences of `<groupId>`, `<artifactId>`, and `<version` in those lines. This provides a quick overview of the project’s Maven coordinates without opening the pom file manually.

**`mvnless` – Filtered Maven Build Output:**  
 Runs a Maven build (`mvn clean install`) and filters the output to show only high-level progress and results. Specifically, it will output lines that contain “Building”, “SUCCESS”, or “FAILURE”, with those keywords highlighted.

`cd my-maven-project/`  
`mvnless`  
 This is useful for seeing the summary of a Maven build (which modules are building and whether the build succeeded or failed) without all the verbose logging. It’s essentially a shortcut for:

`mvn clean install | grep -E --color "(SUCCESS|FAILURE|Building)"`

*  You’ll see the build steps and final status, which is easier to scan for success/failure. (If you need the full output, run Maven normally.)

**`fdate` – Formatted Date String:**  
 Outputs the current date/time in a compact **`YYYY-MM-DD_HH-MM-SS`** format. Example:

`fdate  # e.g. "2025-04-12_07-01-57"`

*  This is handy for scripting (e.g., to timestamp a filename) or logging. It’s essentially a shorthand for `date +"%Y-%m-%d_%H-%M-%S"`.

### **Command-Line Scripts (Bin Tools)**

*(The following tools are installed to `shelltools/bin` and added to your `$PATH` by the installer. You can run them like any command-line program.)*

**`execin` – Execute In Directories:**  
 Runs a specified shell **command in each directory** fed to it via standard input. This is great for applying a command to multiple folders at once.  
 **Usage:** Pipe a list of directories into `execin`, followed by the command in quotes as the argument. For example:

`# Run "git pull" inside each subdirectory of the current directory`  
`ls -d */ | execin "git pull"`  
 In this example, `ls -d */` lists subdirectories and pipes them to `execin`. For each directory, `execin` will `cd` into it and run the given command. You will see output like:

`> cd "project1" && git pull`    
`(git output for project1)`    
`> cd "project2" && git pull`    
`(git output for project2)`    
`skip: 'somefile.txt' — not a directory`  
 `execin` prints a line beginning with `>` to indicate the directory and command being executed. If an input item isn’t a directory, it prints a “skip” message. This tool is especially useful for batch operations, such as updating multiple git repositories, building all project folders, etc.  
 **Example:** Find all directories containing “test” in their name and list their contents:

`find . -type d -name "*test*" | execin "ls -l"`

*  This will run `ls -l` in each directory whose name matches “test”.

**`ff` – Fuzzy Find in Recent Commands:**  
 Interactively search your recent **shell history** and run a selected command. This acts like a simple fuzzy finder for your last used commands.  
 **Usage:** `ff <keyword1> <keyword2> ...` (provide one or more search terms). It will search your **\~/.bash\_history** (the last 1000 commands by default) for any commands containing those terms.  
 Example:

`ff docker run`  
 This will look for commands in your history that contain “docker” or “run” (case-insensitive). It then presents a numbered list of matches (by default up to 20 matches, you can adjust the limit via the `FAN_LIMIT` environment variable). For example:

`1) docker run -d nginx`  
`2) kubectl run test-pod --image=alpine`  
`3) docker build -t myapp .`  
`?:` 

*  You’ll see a prompt `?:` asking you to choose a number. Type the number of the command you want to execute (e.g., `1` for the first command).  
   Next, `ff` will present that command, allowing you to **edit it** before execution: it shows a prompt with your current directory and the command pre-filled. You can hit **Enter** to run it immediately, or modify the command (perhaps to fix an argument or change a parameter) and then press Enter. The selected (possibly edited) command will then be executed in your shell.

  * If no matches are found, `ff` will inform you. If an invalid selection is entered, it will abort without running anything.

  * **Tip:** Use this to avoid retyping complex commands. It’s especially useful for long commands you ran recently – just search a few keywords, pick the command, tweak if necessary, and run it.

* **`git-branches` – Show Recent Commits on Multiple Branches:**  
   Lists the latest commits on a number of remote Git branches for a quick overview.  
   **Usage:** `git-branches [branchCount] [commitCount]`

  * *branchCount* – how many remote branches to show (default 5).

  * *commitCount* – how many recent commits per branch to show (default 5).  
     For example:

`git-branches        # show 5 branches, 5 commits each`  
`git-branches 10 3   # show 10 branches, 3 commits each`  
 **Output:** The script will list each branch name followed by the latest commits on that branch, in one-line format (commit hash and message). For example:

`branch: origin/main`    
`<hash1> Initial commit`    
`<hash2> Add README`    
`-------------------------`    
`branch: origin/dev`    
`<hash3> Feature X implementation`    
`<hash4> Fix bug Y`    
`-------------------------`    
`... (and so on for the specified number of branches)`

*  It looks at **remote branches** (`git branch -r`) and ignores the `origin/HEAD -> ...` pointer. This can be useful to get a quick glimpse of activity across branches (e.g., in a multi-branch repository) without manually checking out each branch. Run this inside a Git repository; otherwise, it will error out if no repo is found.

* **`tree` – Directory Tree Listing:**  
   Prints the directory structure of the current directory in a hierarchical tree format, using ASCII/UTF-8 line drawing characters. It’s a convenient alternative to installing the `tree` command.  
   **Usage:** `tree [--all]`

  * Without arguments, `tree` will list the files and subdirectories of the current directory and all deeper levels, **excluding hidden files/directories** (those beginning with `.`).

  * If you provide the `--all` flag, it will include hidden files and directories in the output.  
     **Example output:**

`├─ README.md`    
`├─ src`    
`│  ├─ main.py`    
`│  └─ utils`    
`│     └─ helper.py`    
`└─ docs`    
   `└─ index.html`  

*  The tree is sorted alphabetically. Branch lines (`├─` and `└─`) indicate the file/directory structure. Subdirectories are indented with vertical bars. This gives a quick visual overview of the project structure.

  * By design, `tree` always lists the structure of the **current** directory. It does not take a directory path argument (any extra argument will be ignored or treated as a flag if matching `--all`). So to view a different location, `cd` to that directory then run `tree`.

  * This script uses `find` and `awk` internally. It automatically parses flags using ShellTools’ argument parser – currently the only supported flag is `--all`. Unrecognized flags will be ignored.

## **Configuration and Notes**

* **ShellTools Home (`ST_HOME`):** The installer sets an environment variable `ST_HOME` to the installation directory. This is used internally to locate scripts (like the `functions` file and `lib` resources). Normally you don’t need to change this. If you move the installation folder, update the path in your shell init lines accordingly.

* **User Data Directory (`ST_USER_HOME`):** ShellTools uses `~/.shelltools` by default to store user-specific data (the `env` file for `setv/getv` and the `cd_history`). This path is set in `stinit.sh` and can be customized by setting the `ST_USER_HOME` variable **before** sourcing `stinit.sh`. For example, if you prefer a different location, export `ST_USER_HOME` to your desired path in your shell config **before** the ShellTools init block.

* **History Search Limit:** The `ff` script by default searches the last 1000 commands from your Bash history and shows at most 20 results. You can adjust the number of results by setting an environment variable `FAN_LIMIT` to a different number (in your shell, export it before running `ff` or add it to your `~/.shelltools/env` via `setv FAN_LIMIT=<n>`).

* **Shell Compatibility:** The tools are primarily written for Bash (and largely compatible with Zsh). The installer will detect Bash, Zsh, or Fish and add the appropriate init code. *Note:* On Fish shell, because the init script is written in Bash syntax, not all features may work. You might need to manually translate parts of `stinit.sh` to Fish if you want full functionality in Fish shell. Bash/Zsh users should have no issues.

* **Completing Uninstallation:** If you ever want to remove ShellTools, simply delete the `ShellTools initialization` block from your shell’s rc file and remove the `shelltools` folder. This will stop loading ShellTools on new shells. (There is no automated uninstall script at this time.)

## **License**

This project is open-source licensed under the **Apache 2.0 License**. See the LICENSE file for details.

Copyright © 2025 Ancevt. ShellTools is provided AS-IS without warranty. 

