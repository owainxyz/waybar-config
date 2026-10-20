#!/bin/sh
awk '/^MemTotal:/ {t=$2} /^MemAvailable:/ {a=$2} END {printf "mem: %d MB\n", (t-a)/1024}' /proc/meminfo
