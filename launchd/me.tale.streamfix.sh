#!/bin/bash
# We check for 2 instances of parsecd because the host daemon is always running
# If the actual application is open, there will be 2 instances of parsecd
if test $(pgrep -x -- parsecd | wc -l) -eq 2 || test $(pgrep Moonlight); then
	if ifconfig awdl0 | grep "status: active" > /dev/null; then
		ifconfig awdl0 down
		printf '[%s] (%s) %s\n' "me.tale.streamfix" "$(date '+%H:%M:%S')" "'awdl0' disabled"
		exit 0
	fi
else
	if ifconfig awdl0 | grep "status: inactive" > /dev/null; then
		ifconfig awdl0 up
		printf '[%s] (%s) %s\n' "me.tale.streamfix" "$(date '+%H:%M:%S')" "'awdl0' enabled"
		exit 0
	fi
fi

