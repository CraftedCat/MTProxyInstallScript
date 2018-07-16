#!/bin/bash
export DIR="/opt"
export BINDIR="/opt/MTProxy/objs/bin"
export CronFile="/etc/cron.daily/mtproxy-multi"
DEB_PACKAGE_NAME="htop curl git build-essential openssl libssl-dev zlib1g-dev"
YUM_PACKAGE_NAME="htop curl git openssl-devel zlib-devel"
YUM_PACKAGE_GROUP_NAME="Development Tools"
BOLD='\033[1m'       #  ${BOLD}
LGREEN='\033[1;32m'     #  ${LGREEN}
LBLUE='\033[1;34m'     #  ${LBLUE}
BGGREEN='\033[42m'     #  ${BGGREEN}
BGGRAY='\033[47m'     #  ${BGGRAY}
BREAK='\033[m'       #  ${BREAK}

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
echo -en "\n${BOLD} Script install required packages, MTProto Proxy, startup script${BREAK}\n\n"
cd $DIR && git clone https://github.com/TelegramMessenger/MTProxy.git && cd MTProxy && make
cd $DIR/MTProxy/objs/bin && curl -s https://core.telegram.org/getProxySecret -o proxy-secret && curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
secret=$(head -c 16 /dev/urandom | xxd -ps)
echo -en "Go to Telegram bot ${LGREEN}@MTProxybot${BREAK}, send command ${LGREEN}/newproxy${BREAK}\n"
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

echo -en "Send ${LGREEN}${IP}:443${BREAK} after answer, send secret in hex: ${LGREEN}${secret}${BREAK}\n"
echo -en "Copy proxy ${LGREEN}TAG${BREAK} and write me:" 
read tag
echo -en "Received tag: ${BGGRAY}${LBLUE}${tag}\n${BREAK}"
echo -en "${BOLD}Making startup script...${BREAK}\n"
touch /etc/systemd/system/mtproxy.service
echo "[Unit]
Description=MTProxy
After=network.target

[Service]
WorkingDirectory=${BINDIR}
ExecStart=${BINDIR}/mtproto-proxy -u nobody -p 8888 -H 443 -S ${secret} -P ${tag} --aes-pwd proxy-secret proxy-multi.conf
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
echo -e  "===================================\n"
echo -en "${LGREEN}Install Complete!${BREAK}\n"
echo -en "check status ${BOLD}systemctl status mtproxy${BREAK}\n"
