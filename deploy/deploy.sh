#!/bin/bash

#VPS IP地址
VPS_IP=""
#默认VPS服务器端口
VPS_PORT=768
#VPS服务器密码
VPS_PASS=""

#安装shadowsocks服务
function installSS() {
    yum install -y m2crypto python-setuptools
    easy_install pip
    pip install shadowsocks
    echo "完成安装shadowsocks，开始校验..."
    #校验shadowsocks服务是否安装
    ls /usr/bin/ | grep 'ssserver' > /dev/null
    if [ $? -eq 0 ]; then
        echo "shadowsocks安装完成..."
        return 0
    else
        echo "shadowsocks安装失败..."
        return 1
    fi
}

#生成shadowsocks.json
function createConf() {
    echo "
    {
    \"server\":\"$VPS_IP\",
    \"server_port\":$VPS_PORT,
    \"local_port\":1080,
    \"password\":\"$VPS_PASS\",
    \"timeout\":600,
    \"method\":\"aes-256-cfb\"
    }" > /etc/shadowsocks.json
    echo "生成shadowsocks.json文件完成..."
    return 0
}

#收集参数
function collect() {
    #需要VPS服务器IP
    echo "请输入VPS服务器的IP地址，可以从购买的VPS服务器中查找..."
    read VPS_IP
    while [ -z "$VPS_IP" ]; do
        echo "输入的VPS服务的IP地址不能为空，请输入VPS的IP地址..."
        read VPS_IP
    done
    echo "请输入VPS对外服务的端口，请输入一个系统未使用的端口，也可以不输入，默认端口号$VPS_PORT..."
    read TEMP_PORT
    if [ -n "$TEMP_PORT" ]; then
        VPS_PORT=$TEMP_PORT
    fi
    echo "请输入VPS服务密码..."
    read VPS_PASS
    while [ -z "$VPS_PASS" ]; do
        echo "输入的VPS服务密码不能为空，请输入一个可用的VPS服务密码..."
        read VPS_PASS
    done
    return 0
}

#修改防火墙，允许端口通过
function accessPort() {
    #判断是否已经开启
    isExist=`firewall-cmd --query-port=$VPS_PORT/tcp`
    if [ "$isExist" == "yes" ]; then
        echo "防火墙开启"$VPS_PORT"端口完成..."
        return 0
    fi
    #永久开启端口
    firewall-cmd --zone=public --add-port=$VPS_PORT/tcp --permanent
    firewall-cmd --reload
    echo "防火墙开启"$VPS_PORT"端口完成..."
    return 0
}

#判断服务是否已经启动
function isStarted() {
    ps -ef | grep 'ssserver' | grep 'shadowsocks' > /dev/null
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

function start() {
    ssserver -c /etc/shadowsocks.json -d start
    #校验是否启动成功
    if ! isStarted; then
        echo "shadowsocks服务启动失败！"
        return 1
    fi
    echo "shadowsocks服务启动成功，配置信息如下："
    echo "服务器地址：$VPS_IP"
    echo "服务器端口：$VPS_PORT"
    echo "服务密码：$VPS_PASS"
    echo "请在shadowsocks客户端按照上述参数进行配置，即可进行happy的上网了！！！"
    return 0
}

#主函数
function main() {
    #已经启动，不再重新启动
    if isStarted; then
        echo "shadowsocks服务已经启动，不需要再启动..."
        return 0
    fi
    collect
    installSS
    #安装shadowsocks服务失败，则返回
    if [ $? -ne 0 ]; then
        return 1
    fi
    #生成shadowsocks.json
    createConf
    #设置端口
    accessPort
    #启动服务
    start
}

main