# gh-init

A simple bash script to initialize a git repository and create a corresponding GitHub repository in one command.

## Features

- Initializes a local git repository (or uses an existing one with `-e`)
- Creates a `.gitignore` file with common patterns
- Makes an initial commit if needed
- Authenticates with GitHub if needed
- Creates a private GitHub repository by default (use `-p` for public)
- Pushes your code to GitHub
- All with a single command

## Prerequisites

- [GitHub CLI (gh)](https://cli.github.com/) must be installed
  - Ubuntu/Debian: `sudo apt install gh`
  - macOS: `brew install gh`
  - Other platforms: See [GitHub CLI installation](https://github.com/cli/cli#installation)

## Installation

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x init.sh
   ```
3. Optionally, move it to a directory in your PATH for easy access:
   ```bash
   sudo mv init.sh /usr/local/bin/init
   ```

## Usage

Navigate to your project directory and run:

```bash
./init.sh
```

**Important:** The GitHub repository will be named after your current directory. For example, if you run the script in `/home/user/my-project/`, the repository will be created as `my-project`.

### Options

- `-p` - Create a public repository (default is private)
- `-e` - Use existing `.git` repository (skip `git init`)
- `-h` - Show help message

### Examples

Create a private repository:
```bash
./init.sh
```

Create a public repository:
```bash
./init.sh -p
```

Create a repo for an existing `.git` directory:
```bash
./init.sh -e
```

## What It Does

1. Checks if the directory is already a git repository (exits if so, unless `-e` is used)
2. Checks if GitHub CLI is installed
3. Authenticates with GitHub (prompts if not authenticated)
4. Checks if a repository with that name already exists on GitHub (exits if so)
5. Initializes git (skipped with `-e`)
6. Creates a `.gitignore` file if one doesn't exist
7. Makes an initial commit if needed
8. Creates a GitHub repository with the same name as your directory
9. Sets up the remote and pushes your code
10. Displays the URL of your new repository

## Notes

- If a `.gitignore` file already exists, it won't be overwritten
- The script will exclude itself (`init.sh`) from being committed
- For public repos, planning files (`PRD.md`, `progress.txt`) and `.claude/` are automatically added to `.gitignore`
