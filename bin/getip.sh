#!/bin/bash

/sbin/ifconfig $1 | grep "P-t-P" | gawk -F: '{print $3}' | gawk '{print $1}'
