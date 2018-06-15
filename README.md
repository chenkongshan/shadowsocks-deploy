# 在vps上一键部署shadowsocks详解
在vps上部署shadowsocks服务，需要安装多个服务，如果安装serverspeeder锐速（对速度提升以及网络稳定性有很大的作用）还需要考虑系统的内核问题，
按照步骤执行我的脚本即可完成一键部署shadowsocks服务。
## 一、VPS的选择
当前只是作为SS服务，所以VPS选择最低配置的就可以了，主要是网速要稳定，我选了作为全球最大的游戏主机提供商之一的 [vultr](https://www.vultr.com/?ref=7261247)，
他们有个最低配置的，每月是2.5美元，折合人民币差不多16.7元每月，原来新注册用户送20美元的优惠没有了，不过他们的服务器也比较的实惠。
### 可选服务器价格
![servers.png](/images/servers.png "servers.png")
### vultr注册地址
[vultr注册](https://www.vultr.com/?ref=7261247)，注册比较简单，只需要输入邮箱和密码就能完成注册。支持信用卡等多种支付方式，
最主要的是现在支持Alipay，即支付宝支付，我觉得这个是比较方便的。
## 二、新建服务器
依次点击 Servers > Deploy New Servers (那个加号).
* Server Location: 就选你要选的机房。当前其他位置的服务器没有$2.5的服务器，只有Miami和New York这两个位置还有，我测试了一下，我这边使用New York的服务器延迟低一些，具体可以自己酌情选择。
* ServerType，使用我的一键脚本部署，必须选择CentOS7 x64，否则部署不成功。
* Server Size: 如果只是 SS 最低配就可以。其它的不用填写也可以，然后点击Deploy Now。
### 等待之后如下图：
![server-list.png](/images/server-list.png "server-list.png")
### 点开你的 Cloud Instance 查看详细的 Information
![server-detail.png](/images/server-detail.png)  
这个详细信息里面包含服务器地址和连接的用户名密码等信息。
### 连接服务器
我是使用Xshell连接的服务器，具体使用什么软件可以自己选择。
## 三、安装说明
有3个脚本需要执行，分别是kernel.sh、speed.sh和deploy.sh，执行命令下面会讲解，首先对这3个脚本做一些说明：
* kernel.sh：这个脚本是用来更改系统内核的，因为serverspeeder锐速对系统内核有严格的要求。脚本执行完成后会重启系统。
* speed.sh：这个脚本是用来安装serverspeeder锐速服务的，安装期间会提示让输入信息，不清楚的话可以一直按Enter键，使用默认值即可。
* deploy.sh：这个脚本是用来安装shadowsocks服务，脚本会让输入服务器IP、使用端口号、服务密码等信息，按照提示填写即可，
    这个脚本执行完成以后，即可使用shaodowsocks服务了。
### 1、更新系统内核
    wget https://gitee.com/chenkongshan/shadowsocks-deploy/raw/master/deploy/kernel.sh && bash kernel.sh
这个脚本执行完成以后会重启系统。
### 2、安装serverspeeder锐速
    wget https://gitee.com/chenkongshan/shadowsocks-deploy/raw/master/deploy/speed.sh && bash speed.sh
### 3、安装shadowsocks
    wget https://gitee.com/chenkongshan/shadowsocks-deploy/raw/master/deploy/deploy.sh && bash deploy.sh
这一步执行完成以后，界面会显示主要的服务器地址、端口号、密码等信息，这个记录下来，在客户端配置时会用到。
### 4、额外说明
第一步和第二步主要是用来安装serverspeeder锐速的，用于提升网络质量，如果不需要的话这两步是可以不执行的，
    只执行第三步安装shadowsocks也可以完成部署。
### 5、参考
[内核与锐速匹配参考](https://github.com/0oVicero0/serverSpeeder_kernel)。
## 四、客户端使用
服务部署完成以后就可以使用了，我这边提供一个Windows的客户端，其他的MAC、IOS、安卓客户端按照自己的需求搜索下载。
[Windows客户端](https://gitee.com/chenkongshan/shadowsocks-deploy/raw/master/client/Shadowsocks-4.0.6.zip)
   
## 最后
到此就可以happy的上网了。希望大家能科学的上网。