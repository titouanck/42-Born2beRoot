#!/bin/bash

architecture=$(uname -a)

cpu_physical=$(nproc --all)

vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)

memory_usage=$(free -m | grep Mem | awk '{print $3}' | tr -d \\n \
&& echo -n "/" \
&& free -m | grep Mem | awk '{print $2}' | tr -d \\n \
&& echo -n "MB (" \
&& printf "%.2f" $(free -m | grep Mem | awk '{print $3/$2 * 100.0}') \
&& echo "%)")

disk_usage=$(df --total -h | grep total | awk '{print $3}' | tr -d \\n | sed 's/.$//' \
&& echo -n "/" \
&& df --total -h | grep total | awk '{print $2}')

cpu_load=$(printf "%.2f" $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | tr -d \\n) \
&& echo -n "%")

last_boot=$(who -b | awk '{print $3 " " $4}')

if grep -q "/dev/mapper" /etc/fstab
then
    lvm_use="yes"
else
    lvm_use="no"
fi

connexions_tcp=$(netstat -an | grep tcp | grep ESTABLISHED | wc -l | tr -d \\n \
&& echo " ESTABLISHED")

user_log=$(users | wc -w)

network_ip=$(hostname -I | awk '{print $1}' | tr -d \\n \
&& echo -n " (" \
&& /usr/sbin/ifconfig -a | grep ether | grep Ethernet | awk '{print $2}' | tr -d \\n \
&& echo ")")

sudo=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l | tr -d \\n \
&& echo " cmd")

wall  "
#Architecture: $architecture
#CPU physical : $cpu_physical
#vCPU : $vcpu
#Memory Usage: $memory_usage
#Disk Usage: $disk_usage
#CPU load: $cpu_load
#Last boot: $last_boot
#LVM use: $lvm_use
#Connexions TCP : $connexions_tcp
#User log: $user_log
#Network: $network_ip
#Sudo : $sudo
"
