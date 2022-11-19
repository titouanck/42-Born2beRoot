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
df --total -h | grep total | awk '{print $3}' | tr -d \\n | sed 's/.$//'
echo -n "/"
df --total -h | grep total | awk '{print $2}'

echo -n "#CPU load: "
mpstat | grep all | awk '{print $3 "%"}'

echo -n "#Last boot: "
who | awk '{print $3 " " $4}'

echo -n "#LVM use: "
if command -v lvdisplay &> /dev/null
then
    echo "yes"
else
    echo "no"
fi

echo -n "#Connexions TCP : "
netstat -an | grep tcp | grep ESTABLISHED | wc -l | tr -d \\n
echo " ESTABLISHED"

echo -n "#User log: "
users | wc -w

echo -n "#Network: IP "
hostname -i | tr -d \\n
echo -n " ("
ifconfig -a | grep ether | grep Ethernet | awk '{print $2}' | tr -d \\n
echo ")"

echo -n "#Sudo : "
cat /var/log/sudo/sudo.log | grep COMMAND | wc -l | tr -d \\n
echo " cmd"
