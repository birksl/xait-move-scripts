#!/bin/zsh
while IFS="" read -r p || [ -n "$p" ]
do
    p="${p%\"}"
    p="${p#\"}"
    print "$p"
    ./loc.sh $p $p
    sleep 3
done < oproles.txt
