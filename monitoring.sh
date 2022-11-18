#!/bin/bash

echo -n "#Architecture: "
uname -a

echo -n "#CPU physical : "
nproc --all

echo -n "#vCPU : "
cat /proc/cpuinfo | grep processor | wc -l

echo -n "#Memory Usage: "
free -m | grep Mem | awk '{print $3}' | tr -d \\n
echo -n "/"
free -m | grep Mem | awk '{print $2}' | tr -d \\n
echo -n "MB ("
printf "%.2f" $(free -m | grep Mem | awk '{print $3/$2 * 100.0}')
echo "%)"

echo -n "#Disk Usage: "
