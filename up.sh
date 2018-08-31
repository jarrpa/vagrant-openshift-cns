#!/bin/sh

export ANSIBLE_TIMEOUT=60
vagrant up --no-provision $@ \
    && vagrant provision

if [ $? -eq 0 ]; then
  vagrant ssh-config > ssh-config
  vagrant ssh master -c "sudo yum install -y docker; sudo systemctl start docker"
  ./refresh.sh
  vagrant sandbox on
fi
paplay glass.ogg
