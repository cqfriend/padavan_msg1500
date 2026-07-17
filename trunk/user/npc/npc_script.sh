#!/bin/sh
#from aaron
killall npc
mkdir -p /tmp/npc
tmpconf="/tmp/npc/npc.conf"
LOGFILE="/tmp/npc.log"

if [ -f $tmpconf ] ; then 
	rm $tmpconf
fi

npc_enable=`nvram get npc_enable`
server_addr=`nvram get npc_server_addr`
server_port=`nvram get npc_server_port`
protocol=`nvram get npc_protocol`
vkey=`nvram get npc_vkey`
compress=`nvram get npc_compress`
crypt=`nvram get npc_crypt`
Log_level=`nvram get npc_log_level`

if [ -s "/etc/storage/npc.conf" ] ; then
	cp -f /etc/storage/npc.conf $tmpconf
else
	echo "[common]" >$tmpconf
	echo "server_addr=$server_addr:$server_port" >>$tmpconf
	echo "conn_type=$protocol" >>$tmpconf
	echo "vkey=$vkey" >>$tmpconf
	echo "auto_reconnection=true" >>$tmpconf

	if [ "$compress" = "1" ] ; then
		echo "compress=true" >>$tmpconf
	else
		echo "compress=false" >>$tmpconf
	fi

	if [ "$crypt" = "1" ] ; then
		echo "crypt=true" >>$tmpconf
	else
		echo "crypt=false" >>$tmpconf
	fi
fi

if [ "$npc_enable" = "1" ] ; then
	npc_bin="/usr/bin/npc"
	npc_v=`nvram get npc_v`
	if [ ! -z "$npc_v" ] ; then
		if [ -f "/tmp/npc/npc" ] && [ "`cat /tmp/npc/npc_version 2>/dev/null`" = "$npc_v" ] ; then
			npc_bin="/tmp/npc/npc"
		else
			logger -t "NPC" "正在下载指定版本 $npc_v npc客户端..."
			rm -rf /tmp/npc
			mkdir -p /tmp/npc
			wget -t5 --timeout=20 --no-check-certificate -O /tmp/npc/npc.tar.gz "https://github.com/yisier/nps/releases/download/v${npc_v}/linux_mipsle_client.tar.gz"
			if [ "$?" = "0" ] ; then
				tar -xzf /tmp/npc/npc.tar.gz -C /tmp/npc
				chmod +x /tmp/npc/npc
				echo "$npc_v" > /tmp/npc/npc_version
				npc_bin="/tmp/npc/npc"
				logger -t "NPC" "指定版本 $npc_v npc客户端下载成功并已解压。"
			else
				logger -t "NPC" "指定版本 $npc_v npc客户端下载失败，将使用系统内置版本！"
			fi
		fi
	fi

	if [ ! -f "$npc_bin" ] ; then
		logger -t "NPC" "未找到 npc 客户端，尝试下载默认版本..."
		mkdir -p /tmp/npc
		wget -t5 --timeout=20 --no-check-certificate -O /tmp/npc/npc.tar.gz "https://github.com/yisier/nps/releases/download/v0.26.36/linux_mipsle_client.tar.gz"
		if [ "$?" = "0" ] ; then
			tar -xzf /tmp/npc/npc.tar.gz -C /tmp/npc
			chmod +x /tmp/npc/npc
			npc_bin="/tmp/npc/npc"
		else
			logger -t "NPC" "下载默认客户端失败，无法启动！"
			exit 1
		fi
	fi

	$npc_bin -config=$tmpconf -log_level=$Log_level -log_path=$LOGFILE -debug=false 2>&1 &
fi
