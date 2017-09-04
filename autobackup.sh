#!/bin/bash
#数据库和网站程序自动备份


################---- 数据库配置 ----################ 
DB_HOST = localhost #数据库地址
DB_USER = root  #数据库用户名
DB_PASSWD = "123456" #数据库密码
DB_NAME = blog #数据库名
BACK_DATE=$(date +%Y%m%d)  #日期显示样式：20170830

################---- 数据库备份 ----################
BackSQL=/data/backup/blog/blog/${BACK_DATE}blog.sql  #以日期命名保存

#删除旧备份
backup_log=/data/backup/blog/backup.log
rm -rf /data/backup/blog/blog/*
echo "" > $backup_log

#导出最新mysql数据
mysqldump --socket=/tmp/mysql.sock -u$DB_USER -p${DB_PASSWD} $DB_NAME > $BackSQL

#写入日志
if [ ! -f $Backsql ]; then
	echo "数据库备份失败！  `date`" >> $backup_log
else
	echo "数据库备份成功！	 `date`" >> $backup_log
fi

################---- WEB备份 ----################

cp -R /data/www/blog /data/backup/blog/
Blogback=/data/backup/blog/blog

if [ ! -d "$Blogback" ]; then
	echo "WEB备份失败！  		 `date`" >> /data/backup/blog/backup.log
else
	echo "WEB备份成功！  		 `date`" >> /data/backup/blog/backup.log
fi

#将备份数据打包
tar -zcPf /data/backup/blog.tar.gz /data/backup/blog/blogg
#将备份数据发送至邮箱
tarblog=/data/backup/blog.tar.gz
MAIL=123456@qq.com

mail -a $tarblog -s "数据备份报告！  `(date +%Y-%m-%d)`"  $MAIL < $backup_log

rm -rf $tarblog   #删除打包文件
