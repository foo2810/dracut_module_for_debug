#!/usr/bin/bash

mount -t debugfs none /sys/kernel/debug
mount -t tracefs none /sys/kernel/tracing

# ls -l /sys/kernel/tracing/
# echo "setup-ftrace.sh: available_filter_functions"
# cat /sys/kernel/tracing/available_filter_functions

cat /proc/zoneinfo

cat /proc/meminfo
