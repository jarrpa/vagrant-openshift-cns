#!/bin/bash

INVENTORY="${INVENTORY:-/vagrant/ansible-inventory}"
PREREQ=${PREREQ:-1}
INSTALL=${INSTALL:-1}

# OpenShift < 3.9
#vagrant ssh master -c "sudo -s time ansible-playbook -i ${INVENTORY} -e oreg_url='openshift/origin-\${component}:latest' $@ /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml"

# OpenShift >= 3.9
if [[ "$PREREQ" == "1" ]]; then
#  vagrant ssh master -c "sudo -s time ansible-playbook -i ${INVENTORY} -e oreg_url='192.168.121.1:5000/openshift/origin-\${component}:latest' $@ /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml" || exit 1
  vagrant ssh master -c "sudo -s time ansible-playbook -i ${INVENTORY} -e oreg_url='openshift/origin-\${component}:latest' $@ /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml" || exit 1
fi

if [[ "$INSTALL" == "1" ]]; then
#  vagrant ssh master -c "sudo -s time ansible-playbook -i ${INVENTORY} -e oreg_url='192.168.121.1:5000/openshift/origin-\${component}:latest' $@ /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml"
  vagrant ssh master -c "sudo -s time ansible-playbook -i ${INVENTORY} -e oreg_url='openshift/origin-\${component}:latest' $@ /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml"
fi

paplay glass.ogg
