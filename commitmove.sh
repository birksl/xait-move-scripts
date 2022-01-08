#!/bin/zsh
set -e
echo "================================================================"
echo "$1"
HOME=$PWD
cd $PWD/$1

set +e

git config --local user.email "birk.lewin@xait.no"
git config --local user.name "Birk Lewin"
git remote add origin "https://gitlab.xait.no/ansible-roles/old-xaitporter-operations/$1.git"
git remote set-url origin "https://gitlab.xait.no/ansible-roles/old-xaitporter-operations/$1.git"

echo "This repo has been copied here from the subdirectory https://gitlab.xait.no/OP/xaitporter-operations/ansible/roles/$1" >> README.md
git add README.md
git commit -m "Moved subdirectory https://gitlab.xait.no/OP/xaitporter-operations/ansible/roles/$1 into this standalone repo"
git push
echo "________________________________________________________________"