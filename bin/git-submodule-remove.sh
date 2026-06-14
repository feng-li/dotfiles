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

# Ensure the path is known to Git or present on disk.
if ! git config -f .gitmodules --get "submodule.$SUBMODULE_PATH.path" >/dev/null 2>&1 \
   && ! git ls-files --error-unmatch "$SUBMODULE_PATH" >/dev/null 2>&1 \
   && [ ! -e "$SUBMODULE_PATH" ]; then
  echo "Error: Submodule '$SUBMODULE_PATH' is not known to Git."
  exit 1
fi

echo "Removing submodule: $SUBMODULE_PATH"

# Remove from .gitmodules
if git config -f .gitmodules --get "submodule.$SUBMODULE_PATH.path" >/dev/null 2>&1; then
  git config -f .gitmodules --remove-section "submodule.$SUBMODULE_PATH"
  git add .gitmodules
  echo "Removed entry from .gitmodules and staged changes"
fi

# Remove from .git/config
if git config --get "submodule.$SUBMODULE_PATH.path" >/dev/null; then
  git config --remove-section "submodule.$SUBMODULE_PATH"
  echo "Removed entry from .git/config"
fi

# Remove from index
if git ls-files --error-unmatch "$SUBMODULE_PATH" >/dev/null 2>&1; then
  git rm --cached "$SUBMODULE_PATH"
  echo "Removed submodule from Git index"
fi

# Delete directory if present
if [ -e "$SUBMODULE_PATH" ] || [ -L "$SUBMODULE_PATH" ]; then
  rm -rf "$SUBMODULE_PATH"
  echo "Deleted submodule directory"
fi

# Remove cached module info
if [ -d ".git/modules/$SUBMODULE_PATH" ]; then
  rm -rf ".git/modules/$SUBMODULE_PATH"
  echo "Removed submodule metadata"
fi

# Commit the change
git commit -m "Removed submodule $SUBMODULE_PATH"
echo "Committed submodule removal"

echo "Submodule '$SUBMODULE_PATH' removed successfully!"
