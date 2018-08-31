#!/bin/bash

ansible-playbook -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" -e "vagrant_home=${VAGRANT_HOME:-~/.vagrant.d}" -e "vagrant_cache=True" -e "external_glusterfs=${CRS}" -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory $@ yum_cache.yml
