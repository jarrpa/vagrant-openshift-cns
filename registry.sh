#!/bin/bash

INVENTORY="${INVENTORY:-/vagrant/ansible-inventory}"

vagrant ssh master -c "sudo -s time ansible-playbook -i ${INVENTORY} -e oreg_url='openshift/origin-\${component}:latest' $@ /usr/share/ansible/openshift-ansible/playbooks/openshift-glusterfs/registry.yml"
paplay glass.ogg
