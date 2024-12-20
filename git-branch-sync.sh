#!/bin/sh

set -e

SOURCE_REPO=$1
SOURCE_BRANCH=$2
DESTINATION_REPO=$3
DESTINATION_BRANCH=$4
CLONE_DIR=$(basename "$SOURCE_REPO" .git)  # Remove the. git suffix as the clone directory name
DRY_RUN=$5

GIT_SSH_COMMAND="ssh -v"
export GIT_SSH_COMMAND  # Export environment variables so that git commands can be used

echo "SOURCE=$SOURCE_REPO"
echo "SOURCE_BRANCH=$SOURCE_BRANCH"
echo "DESTINATION=$DESTINATION_REPO"
echo "DESTINATION_BRANCH=$DESTINATION_BRANCH"
echo "DRY RUN=$DRY_RUN"

# Clone the source repository to a temporary directory (non mirrored)
git clone "$SOURCE_REPO" "$CLONE_DIR" && cd "$CLONE_DIR"

# Switch to the specified branch
git checkout "$SOURCE_BRANCH"

# Get the latest branch information
git fetch origin "$SOURCE_BRANCH"

# Ensure that the branch exists
if ! git show-ref --heads --quiet "refs/heads/$SOURCE_BRANCH"; then
  echo "ERROR: Branch '$SOURCE_BRANCH' not found in source repository."
  exit 1
fi

#Add the target repository as remote (if not already added)
#Note: This assumes that the target warehouse is an empty warehouse or an existing warehouse, but does not include updates from the source branch
git remote add destination "$DESTINATION_REPO"

#Push the specified branch to the target warehouse
#Note: If the target branch does not exist, git push will automatically create it
if [ "$DRY_RUN" = "true" ]; then
  echo "INFO: Dry Run, no data is pushed"
  # Simulate push commands (without actually executing push)
  echo "git push destination $SOURCE_BRANCH:$DESTINATION_BRANCH -f"
else
  git push destination "$SOURCE_BRANCH:$DESTINATION_BRANCH" -f
fi