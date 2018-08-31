#!/bin/bash

rm -rf /home/jrivera/projects/github/openshift/openshift-ansible/.tox
tar -czf openshift-ansible.tgz -C /home/jrivera/projects/github/openshift openshift-ansible
scp -rF ssh-config *ansible-inventory* openshift-ansible.tgz master:/vagrant/
vagrant ssh master -c "cd /vagrant; mkdir -p repo/; rm -rf repo/openshift-ansible* repo/noarch openshift-ansible; tar --warning=no-timestamp -xzf openshift-ansible.tgz; cd openshift-ansible; tito build --test --rpm -o /vagrant/repo; createrepo /vagrant/repo; cd; sudo yum remove -y openshift-ansible*; sudo yum --disablerepo=* --enablerepo=openshift-local makecache; sudo yum install -y --enablerepo=epel-testing openshift-ansible*"
