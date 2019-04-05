#!/bin/bash
#Centos 7
#访问控制配置文件的权限设置
chown root:root /etc/hosts.allow
chown root:root /etc/hosts.deny
chmod 644 /etc/hosts.deny
chmod 644 /etc/hosts.allow

#设置用户权限配置文件的权限
chown root:root /etc/passwd /etc/shadow /etc/group /etc/gshadow
chmod 0644 /etc/group  
chmod 0644 /etc/passwd  
chmod 0400 /etc/shadow  
chmod 0400 /etc/gshadow

#确保SSH LogLevel设置为INFO,记录登录和注销活动
sed -i 's/#LogLevel INFO/LogLevel INFO/g' /etc/ssh/sshd_config

#禁止SSH空密码用户登录 
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config

#设置较低的Max AuthTrimes参数,将降低SSH服务器被暴力攻击成功的风险。
sed -i 's/#MaxAuthTries 6/MaxAuthTries 4/g' /etc/ssh/sshd_config

#设置SSH空闲超时退出时间,可降低未授权用户访问其他用户ssh会话的风险
sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 900/g' /etc/ssh/sshd_config
sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 0/g' /etc/ssh/sshd_config

#设置密码失效时间，强制定期修改密码，减少密码被泄漏和猜测风险，使用非密码登陆方式(如密钥对)请忽略此项。
sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/g' /etc/login.defs
chage --maxdays 90 root

#设置密码修改最小间隔时间，限制密码更改过于频繁
sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t7/g' /etc/login.defs
chage --mindays 7 root

#它将进程的内存空间地址随机化来增大入侵者预测目的地址难度，从而降低进程被成功入侵的风险
sysctl -w kernel.randomize_va_space=2

#检查密码长度和密码是否使用多种字符类型
sed -i 's/# minlen = 9/minlen = 10/g' /etc/security/pwquality.conf
sed -i 's/# minclass = 0/minclass = 3/g' /etc/security/pwquality.conf