#!/bin/sh

flashcount=$(/bin/pgrep npviewer.bin | /usr/bin/wc -l)

if [ $flashcount = 1 ]
then
	/usr/bin/killall npviewer.bin
fi
