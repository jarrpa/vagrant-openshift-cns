#!/bin/bash

NODES="${@:-master node0}"

for node in ${NODES}; do
  echo -n "Getting images from ${node} ... "
  IMAGES=$(vagrant ssh node0 -c "sudo -s -- docker images --format \"{{.Repository}} {{.Tag}}\"" -- -q | tr "[:cntrl:]" "\n")
  PUSHES=""
  echo "OK"

  while read -r IMAGE; do
    if [[ "$IMAGE" == "" ]]; then continue; fi
    REPO=$(echo $IMAGE | cut -f1 -d " " -)
    NAME=${REPO#[^/]*/}
    TAG=$(echo $IMAGE | cut -f2 -d " " -)
    if [[ "${TAG}" == "<none>" ]]; then
      TAG=""
    else
      TAG=":${TAG}"
    fi
    PUSHES+=" ${NAME}${TAG}"
  done <<< "$IMAGES"

  echo "Pushing images from ${node}:"
  for push in ${PUSHES}; do
    echo "  ${push}"
  done

  vagrant ssh node0 -c "for push in ${PUSHES}; do sudo docker tag \$push 192.168.121.1:5000/\$push; sudo docker push 192.168.121.1:5000/\$push; done" -- -qn

  echo "Done"
done
paplay glass.ogg
