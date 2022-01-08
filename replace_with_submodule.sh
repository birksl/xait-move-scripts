#!/bin/zsh
set -eu
ROLE=$1
echo "******************************"
echo "[INFO]: Executing on ansible/roles/$ROLE"
if [[ $(find ansible/roles -type d -name $ROLE) != "ansible/roles/$ROLE" ]]; then
    echo "[WARNING]: The folder ansible/roles/$ROLE does not exist"
    echo "[INFO]: Stopping operation."
    exit 0
fi
if [[ $(sed -n "s/.*\($ROLE\.\).*/\1/p" .gitmodules) == "$ROLE." ]]; then
    echo "[WARNING]: Already a submodule!"
    echo "[INFO]: Stopping operation."
    exit 0
fi
echo "[STEP]: Remove folder"
read "R?Continue?"
echo "[INFO]: Removing folder"
git rm -rf ansible/roles/$ROLE

echo "[STEP]: Add submodule"
read "R?Continue?"
echo "[INFO]: Adding submodule $ROLE"
git submodule add -b legacy https://gitlab.xait.no/ansible-roles/old-xaitporter-operations/$ROLE.git ansible/roles/$ROLE

echo "[STEP]: Commit"
CM="Replace $ROLE with submodule"
echo "[INFO]: '$CM'"
read "R?Continue?"
echo "[INFO]: Committing"
git commit -m "$CM"

echo "[INFO]: Finished replacing $ROLE with  its submodule."
echo "______________________________"
