#!/bin/bash

echo -n "#Architecture: " > /tmp/monitoringsh--file
uname -a >> /tmp/monitoringsh--file

echo -n "#CPU physical : " >> /tmp/monitoringsh--file
nproc --all >> /tmp/monitoringsh--file

echo -n "#vCPU : " >> /tmp/monitoringsh--file
cat /proc/cpuinfo | grep processor | wc -l >> /tmp/monitoringsh--file

echo -n "#Memory Usage: " >> /tmp/monitoringsh--file
free -m | grep Mem | awk '{print $3}' | tr -d \\n >> /tmp/monitoringsh--file
echo -n "/" >> /tmp/monitoringsh--file
free -m | grep Mem | awk '{print $2}' | tr -d \\n >> /tmp/monitoringsh--file
echo -n "MB (" >> /tmp/monitoringsh--file
printf "%.2f" $(free -m | grep Mem | awk '{print $3/$2 * 100.0}') >> /tmp/monitoringsh--file
echo "%)" >> /tmp/monitoringsh--file

echo -n "#Disk Usage: " >> /tmp/monitoringsh--file
df --total -h | grep total | awk '{print $3}' | tr -d \\n | sed 's/.$//' >> /tmp/monitoringsh--file
echo -n "/" >> /tmp/monitoringsh--file
df --total -h | grep total | awk '{print $2}' >> /tmp/monitoringsh--file

echo -n "#CPU load: " >> /tmp/monitoringsh--file
mpstat | grep all | awk '{print $3 "%"}' >> /tmp/monitoringsh--file

echo -n "#Last boot: " >> /tmp/monitoringsh--file
who | awk '{print $3 " " $4}' >> /tmp/monitoringsh--file

echo -n "#LVM use: " >> /tmp/monitoringsh--file
if command -v lvdisplay &> /dev/null
then
    echo "yes" >> /tmp/monitoringsh--file
else
    echo "no" >> /tmp/monitoringsh--file
fi

echo -n "#Connexions TCP : " >> /tmp/monitoringsh--file
netstat -an | grep tcp | grep ESTABLISHED | wc -l | tr -d \\n >> /tmp/monitoringsh--file
echo " ESTABLISHED" >> /tmp/monitoringsh--file

echo -n "#User log: " >> /tmp/monitoringsh--file
users | wc -w >> /tmp/monitoringsh--file

echo -n "#Network: IP " >> /tmp/monitoringsh--file
hostname -i | tr -d \\n >> /tmp/monitoringsh--file
echo -n " (" >> /tmp/monitoringsh--file
ifconfig -a | grep ether | grep Ethernet | awk '{print $2}' | tr -d \\n >> /tmp/monitoringsh--file
echo ")" >> /tmp/monitoringsh--file

echo -n "#Sudo : " >> /tmp/monitoringsh--file
cat /var/log/sudo/sudo.log | grep COMMAND | wc -l | tr -d \\n >> /tmp/monitoringsh--file
echo " cmd" >> /tmp/monitoringsh--file

wall /tmp/monitoringsh--file
rm -f /tmp/monitoringsh--file
