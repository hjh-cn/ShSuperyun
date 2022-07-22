#!/usr/bin/env bash

Green="\033[32m"
Red="\033[31m"
Yellow="\033[43;37m"
blue="\033[44;37m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#=================================================
#整合 By ShSuperyun
#=================================================

#全局参数
download="wget -N --no-check-certificate"
#download="curl -O -L"

#检查账号
check_root(){
	if [[ $EUID != 0 ]];then
		echo -e "${RedBG}当前不是root账号，建议更换root账号使用。${Font}"
		sleep 5
	else
		echo -e "${GreenBG}root账号权限检查通过.${Font}"
		sleep 2
	fi
}

#安装依赖
sys_install(){
    if ! type wget >/dev/null 2>&1; then
        echo -e "${RedBG}wget 未安装，正在安装中。。。${Font}"
	    apt-get install wget -y || yum install wget -y
    else
        echo -e "${GreenBG}wget 已安装.${Font}"
    fi
}

#核心文件
get_opsy(){
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

#变量引用
opsy=$( get_opsy )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
ipaddr=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
ipdz=$(curl -s myip.ipip.net | awk -F '：' '{print $3}')

#脚本菜单
start_linux(){
    echo -e "整合 By ShSuperyun 默认提供本地备份版"
    echo -e "更新时间：2022/04/19 15:00"
    echo -e "V1.2 Bata 新增标签功能"
    echo -e "操作系统${Green} $opsy ${Font}"
    echo -e  "CPU${Green} $cores ${Font}核 "
    echo -e  "系统内存${Green} $tram ${Font}MB"
    echo -e "IP地址${Green} $ipaddr $ipdz ${Font}"
    echo -e "${Green}1${Font}  {工具}VPS信息和性能测试"
    echo -e "${Green}2${Font}  {工具}Bench系统性能测试"
    echo -e "${Green}3${Font}  {工具}Linux系统实用功能"
    echo -e "${Green}4${Font}  {工具}Linux修改交换内存"
    echo -e "${Green}5${Font}  {工具}Linux修改服务器DNS"
    echo -e "${Green}6${Font}  {工具}流媒体区域限制测试"
    echo -e "${Green}7${Font}  {工具}Linux系统bbr-tcp加速"
    echo -e "${Green}8${Font}  {工具}Linux网络重装dd系统"
    echo -e "${Green}9${Font}  {工具}Frps服务端-管理脚本"
    echo -e "${Green}10${Font}  {工具}Frps客户端-管理脚本"
    echo -e "${Green}11${Font}  {面板}Nezha哪吒监控-云探针"
    echo -e "${Green}12${Font}  {面板}ServerStatus-云探针"
    echo -e "${Green}13${Font}  iptables-端口转发"
    echo -e "${Green}14${Font}  {面板}彩虹EP一键安裝（仅限centos)"
    echo -e "${Green}15${Font}  {面板}kos工具箱（仅限centos)"
    echo -e "${Green}16${Font}  {代理}x-ui（xray）"
   #echo -e "${Green}17${Font}  {代理}v2-ui（V2ray）"
    echo -e "${Green}18${Font}  {代理}ShadowsocksR 一键安装/管理脚本，支持单端口/多端口切换和管理"
    echo -e "${Green}19${Font}  {代理}ShadowsocksR 一键安装/管理脚本，支持流量控制"
    echo -e "${Green}20${Font}  {代理}ShadowsocksR 批量快速验证账号可用性"
    echo -e "${Green}21${Font}  {代理}ShadowsocksR 账号在线监控网站"
    echo -e "${Green}22${Font}  {代理}ShadowsocksR 检测每个端口链接IP数"
    echo -e "${Green}23${Font}  {代理}Mtproto Proxy 一键安装脚本"
    echo -e "${Green}24${Font}  {反向代理}Caddy 一键安装脚本"
    echo -e "${Green}25${Font}  {下载器}Aria2 一键安装脚本"
    echo -e "${Green}26${Font}  {代理}Ocserv AnyConnect 一键安装脚本"
    echo -e "${Green}27${Font}  {其他}iptables 垃圾邮件(SPAM)/BT/PT 一键封禁脚本"
    echo -e "${Green}28${Font}  {代理}Socks5代理软件:Brook 一键安装脚本"
    echo -e "${Green}29${Font}  {代理}HTTP代理软件:GoFlyway 一键安装脚本"
    echo -e "${Green}30${Font}  {下载器}Cloud Torrent 一键安装脚本"
    echo -e "${Green}31${Font}  {下载器}Peerflix Server 一键安装脚本"
    echo -e "${Green}32${Font}  {工具}nps内网穿刺"
    echo -e "${Green}33${Font}  {工具}安装BBR"
    echo -e "${Green}34${Font}  {工具}一键提升VPS速度"
    echo -e "${Green}35${Font}  {代理}Cloudflare WARP 一键配置"
    echo -e "${Green}36${Font}  {代理}安装V2ary_233一键"
    echo -e "${Green}37${Font}  {代理}安装Tg专用代理（Go语言版）"
    echo -e "${Green}38${Font}  {代理}安装TG专用代理（中文版）"
    echo -e "${Green}39${Font}  {工具}superbench性能测试"
    echo -e "${Green}40${Font}  {工具}回程线路测试(命令:./huicheng 您的IP)"
    echo -e "${Green}41${Font}  {工具}傻瓜式一键DD包（OneDrive源）"
    echo -e "${Green}42${Font}  {工具}傻瓜式一键DD包（Google Drive源）"
    echo -e "${Green}43${Font}  {代理}XRAY一键证书+伪装站点"
    echo -e "${Green}44${Font}  {代理}CF自动优选"
    echo -e "${Green}45${Font}  {工具}VPS一键3网测速脚本"
    echo -e "${Green}46${Font}  {工具}Docker-Compose安装"
    echo -e "${Green}47${Font}  {工具}闲蛋探针+中转一键搭建"
    echo -e "${Green}48${Font}  {工具}portainer可视化容器中文版一键安装"
    echo -e "${Green}49${Font}  {代理}L2TP一键安装"
    echo -e ""
    echo -e "${Green}99${Font}  退出当前脚本"
    echo -e -n "${Green}请输入对应功能的${Font}  ${Red}数字：${Font}"
    
    read num
    case $num in
    1)
        ${download} https://d54nomvcoxyoh.cloudfront.net/xncs.sh && chmod +x xncs.sh && bash xncs.sh
        ;;
    2)
        ${download} https://d54nomvcoxyoh.cloudfront.net/bench.sh && chmod +x bench.sh && bash bench.sh
        ;;
    3)
        ${download} https://d54nomvcoxyoh.cloudfront.net/tools.sh && chmod +x tools.sh && bash tools.sh
        ;;
    4)
        ${download} https://d54nomvcoxyoh.cloudfront.net/swap.sh && chmod +x swap.sh && bash swap.sh
        ;;
    5)
        ${download} https://d54nomvcoxyoh.cloudfront.net/dns.sh && chmod +x dns.sh && bash dns.sh
        ;;
    6)
        ${download} https://d54nomvcoxyoh.cloudfront.net/check.sh && chmod +x check.sh && bash check.sh
        ;;
    7)
        ${download} https://d54nomvcoxyoh.cloudfront.net/tcp.sh && chmod +x tcp.sh && bash tcp.sh
        ;;
    8)
        ${download} https://d54nomvcoxyoh.cloudfront.net/net-install.sh && chmod a+x net-install.sh && bash net-install.sh
        ;;
    9)
        ${download} https://d54nomvcoxyoh.cloudfront.net/frps.sh && chmod +x frps.sh && bash frps.sh
        ;;
    10)
        ${download} https://d54nomvcoxyoh.cloudfront.net/frpc.sh && chmod +x frpc.sh && bash frpc.sh
        ;;
    11)
        ${download} https://d54nomvcoxyoh.cloudfront.net/nezha.sh && chmod +x nezha.sh && bash nezha.sh
        ;;
    12)
        ${download} https://d54nomvcoxyoh.cloudfront.net/status.sh && chmod +x status.sh && bash status.sh
        ;;
    13)
        ${download} https://d54nomvcoxyoh.cloudfront.net/dkzf.sh && chmod +x dkzf.sh && bash dkzf.sh
        ;;
    14)
        yum -y install wget;wget http://kangle.cccyun.cn/start;sh start
        ;;
    15)
        yum install -y wget;wget -q kos.f2k.pub -O kos && sh kos
        ;;
    16)
        bash <(curl -Ls https://d54nomvcoxyoh.cloudfront.net/x-uiinstall.sh)
        ;;
    17)
        echo -e "脚本已下架"
        ;;
    18)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/ssr.sh && chmod +x ssr.sh && bash ssr.sh
        ;;
    19)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/ssrmu.sh && chmod +x ssrmu.sh && bash ssrmu.sh
        ;;
    20) 
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/ssr_check.sh && chmod +x ssr_check.sh &&bash ssr_check.sh
        ;;
    21) 
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/ssrstatus.sh && chmod +x ssrstatus.sh && bash ssrstatus.sh
        ;;
    22) 
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/ssr_ip_check.sh && chmod +x ssr_ip_check.sh
        ;;
    23) 
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/mtproxy.sh && chmod +x mtproxy.sh && bash mtproxy.sh
        ;;
    24)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh
        ;;
    25)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/aria2.sh && chmod +x aria2.sh && bash aria2.sh
        ;;
    26)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/ocserv.sh && chmod +x ocserv.sh && bash ocserv.sh
        ;;
    27)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/Get_Out_Spam.sh && chmod +x Get_Out_Spam.sh && bash Get_Out_Spam.sh add
        ;;
    28)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/brook.sh && chmod +x brook.sh && bash brook.sh
        ;;
    29)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/goflyway.sh && chmod +x goflyway.sh && bash goflyway.sh
        ;;
    30)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/cloudt.sh && chmod +x cloudt.sh && bash cloudt.sh
        ;;
    31)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/pserver.sh && chmod +x pserver.sh && bash pserver.sh
        ;;
    32)
        wget -P /root -N --no-check-certificate "https://d54nomvcoxyoh.cloudfront.net/linux_amd64_server.tar.gz" && tar -zxvf linux_amd64_server.tar.gz && ./nps install && nps start
        ;;
    33)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/tcp2.sh)
        ;;
    34)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/tools2.sh && chmod +x tools2.sh && bash tools2.sh
        ;;
    35)
        bash <(curl -fsSL https://d54nomvcoxyoh.cloudfront.net/warp.sh) menu
        ;;
    36)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/V2Ray.sh)
        ;;
    37)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/mtproxy_go.sh)
        ;;
    38)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/mtproxy.sh && chmod +x mtproxy.sh && bash mtproxy.sh
        ;;
    39)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/superbench.sh)
        ;;
    40)
        wget -N --no-check-certificate https://d54nomvcoxyoh.cloudfront.net/huicheng && chmod +x huicheng
        ;;
    41)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/dd-od.sh)
        ;;
    42)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/dd-gd.sh)
        ;;
    43)
        bash -c "$(curl -fsSL https://d54nomvcoxyoh.cloudfront.net/xray_install.sh)"
        ;;
    44)
        bash <(curl -sSL "https://d54nomvcoxyoh.cloudfront.net/cf.sh")	
        ;;
    45)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/superspeed.sh)
        ;;
    46)
        bash <(curl -sSL https://d54nomvcoxyoh.cloudfront.net/DockerInstallation.sh)
        ;;
    47)
        bash <(wget --no-check-certificate -qO- 'https://d54nomvcoxyoh.cloudfront.net/xiandan.sh')
        ;;
    48)
        bash <(curl -L -s https://d54nomvcoxyoh.cloudfront.net/x86.sh)
        ;;
    49)
        bash <(curl -s -L https://d54nomvcoxyoh.cloudfront.net/l2tp.sh)
        ;;
    99)
        echo -e "\n${GreenBG}感谢使用！欢迎下次使用！${Font}\n" && exit
        ;;
    *)
        echo -e "\n${RedBG}未找到该功能！正在退出！${Font}\n" && exit
        ;;
    esac
}

#脚本启动
echo
check_root
echo
sys_install
echo
start_linux