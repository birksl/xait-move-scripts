#!/bin/zsh

set -e
echo "================================================================"
echo "[INFO]: This action only commits change to README."
echo "$1"
HOME=$PWD
cd $PWD/$1
read -r LINE < README.md
echo $LINE
if [ "${LINE: -1}" = "/" ]
then
    echo "mangled"
    sed -i '' "s!.*https://gitlab.xait.no/OP/xaitporter-operations/ansible/roles/.*!This repo has been copied here from the subdirectory https://gitlab.xait.no/OP/xaitporter-operations/-/tree/master/ansible/roles/$1!" README.md
else
    echo "non-mangled"
    sed -i '' "s!.*https://gitlab.xait.no/OP/xaitporter-operations/ansible/roles/$1.*!This repo has been copied here from the subdirectory https://gitlab.xait.no/OP/xaitporter-operations/-/tree/master/ansible/roles/$1!" README.md
fi
cat README.md
git add README.md
git commit -m "Fixed link in README to correctly link to original location."
echo "________________________________________________________________"
