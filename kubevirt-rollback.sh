#!/bin/sh

#vagrant sandbox rollback $@
ssh -qF ssh-config master "sudo rm -rf kubevirt-ansible"
scp -qrF ssh-config /home/jrivera/projects/github/kubevirt-ansible master:
scp -qrF ssh-config ansible-inventory master:kubevirt-ansible/inventory
ssh -qF ssh-config master "sudo yum remove -qy openshift-ansible*; sudo rm -f /etc/yum.repos.d/openshift-local.repo"
paplay glass.ogg
