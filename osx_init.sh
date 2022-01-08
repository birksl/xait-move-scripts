#!/bin/zsh
# Adapted from ansible-role templates init.sh
set -eu

AUTHORNAME="Server Ops"
#${AUTHORNAME:-"$(git config user.name)"}
ROLENAME=${ROLENAME:-$(basename "$(git rev-parse --show-toplevel)")}
GROUP=${GROUP:-"ansible-roles/old-xaitporter-operations"}



echo "Declaring array"
declare -a FND

echo "Get all files and folders in toplevel directory"
for f in *; do
    # ECHO $f
    FND+=($f)
done
for f in .*; do
    # ECHO $f
    FND+=($f)
done

echo "Set things to copy"
TOCOPY=(meta molecule .gitlab-ci.yml .yamllint .editorconfig README.md)
CPFLAGS="-nR"

echo "Copy items that are not already in the directory"

for item in "$TOCOPY[@]"; do
    if [[ ! " ${FND[*]} " =~ " ${item} " ]]; then
        echo $item
        cp $CPFLAGS ../../ansible-role/$item .
    fi
done


READMELEN=$(wc -l < README.md)
echo "$READMELEN lines in README.md"

if [[ ! " ${FND[*]} " =~ "_README.md" ]]; then
    echo "Making copy of README"
    cp $CPFLAGS ../../ansible-role/README.md _README.md
fi
if [ $READMELEN -lt 4 ]; then
    echo "Concatenating README's"
    echo "\n\n## Origin" >> _README.md
    cat README.md >> _README.md
    mv _README.md README.md
fi
echo "Replacing substitutes"
find . \( -type d -name .git -prune \) -o \( -type d -name files -prune \) -print0 | xargs -0 -I '{}' sed -i '' "s#ROLENAME#$ROLENAME#g" $(echo '{}')
find . \( -type d -name .git -prune \) -o \( -type d -name files -prune \) -print0 | xargs -0 -I '{}' sed -i '' "s#AUTHORNAME#$AUTHORNAME#g" $(echo '{}')
find . \( -type d -name .git -prune \) -o \( -type d -name files -prune \) -print0 | xargs -0 -I '{}' sed -i '' "s#GROUP#$GROUP#g" $(echo '{}')
echo "Done replacing"


## Not needed since I removed this part from the source
# echo "Delete instructions from README"
# sed -i.bak '/<!---begin del-->/,/<!---end del-->/d' _README.md

# echo "Delete .bak files"
# find . -name "*.bak" -print0 | xargs -0 rm

COMMITMESSAGE="Add template for testing."

read "REPLY?Commit initilaization: $COMMITMESSAGE ?"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add -A
    git commit -m "$COMMITMESSAGE"
fi
