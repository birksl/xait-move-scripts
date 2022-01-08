#!/bin/zsh
set -eu

ROLENAME=$(basename "$(git rev-parse --show-toplevel)")
git diff --no-index ../xaitporter-operations/ansible/roles/$ROLENAME/tasks -- tasks
# while IFS="" read -r p || [ -n "$p" ]
# do
#     echo "============================================"
#     cd "$p"
#     ROLENAME=$(basename "$(git rev-parse --show-toplevel)")
#     git diff --no-index ../xaitporter-operations/ansible/roles/$ROLENAME/tasks -- tasks
#     cd ".."
#     echo "____________________________________________"
# done < ~/mover/oproles.txt