#!/bin/zsh
set -eu
NEXTROLE=$(sed -i '' -e '1 w /dev/stdout' -e '1d' oproles.txt)
cd "~/mover/xpo-moving/$NEXTROLE/"