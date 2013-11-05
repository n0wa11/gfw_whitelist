#!/bin/sh

sed -e "/^var IP_ADDRESS/cvar IP_ADDRESS = '127.0.0.1:7070';" -e "/^var PROXY_TYPE/cvar PROXY_TYPE = 'SOCKS5';" whitelist.pac > examples/whitelist_socks5_7070.pac
sed -e "/^var IP_ADDRESS/cvar IP_ADDRESS = '127.0.0.1:8081';" -e "/^var PROXY_TYPE/cvar PROXY_TYPE = 'PROXY';" whitelist.pac > examples/whitelist_http_8081.pac

