#!/bin/bash

scp -rF ssh-config *ansible-inventory* master:/vagrant/

if [ $OPENSHIFT_ANSIBLE_DEVELOPER -eq 1 ]
then
        if  [ -n $OPENSHIFT_ANSIBLE_SOURCE_DIR ] && [ -d $OPENSHIFT_ANSIBLE_SOURCE_DIR ]
        then
                rm -rf ${OPENSHIFT_ANSIBLE_SOURCE_DIR}/.tox
                tar -czf openshift-ansible.tgz -C ${OPENSHIFT_ANSIBLE_SOURCE_DIR}/../ openshift-ansible
                scp -rF ssh-config openshift-ansible.tgz master:/vagrant/
                vagrant ssh master -c "cd /vagrant; mkdir -p repo/; rm -rf repo/openshift-ansible* repo/noarch openshift-ansible; tar --warning=no-timestamp -xzf openshift-ansible.tgz; cd openshift-ansible; tito build --test --rpm -o /vagrant/repo; createrepo /vagrant/repo; cd; sudo yum remove -y openshift-ansible*; sudo yum --disablerepo=* --enablerepo=openshift-local makecache; sudo yum install -y --enablerepo=openshift-local openshift-ansible*"
                rm -rf openshift-ansible.tgz
        else
                echo "OPENSHIFT_ANSIBLE_SOURCE_DIR is not defined"
        fi
else
        vagrant ssh master -c 'sudo yum install -y --enablerepo=epel-testing openshift-ansible*'
fi
