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
CRS = ENV['CRS'] ? ENV['CRS'].to_i : 0
DISKS = 3
CACHE = true
RHEL = false

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
            lv.storage_pool_name = "MINE"
            lv.storage :file, :device => "vdb", :path => "master-docker.disk", :size => '500G'
            lv.sound_type = "ich6"
        end

        minions = (0..MINIONS-1).map {|j| "node#{j}"}
        masters = ["master"]
        cluster = CRS ? [minions[0]] : minions
        cluster[cluster.length] = "master"
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
                "vagrant_home"  => ENV['VAGRANT_HOME'] ? ENV['VAGRANT_HOME'] : "~/.vagrant.d",
                "vagrant_cache" => ENV['VAGRANT_CACHE'] ? ENV['VAGRANT_CACHE'] : CACHE,
		"custom_registry" => "192.168.121.1:5000",
                "external_glusterfs" => CRS ? "true" : "false",
                "rhel" => RHEL
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
                lv.storage_pool_name = "MINE"
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
