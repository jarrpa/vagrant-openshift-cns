# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# If you want to use RHEL:
# Download RHEL Atomic from
# https://access.redhat.com/downloads/content/293/ver=1/rhel---7/1.0.1/x86_64/product-downloads
# Then once downloaded type:
# $ vagrant box add --name rhel/atomic <downloaded rhel atomic box>
# $ vagrant box add --name rhel/7 <downloaded rhel box>
#

MINIONS = ENV['MINIONS'] ? ENV['MINIONS'].to_i : 3
CRS = ENV['CRS'] ? true : false
DISKS = ENV['DISKS'] ? ENV['DISKS'].to_i : 3
CACHE = ENV['VAGRANT_CACHE'] ? true : false
HOME = ENV['VAGRANT_HOME'] ? ENV['VAGRANT_HOME'] : "~/.vagrant.d"
RHEL = ENV['RHEL'] ? true : false
STORAGE_POOL_NAME = ENV['STORAGE_POOL_NAME'] ? ENV['STORAGE_POOL_NAME'] : "default"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    if RHEL
        config.vm.box = "rhel/7"
    else
        config.vm.box = "centos/7"
    end

    # Override
    config.vm.provider :libvirt do |v,override|
#        override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
    end

    config.vm.define :master do |master|
        master.vm.hostname = "master"
        master.vm.network :private_network, ip: "192.168.10.90"

        master.vm.provider :libvirt do |lv|
            lv.memory = ENV['ORIGIN_BUILD'] ? 6144 : 4096
            lv.cpus = 2
            lv.storage_pool_name = STORAGE_POOL_NAME
            lv.storage :file, :device => "vdb", :path => "master-docker.disk", :size => '500G'
            #lv.sound_type = "ich6"
        end

        minions = MINIONS > 0 ? (0..MINIONS-1).map {|j| "node#{j}"} : []
        masters = ["master"]
        cluster = CRS ? [minions[0]] : minions
        cluster[cluster.length] = "master"
        cluster = ["master"]
        gluster = CRS ? minions[1..-1] : []
        master.vm.provision :ansible do |ansible|
            ansible.limit = "all"
            ansible.playbook = "site.yml"
            ansible.groups = {
                "master" => masters,
                "cluster" => cluster, 
                "gluster" => gluster,
            }
            ansible.extra_vars = {
                "vagrant_home"  => HOME,
                "vagrant_cache" => CACHE,
                "external_glusterfs" => CRS.to_s,
                "rhel" => RHEL.to_s
            }

        end

    end

    # Make the glusterfs cluster, each with DISKS number of drives
    (0..MINIONS-1).each do |i|
        config.vm.define "node#{i}" do |node|
            node.vm.hostname = "node#{i}"
            node.vm.network :private_network, ip: "192.168.10.10#{i}"
            node.vm.provider :libvirt do |lv|
                lv.memory = CRS && (i > 0) ? 1024 : 2048
                lv.cpus = 2
                lv.storage_pool_name = STORAGE_POOL_NAME
            end

            driverletters = ('b'..'z').to_a
            (0..DISKS-1).each do |d|
                node.vm.provider :libvirt do  |lv|
                    lv.storage :file, :device => "vd#{driverletters[d]}", :path => "origin-disk-#{i}-#{d}.disk", :size => '500G'
                end
            end
        end
    end
end
