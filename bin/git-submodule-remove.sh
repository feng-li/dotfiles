#!/bin/bash

# Exit on error
set -e

# Check for path argument
if [ -z "$1" ]; then
    echo "Usage: $0 path/to/submodule"
    echo "Run 'git submodule' shows"

    git submodule
    exit 1
fi

SUBMODULE_PATH="$1"

# Ensure path exists
if [ ! -d "$SUBMODULE_PATH" ]; then
  echo "Error: Directory '$SUBMODULE_PATH' does not exist."
  exit 1
fi

echo "Removing submodule: $SUBMODULE_PATH"


# Remove from .gitmodules
if grep -q "submodule.\"$SUBMODULE_PATH\"" .gitmodules; then
  git config -f .gitmodules --remove-section "submodule.$SUBMODULE_PATH"
  git add .gitmodules  # <--- Add this line!
  echo "Removed entry from .gitmodules and staged changes"
fi


# Remove from .git/config
if git config --get "submodule.$SUBMODULE_PATH.path" >/dev/null; then
  git config --remove-section "submodule.$SUBMODULE_PATH"
  echo "Removed entry from .git/config"
fi

# Remove from index
git rm --cached "$SUBMODULE_PATH"
echo "Removed submodule from Git index"

# Delete directory
rm -rf "$SUBMODULE_PATH"
echo "Deleted submodule directory"

# Remove cached module info
rm -rf ".git/modules/$SUBMODULE_PATH"
echo "Removed submodule metadata"

# Commit the change
git commit -m "Removed submodule $SUBMODULE_PATH"
echo "Committed submodule removal"

echo "✅ Submodule '$SUBMODULE_PATH' removed successfully!"
