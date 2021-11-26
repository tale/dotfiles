#!/bin/bash
if test $(pgrep -x -- parsecd | wc -l) -eq 2; then
	# When Parsec runs 2 instances of the Daemon, we are in remote play
	# Many people suggested disabling Location Services & AirDrop to stop stuttering
	# This network interface controls that ability so we disable it
	if /sbin/ifconfig awdl0 | grep "status: active" > /dev/null; then
		/sbin/ifconfig awdl0 down
		echo "Disabled awdl0"
	fi

else
	if /sbin/ifconfig awdl0 | grep "status: inactive" > /dev/null; then
		/sbin/ifconfig awdl0 up
		echo "Enabled awdl0"
	fi
fi
