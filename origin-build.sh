#!/bin/bash

set -e

export ANSIBLE_TIMEOUT=60
export MINIONS=0
export ORIGIN_BUILD=1

vagrant up --no-provision \
    && vagrant provision

if [ $? -eq 0 ]; then
  vagrant ssh-config > ssh-config
  rm -f origin.tgz
  pushd /home/jrivera/projects/github/openshift/origin
  git checkout ${1:-master}
  git pull
  popd
  tar -czf origin.tgz -C /home/jrivera/projects/github/openshift origin
  scp -rF ssh-config origin.tgz master:
  vagrant ssh master -c "sudo systemctl start docker && rm -rf origin && tar -xzf origin.tgz && cd origin && OS_BUILD_ENV_PRESERVE=_output/local sudo hack/env OS_ONLY_BUILD_PLATFORMS='linux/amd64' hack/build-rpm-release.sh && tar -czvf origin-repo.tgz -C _output/local/releases/ rpms"
  scp -rF ssh-config master:origin/origin-repo.tgz ./
  mkdir -p repo/
  tar -xzvf origin-repo.tgz --strip-components=1 -C repo/
  createrepo_c repo/
  rm -f origin.tgz origin-repo.tgz
fi

paplay glass.ogg
