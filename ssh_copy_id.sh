#!/usr/bin/env bash
cat hostsname.txt | while read ips pwds; do 
sshpass -p $pwds ssh-copy-id -i ~/.ssh/id_rsa.pub "root@$ips -o StrictHostKeyChecking=no" 
done
