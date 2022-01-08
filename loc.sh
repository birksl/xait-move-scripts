#!/bin/bash

DIRR=$1
NEW=$2

git ls-remote https://gitlab.xait.no/ansible-roles/old-xaitporter-operations/$NEW.git
if [ $? -eq 0 ]
then
    echo "A repository already exists at https://gitlab.xait.no/ansible-roles/old-xaitporter-operations/$NEW.git. Aborting operation"
    exit 1
fi
echo "No repository found at https://gitlab.xait.no/ansible-roles/old-xaitporter-operations/$NEW.git. Proceeding to create it"

git clone xaitporter-operations $NEW

cd $NEW
ls

git filter-repo --subdirectory-filter ansible/roles/$DIRR

git push --set-upstream https://gitlab.xait.no/ansible-roles/old-xaitporter-operations/$NEW.git master
