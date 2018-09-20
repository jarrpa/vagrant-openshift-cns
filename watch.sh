#!/bin/bash

vagrant ssh master -c "sudo watch -n1 oc get ${@:-dc,rc,route,svc,po,ds,pvc} --all-namespaces -o wide"
