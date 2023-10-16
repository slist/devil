#!/bin/sh

# Run fake Linux malware
/app/cctest

# Run a cryptominer during 20s. It should be blocked if you have "Endpoint Standard" feature
timeout 20s /app/xmrig-6.18.0/xmrig

# Run abnormal connection (not seen during Carbon Black training period)
curl google.com -c 5

# External port scan
timeout 60s nmap -sT -T5 -n -p80,443 -iR 100

# Internal port scan
timeout 60s nmap -sT -T5 -n -p80,443 `ip a sh | grep inet | grep -v 127 | cut -d" " -f 6 | cut -d"/" -f 1 | grep -v ::`/24

# Connect to malicious destination
curl http://112.17.28.39

# Sleep 10 years
/bin/sleep 3650d

