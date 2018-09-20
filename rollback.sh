#!/bin/sh

vagrant sandbox rollback $@
./refresh.sh

for m in $(vagrant status | grep running | awk '{print $1}'); do
    cmd="-s -- ${@}"
  vagrant ssh $m -c "if (sudo systemctl status origin-node 1>/dev/null 2>&1); then sudo systemctl restart origin-node; fi"
done

paplay glass.ogg
