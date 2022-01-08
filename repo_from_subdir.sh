#!/bin/zsh
###########################################################################
# Script for extracting subdirectories of large remote git repositories
# into new standalone repositories with their files as root and preserved
# commit history for that subdirectory. Commit hashes are not preserved
# since root is changed and therefor all the commits.
# The script can be used either manually for single subdirectories or with
# automation for all subdirectories in a directory of a repository.
#
### Dependencies
# git-filter-repo
# in PATH
###########################################################################

### Set variables for access
# Hosts where the repos are hosted
GITHOST_FROM="https://gitlab.xait.no"
GITHOST_TO="https://gitlab.xait.no"
# GROUPS or USER to get subdirectory from and make new repository in
FROM_REPO="OP/xaitporter-operations.git"  # Repo where subdirectory is located
FROM_REPO_FOLDER="xaitporter-operations"  # Needed to cd into repo once cloned
TO_REPO="ansible-roles/old-xaitporter-operations/$2.git"  # Can be an existing repo or name of a new repo, name of the new repo
### Remember to includ user or group in path

# Path to subdir in origin FROM_REPO
DIRRPATH="ansible/roles"
# Name of subdir
DIRR=$1

echo "$DIRR, $TO_REPO"


#set -e  # Disabled exit on any error because the script uses an error to determine existence of repos
## This block is for using the script manually
#[ -z "$1" ] && echo "Specify directory name" && exit;
#printf -v DIRR "%s" $1
#echo "Directory to make repository of: $DIRR"

### Pre checks
## Check if remote repository to clone from exists
git ls-remote $GITHOST_FROM/$FROM_REPO
if [ $? -ne 0 ]
then
    echo "No repository to clone from at $GITHOST_FROM/$FROM_REPO. Aborting operation"
    exit 1
fi
echo "Repository to clone from found at $GITHOST_FROM/$FROM_REPO. Proceeding with operations."

## Check if remote repository already exists where you want to make new the new one
git ls-remote $GITHOST_TO/$TO_REPO
if [ $? -eq 0 ]
then
    echo "A repository already exists at $GITHOST_TO/$TO_REPO. Aborting operation"
    exit 1
fi
echo "No repository found at $GITHOST_TO/$TO_REPO. Proceeding to create it"
### END Prechecks

# Clone the repo without any files actually downloaded
git clone --no-checkout -b master $GITHOST_FROM/$FROM_REPO
# Enter the directory to separate out
cd "$FROM_REPO_FOLDER/"
# Enable sparse checkout so only necessary files are downloaded
git sparse-checkout set "$DIRRPATH/$DIRR/"
# Check out the necessary files in the directory
git checkout
# Rewrite history so only commits relating to the subdirectory are left and set it as the root
git filter-repo --subdirectory-filter "$DIRRPATH/$DIRR"
#
# Create a remote and push the modified repository to it
git push --set-upstream $GITHOST_TO/$TO_REPO master
# Status message
echo "Pushed to new git repository"
