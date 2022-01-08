#!/bin/zsh
while IFS="" read -r p || [ -n "$p" ]
do
    p="${p%\"}"
    p="${p#\"}"
    print "$p"
    echo $p >> oproles.txt
done < oldops.txt
