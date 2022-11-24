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

disk_usage=$(df -t ext4 --total -BM | grep total | awk '{print $3}' | tr -d \\n | sed 's/.$//' \
&& echo -n "/" \
&& df -t ext4 --total -BG | grep total | awk '{print $2}')

cpu_load=$(printf "%.2f" $(mpstat | grep all | awk '{print $3+$4+$5+$6+$7+$8+$9+$10+$11}' | tr -d \\n) \
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

sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l | tr -d \\n \
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
