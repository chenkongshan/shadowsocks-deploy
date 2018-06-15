#!/bin/bash

#由于使用serverspeeder锐速对内核要求比较苛刻，因此需要更换为符合条件的内核
#更换完成后会自动重启系统

NEED_KERNEL="3.10.0-229.1.2.el7.x86_64"
#判断系统内核是否已经满足需求
sys_kernel=`uname -r`
if [ "$sys_kernel" == $NEED_KERNEL ]; then
    echo "系统内核满足需求，不需要更改..."
    exit
fi
echo "更换内核需要一段时间，请耐心等待..."
#更换内核
rpm -ivh https://gitee.com/chenkongshan/shadowsocks-deploy/raw/master/resources/kernel-3.10.0-229.1.2.el7.x86_64.rpm --force
echo "更换内核完成..."
#设置启动内核
grub2-set-default `awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | grep '(3.10.0-229.1.2.el7.x86_64) 7 (Core)'|awk '{print $1}'`
echo "设置内核完成，2秒后重启系统..."
sleep 2
reboot