#!/bin/zsh
SCRIPT="./.sh"
HOME=$PWD
ROLES="oproles.txt"
LEFT=$(wc -l < $ROLES)
echo "Running script: $SCRIPT on all entries in file $ROLES."
read "REPLY?Are you sure? "
echo "$REPLY"
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    while IFS="" read -r p || [ -n "$p" ]
    do
        # cd $HOME/$p
        # echo $PWD
        # ls -l
        echo "$LEFT roles left"
        eval "$SCRIPT $p"
        LEFT=$((LEFT-1))
        #exit 0
        sleep 1
    done < $ROLES
    exit 0
fi
echo "No confirmation. Aborting operation."