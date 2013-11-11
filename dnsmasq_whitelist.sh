#!/bin/sh
WAN_DNS="`nvram get wan_get_dns`"
[ -z "$WAN_DNS" ] && WAN_DNS="`nvram get wan_dns`"
echo $WAN_DNS | grep " " >/dev/null 2>&1
if [ $? = 0 ];then
        FORWARDDNSISP=$(echo $WAN_DNS | awk '{print $1}')
else
        FORWARDDNSISP=$WAN_DNS
fi
FORWARDDNSISP="127.0.0.1#5353"
FORWARDDNS="127.0.0.1#5454"


whitelist() {
    cd /tmp
    /opt/bin/wget -q --no-check-certificate https://github.com/n0wa11/gfw_whitelist/raw/master/whitelist.pac -O whitelist.txt
    sed -i 's/ //g' whitelist.txt        #remove all space
    grep '^"\.' whitelist.txt > whitelist.tmp #get all domain line
    echo 'converting whitelist to domain list...'
    sed -i 's/^"\.//g' whitelist.tmp   #remove the leading ""."
    sed -i 's/\/.*$//g' whitelist.tmp  #remove anything after "/", including "/"
    sed -i 's/\"//g' whitelist.tmp     #remove """ if any, due to gfwlist's flawed lines
    sed -i 's/\,//g' whitelist.tmp     #remove "," if any, due to gfwlist's flawed lines
    sort whitelist.tmp | uniq > dnswhitelist.txt
    sed -i -e "s/.*/server=\/&\/$FORWARDDNSISP/" dnswhitelist.txt
    rm whitelist.*
    mv -f /tmp/dnswhitelist.txt /opt/etc/dnsmasq/custom/whitelist.cfg
    echo 'done.'
}

whitelist
