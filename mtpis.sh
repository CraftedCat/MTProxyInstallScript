#!/bin/bash
export DIR="/opt"
export BINDIR="/opt/MTProxy/objs/bin"
export CronFile="/etc/cron.daily/mtproxy-multi"
DEB_PACKAGE_NAME="htop curl git build-essential openssl libssl-dev zlib1g-dev nginx-light mc"
YUM_PACKAGE_NAME="htop curl git openssl-devel zlib-devel vim-common"
YUM_PACKAGE_GROUP_NAME="Development Tools"
BOLD='\033[1m'       #  ${BOLD}
LGREEN='\033[1;32m'     #  ${LGREEN}
LBLUE='\033[1;34m'     #  ${LBLUE}
BGGREEN='\033[42m'     #  ${BGGREEN}
BGGRAY='\033[47m'     #  ${BGGRAY}
BREAK='\033[m'       #  ${BREAK}
regex='^[0-9]+$'

if cat /etc/*release | grep ^NAME | grep CentOS; then
    echo "==============================================="
    echo "Installing packages $YUM_PACKAGE_NAME on CentOS"
    echo "==============================================="
    yum install -y $YUM_PACKAGE_NAME
    yum groupinstall -y $YUM_PACKAGE_GROUP_NAME
 elif cat /etc/*release | grep ^NAME | grep Red; then
    echo "==============================================="
    echo "Installing packages $YUM_PACKAGE_NAME on RedHat"
    echo "==============================================="
    yum install -y $YUM_PACKAGE_NAME
    yum groupinstall -y $YUM_PACKAGE_GROUP_NAME
 elif cat /etc/*release | grep ^NAME | grep Fedora; then
    echo "================================================"
    echo "Installing packages $YUM_PACKAGE_NAME on Fedorea"
    echo "================================================"
    yum install -y $YUM_PACKAGE_NAME
    yum groupinstall -y $YUM_PACKAGE_GROUP_NAME
 elif cat /etc/*release | grep ^CentOS; then
    echo "================================================"
    echo "Installing packages $YUM_PACKAGE_NAME on Fedorea"
    echo "================================================"
    OS="CentOS6"
    yum install -y $YUM_PACKAGE_NAME
    yum groupinstall -y $YUM_PACKAGE_GROUP_NAME
 elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Ubuntu"
    echo "==============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Debian ; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Debian"
    echo "==============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Mint ; then
    echo "============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Mint"
    echo "============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Knoppix ; then
    echo "================================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Kanoppix"
    echo "================================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
 else
    echo "OS NOT DETECTED, couldn't install package $PACKAGE"
    exit 1;
 fi

clear
if [[ "${OS}" = "CentOS6" ]]; then
    wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
    yum install devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++ -y
    export CC=/opt/rh/devtoolset-2/root/usr/bin/gcc  
    export CPP=/opt/rh/devtoolset-2/root/usr/bin/cpp
    export CXX=/opt/rh/devtoolset-2/root/root/usr/bin/c++
fi

clear
echo -en "\n${BOLD} Script install required packages, MTProto Proxy, startup script${BREAK}\n\n"
cd $DIR && git clone https://github.com/CraftedCat/MTProxy.git && cd MTProxy && make
cd $DIR/MTProxy/objs/bin && curl -s https://core.telegram.org/getProxySecret -o proxy-secret && curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf

#Generate SECRET
if [ -n "$1" ]
then
    secret=$1
else
    secret=$(head -c 16 /dev/urandom | xxd -ps)
fi

#Obtain proxy IP
IP=$(wget --timeout=1 --tries=1 -qO- ipinfo.io/ip)
if [[ "${IP}" = "" ]]; then
    IP=$(wget --timeout=1 --tries=1 -qO- ipecho.net/plain)
fi
if [[ "${IP}" = "" ]]; then
    IP=$(wget --timeout=1 --tries=1 -qO- icanhazip.com)
fi
if [[ "${IP}" = "" ]]; then
    IP=$(wget --timeout=1 --tries=1 -qO- ident.me)
fi

#Set up proxy port
if [ -n "$2" ]
then
    PORT=$2
else
    echo -en "Set up ${LGREEN}PORT${BREAK} for proxy:"
    read -p "" -e -i 443 PORT
    #Check PORT via regex
        if ! [[ $PORT =~ $regex ]] ; then
            echo "$(tput setaf 1)Error:$(tput sgr 0) PORT invalid"
            exit 1
        fi
    #Check PORT limits
    if [ $PORT -gt 65535 ] ; then
	echo "$(tput setaf 1)Error:$(tput sgr 0): PORT must be less than 65536"
	exit 1
    fi
fi

#Dialog
echo -en "Go to Telegram bot ${LGREEN}@MTProxybot${BREAK}, send command ${LGREEN}/newproxy${BREAK}\n"
echo -en "Send ${LGREEN}${IP}:${PORT}${BREAK} after answer, send secret in hex: ${LGREEN}${secret}${BREAK}\n"
#Receive TAG
if [ -n "$3" ]
then
    tag=$3
else
    echo -en "Copy proxy ${LGREEN}TAG${BREAK} and write me:" 
    read tag
fi
echo -en "Received tag: ${BGGRAY}${LBLUE}${tag}\n${BREAK}"
echo -en "${BOLD}Making startup script...${BREAK}\n"

if [[ "${OS}" != "CentOS6" ]]; then
touch /etc/systemd/system/mtproxy.service
echo "[Unit]
Description=MTProxy
After=network.target

[Service]
WorkingDirectory=${BINDIR}
ExecStart=${BINDIR}/mtproto-proxy -u nobody -p 8888 -H ${PORT} -S ${secret} -P ${tag} --aes-pwd proxy-secret proxy-multi.conf
Restart=on-failure
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=mtproxy
OOMScoreAdjust=-100

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/mtproxy.service
echo -en "${BOLD}Making Cron script...${BREAK}\n\n"
touch ${CronFile} && chmod +x ${CronFile}
echo "#!/bin/bash
curl -s https://core.telegram.org/getProxySecret -o ${BINDIR}/proxy-secret
curl -s https://core.telegram.org/getProxyConfig -o ${BINDIR}/proxy-multi.conf
" > ${CronFile}
systemctl enable mtproxy && systemctl start mtproxy
else

echo "#!/bin/bash
nohup {$BINDIR}/mtproto-proxy -u nobody -p 8888 -H ${PORT} -S ${secret} -P ${tag} --aes-pwd ${BINDIR}proxy-secret ${BINDIR}/proxy-multi.conf >> /var/log/messages &"
chmod +x /etc/init.d/mtproxy
iptables -I INPUT 5 -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
service iptables save && chkconfig --add mtproxy && service mtproxy start
fi

echo -e  "===================================\n"
echo -en "${LGREEN}Install Complete!${BREAK}\n"
echo -en "Check status: ${BOLD}systemctl status mtproxy${BREAK}\n"
echo -en "Proxy Link with Random Padding: ${BOLD}tg://proxy?server=${IP}&port=${PORT}&secret=dd${secret}${BREAK}\n"


