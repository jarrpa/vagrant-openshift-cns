#!/bin/bash

INVENTORY="${INVENTORY:-/vagrant/ansible-inventory}"

vagrant ssh master -c "sudo -s time ansible-playbook -i ${INVENTORY}-glusterfs -e oreg_url='openshift/origin-\${component}:latest' $@ /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-glusterfs/config.yml"
paplay glass.ogg
