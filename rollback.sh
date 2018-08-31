#!/bin/sh

vagrant sandbox rollback $@
./refresh.sh
paplay glass.ogg
