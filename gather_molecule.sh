#!/bin/zsh
while IFS="" read -r p || [ -n "$p" ]
do
    if [[ ! $(ls xpo-moving/$p | grep molecule) =~ "molecule" ]]; then
        echo $p
    fi
done < oproles.txt