#!/bin/bash
export DIR="/opt"
export CronFile="/etc/cron.daily/mtproxy-multi"
BOLD='\033[1m'       #  ${BOLD}
LGREEN='\033[1;32m'     #  ${LGREEN}
LBLUE='\033[1;34m'     #  ${LBLUE}
BGGREEN='\033[42m'     #  ${BGGREEN}
BGGRAY='\033[47m'     #  ${BGGRAY}
BREAK='\033[m'       #  ${BREAK}
clear
apt-get update && apt-get install htop curl git build-essential openssl libssl-dev zlib1g-dev -y
clear
echo -en "\n${BOLD} Script install required packages, MTProto Proxy, startup script${BREAK}\n\n"
cd $DIR && git clone https://github.com/TelegramMessenger/MTProxy.git && cd MTProxy && make
cd $DIR/MTProxy/objs/bin && curl -s https://core.telegram.org/getProxySecret -o proxy-secret && curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
secret=$(head -c 16 /dev/urandom | xxd -ps)
echo -en "Go to Telegram bot ${LGREEN}@MTProxybot${BREAK}, send command ${LGREEN}/newproxy${BREAK}\n"
IP=$(wget -qO- eth0.me)
echo -en "Send ${LGREEN}${IP}:443${BREAK}, and this secret in hex: ${LGREEN}${secret}${BREAK}\n"
echo "Copy proxy tag and write me:" 
read tag
echo -en "Received tag: ${BGGRAY}${LBLUE}${tag}\n${BREAK}"
echo -en "${BOLD}Making startup script...${BREAK}\n"
touch /etc/systemd/system/mtproxy.service
echo "[Unit]
Description=MTProxy
After=network.target

[Service]
WorkingDirectory=${DIR}/MTProxy/objs/bin
ExecStart=${DIR}/MTProxy/objs/bin/mtproto-proxy -u nobody -p 8888 -H 443 -S ${secret} -P ${tag} --aes-pwd proxy-secret proxy-multi.conf
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

curl -s https://core.telegram.org/getProxyConfig -o ${DIR}/proxy-multi.conf
" > ${CronFile}
systemctl enable mtproxy && systemctl start mtproxy
echo -e  "===================================\n"
echo -en "${LGREEN}Install Complete!${BREAK}\n"
echo -en "check status ${BOLD}systemctl status mtproxy${BREAK}\n"
