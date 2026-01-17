#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse command line arguments
PRIVATE=true
EXISTING=false
while getopts "peh" opt; do
    case $opt in
        p)
            PRIVATE=false
            ;;
        e)
            EXISTING=true
            ;;
        h)
            echo "Usage: $0 [-p] [-e] [-h]"
            echo "  -p    Create a public repository (default: private)"
            echo "  -e    Use existing .git repository (skip git init)"
            echo "  -h    Show this help message"
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            echo "Use -h for help"
            exit 1
            ;;
    esac
done

# Get the current directory name as repo name
REPO_NAME=$(basename "$PWD")

# Check existing git repository status
if [ -d .git ]; then
    if [ "$EXISTING" = false ]; then
        echo -e "${RED}Error: This directory is already a git repository.${NC}"
        exit 1
    fi
else
    if [ "$EXISTING" = true ]; then
        echo -e "${RED}Error: No .git directory found. Use without -e to initialize.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}GitHub Repository Initializer${NC}"
echo -e "${GREEN}==============================${NC}"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    echo "Install it with: sudo apt install gh (Ubuntu/Debian) or brew install gh (macOS)"
    exit 1
fi

# Check if authenticated with GitHub
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}Not authenticated with GitHub. Running 'gh auth login'...${NC}"
    gh auth login
fi

# Check if repo already exists on GitHub
if gh repo view "$REPO_NAME" &> /dev/null; then
    echo -e "${RED}Error: Repository '$REPO_NAME' already exists on GitHub.${NC}"
    exit 1
fi

# Initialize git repo (skip for existing repos)
if [ "$EXISTING" = false ]; then
    echo -e "${GREEN}Initializing git repository...${NC}"
    git init
fi

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    echo -e "${YELLOW}Creating basic .gitignore...${NC}"
    cat > .gitignore << 'EOF'
# OS files
.DS_Store
Thumbs.db

# Editor directories and files
.idea/
.vscode/
*.swp
*.swo
*~

# Logs
logs/
*.log

# Dependencies
node_modules/
vendor/
__pycache__/
*.pyc

# Environment variables
.env
.env.local
.env.*.local

# Build outputs
dist/
build/
out/
target/

# Scripts
init.sh
ralph.sh
ralphoc.sh

# Nix flake build
result
EOF

    # Add planning/AI entries only for public repos
    if [ "$PRIVATE" = false ]; then
        cat >> .gitignore << 'EOF'

# Project planning
PRD.md
progress.txt

# Claude
.claude/
EOF
    fi
fi

# Create initial commit if needed
if ! git rev-parse --verify HEAD &> /dev/null; then
    echo -e "${GREEN}Creating initial commit...${NC}"
    git add .
    git commit -m "Initial commit"
fi

# Create GitHub repository
echo -e "${GREEN}Creating GitHub repository: $REPO_NAME${NC}"

# Fail if origin exists when using -e
if [ "$EXISTING" = true ] && git remote get-url origin &> /dev/null; then
    echo -e "${RED}Error: Remote 'origin' already exists. Remove or rename it before using -e.${NC}"
    exit 1
fi

# Set visibility based on flag
if [ "$PRIVATE" = true ]; then
    VISIBILITY="--private"
    echo -e "${YELLOW}Creating as PRIVATE repository${NC}"
else
    VISIBILITY="--public"
    echo -e "${YELLOW}Creating as PUBLIC repository${NC}"
fi

# Create the repo
if gh repo create "$REPO_NAME" $VISIBILITY --source=. --remote=origin --push; then
    echo -e "${GREEN}✓ Repository created successfully!${NC}"
    
    # Show repo URL
    REPO_URL=$(gh repo view --json url -q .url)
    echo ""
    echo -e "${GREEN}=====================================  ${NC}"
    echo -e "${GREEN}✓ All done! Your repository is live at:${NC}"
    echo -e "${GREEN}$REPO_URL${NC}"
    echo -e "${GREEN}=====================================${NC}"
else
    echo -e "${RED}Failed to create repository. Check the error message above.${NC}"
    exit 1
fi