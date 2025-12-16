# gh-init

A simple bash script to initialize a git repository and create a corresponding GitHub repository in one command.

## Features

- Initializes a local git repository if one doesn't exist
- Creates a `.gitignore` file with common patterns
- Makes an initial commit
- Authenticates with GitHub if needed
- Creates a GitHub repository (public or private)
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
   chmod +x gh-init.sh
   ```
3. Optionally, move it to a directory in your PATH for easy access:
   ```bash
   sudo mv gh-init.sh /usr/local/bin/gh-init
   ```

## Usage

Navigate to your project directory and run:

```bash
./gh-init.sh
```

### Options

- `-p` - Create a private repository (default is public)
- `-h` - Show help message

### Examples

Create a public repository:
```bash
./gh-init.sh
```

Create a private repository:
```bash
./gh-init.sh -p
```

## What It Does

1. Checks if GitHub CLI is installed
2. Checks if the directory is already a git repository
3. Initializes git if needed
4. Authenticates with GitHub (prompts if not authenticated)
5. Creates a `.gitignore` file if one doesn't exist
6. Makes an initial commit
7. Creates a GitHub repository with the same name as your directory
8. Sets up the remote and pushes your code
9. Displays the URL of your new repository

## Notes

- The repository name is based on your current directory name
- If a `.gitignore` file already exists, it won't be overwritten
- The script will exclude itself (`gh-init.sh`) from being committed
- If the directory is already a git repository, you'll be prompted to confirm continuation

## License

This project is open source and available under the MIT License.
