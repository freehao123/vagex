#!/bin/bash
#下载安装 Xfce 4.4 和 VNC
yum groupinstall xfce-4.4
yum install vnc vnc-server
#关闭防火墙（重启后生效）
chkconfig iptables off
#写入配置文件
cat > /etc/sysconfig/vncservers<<EOF
VNCSERVERS="1:root"
VNCSERVERARGS[1]="-geometry 800x600"
EOF
#创建密码
echo
echo
echo "You will be requested to enter a password not less than six digits."
vncpasswd
#启动服务
vncserver
#写入配置文件
cat > /root/.vnc/xstartup<<EOF
#!/bin/sh
/usr/bin/startxfce4
EOF
#配置权限
chmod +x ~/.vnc/xstartup
#重启
service vncserver restart
#开机启动
chkconfig vncserver on
#安装火狐
yum -y install firefox
