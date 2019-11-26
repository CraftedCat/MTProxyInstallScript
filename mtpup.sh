
#!/bin/bash
export DIR="/opt"
export BINDIR="/opt/MTProxy/objs/bin"
export CronFile="/etc/cron.daily/mtproxy-multi"

BOLD='\033[1m'       #  ${BOLD}
LGREEN='\033[1;32m'     #  ${LGREEN}
LBLUE='\033[1;34m'     #  ${LBLUE}
BGGREEN='\033[42m'     #  ${BGGREEN}
BGGRAY='\033[47m'     #  ${BGGRAY}
BREAK='\033[m'       #  ${BREAK}

echo -en "\n${BOLD} Script Update MTProto Proxy Files${BREAK}\n\n"
cd $DIR && rm -rf MTProxy && git clone https://github.com/TelegramMessenger/MTProxy && cd MTProxy && make
cd $DIR/MTProxy/objs/bin && curl -s https://core.telegram.org/getProxySecret -o proxy-secret && curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
echo -en "${BOLD}Iptables rules file...${BREAK}\n\n"
echo "iptables -A INPUT -j ACCEPT -p tcp -m tcp --dport 6443" > ${BINDIR}/iptables.sh
systemctl daemon-reload && systemctl restart mtproxy
echo -e  "===================================\n"
echo -en "${LGREEN}Update Complete!${BREAK}\n"
echo -en "check status ${BOLD}systemctl status mtproxy${BREAK}\n"
echo -en "In this version, you need add dd before hex secret! ${BOLD}dd+secret makes clients add random padding to some packets to make DPI detection of mtproxy harder${BREAK}\n"
