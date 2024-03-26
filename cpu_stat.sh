#!/bin/bash
DATE=$(date +%F" "%H:%M)
IP=$(ifconfig eth0 |awk -F"[ :]+" '/inet addr/{print $4}')  # CentOS6,eth0
MAIL="example@mail.com"
if ! which vmstat &>/dev/null; then
    echo "vmstat command no found, Please install procps package." 
    exit 1
fi
US=$(vmstat 1 3 |awk 'NR==5{print $13}' )
SY=$(vmstat 1 3 |awk 'NR==5{print $14}' )
IDLE=$(vmstat 1 3 |awk 'NR==5{print $15}' )
WAIT=$(vmstat 1 3|awk 'NR==5{print $16}')
USE=$(($US+$SY))
if [ $USE -ge 80 ]; then
    echo "
    Date: $DATE
    Host: $IP
    Problem: CPU utilization $USE
    " | mail -s "CPU Monitor" $MAIL
fi
