#!/bin/bash

export MINIONS=${MINIONS:-3}
export INVENTORY="/vagrant/ansible-inventory"

for cmd in "$@"; do
  script=$(cut -d ' ' -f 1 -s <<< "${cmd}")
  args=$(cut -d ' ' -f 2- -s <<< "${cmd}")
  ./${script:-${cmd}}.sh ${args} || exit 1
done
