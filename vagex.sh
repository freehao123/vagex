#!/bin/bash
#更新时间2017.2.9

#写一个通用匹配的程序，以后就直接用这个了

#安装判断系统程序
yum install lsb –y

#取操作系统的名称
Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
	else
        DISTRO='unknow'
    fi
    Get_OS_Bit
}

Get_OS_Bit()
{
    if [[ `getconf WORD_BIT` = '32' && `getconf LONG_BIT` = '64' ]] ; then
        ver3='x64'
    else
        ver3='x32'
    fi
}

Get_Dist_Name

release=$DISTRO
#发行版本
if [ "$release" == "Debian" ]; then
	ver1str="lsb_release -rs | awk -F '.' '{ print \$1 }'"
else
	ver1str="lsb_release -rs | awk -F '.' '{ print \$1\".\"\$2 }'"
fi
ver1=$(eval $ver1str)
#ver11=`echo $ver1 | awk -F '.' '{ print $1 }'`

echo "================================================="
echo "操作系统：$release "
echo "发行版本：$ver1 "
echo "内核版本：$ver2 "
echo "位数：$ver3 "
echo "================================================="

#安装相应的软件

if [ "$release" == "CentOS" ]; then
  echo "A.CentOS 5.x"
  echo "B.CentOS 6.x"
  echo "请选择相应的发行版本系统（输入数字序号）："
  #read number
  if [ "$?" == "" ]; then
      echo "未选择任何发行版本，脚本退出"
  exit 1
  elif ["$?" == "A"];then
    echo "您选择的操作系统是CentOS 5.x"
    echo "正在为您安装软件"
    yum groupinstall xfce-4.4
    yum install vnc vnc-server
  elif ["$?" == "B"];then
    echo "您选择的操作系统是CentOS 6.x"
    echo "正在为您安装软件"
    wget https://raw.githubusercontent.com/catonisland/Vagex-For-CentOS-6/master/epel-release-6-8.noarch.rpm;
    rpm -ivh epel-release-6-8.noarch.rpm
    yum groupinstall -y xfce
    yum install -y tigervnc tigervnc-server
  else
    echo "目前该脚本只支持CentOS 5.x、CentOS 6.x，其他系统会在以后更新"
    echo "感谢支持嘻哈小屋！"
    echo "欢迎您的再次来访：www.edu-ing.cn"
    exit 1
  fi
fi
if [[ "$release" == "Ubuntu" ]] || [[ "$release" == "Debian" ]]; then
  echo "暂时不支持该操作系统"
  echo "目前该脚本只支持CentOS 5.x、CentOS 6.x，其他系统会在以后更新"
  echo "感谢支持嘻哈小屋！"
  echo "欢迎您的再次来访：www.edu-ing.cn"
  exit 1
fi
if [ "$ver1" == "" ]; then
  echo "脚本获得不了操作系统版本号，错误退出"
  exit 1
fi

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
#查找是否安装NetworkManager
echo "查看是否安装NetworkManager"
echo "若有安装请卸载"
find / -name NetworkManager
