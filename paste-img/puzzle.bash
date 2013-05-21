#!/bin/bash

#for i in "$@"; do echo \"${i#file://}\" >>~/tmp; done
#exit
cd "`dirname "$1"`"
f=`exif -m -t 0x9003 "${1#file://}"`
echo $f|grep '^20'
if [ $? -eq 1 ]; then
f="noexif-"`date '+%Y-%m-%d_%H-%M-%S'`
else
f=`echo $f|sed 's/\ /_/g'|sed 's/:/-/g'`
fi

s=`identify -format "%wx%h" "$1"`
x=`echo $s|cut -dx -f1`
y=`echo $s|cut -dx -f2`
echo -e "$1 ---->\t$f\t$s"
if [ $x -gt $y ]; then
p=0.99; s=720
else
p=1.5; s=480
#if [ $# -lt 5 ]; then p=0; s=600; fi
fi
t=`echo "sqrt($#)+$p"|bc -l`
t=`echo $t|cut -d. -f1`
#t=`printf %d $t`
if [ $# -lt 4 ]; then
if [ $x -gt $y ]; then
t=1
else
t=$#
fi
fi
echo -e "\e[34m输出：$f\t文件：$#\t缩放宽度：$s\t列数：$t\e[0m"

rm /tmp/4in1*
convert -scale $s "$@" /tmp/4in1
montage -tile $t -geometry +0+0 -background none /tmp/4in1* ./p-$f.jpg
eog "./p-$f.jpg"
zenity --question --title=删除 --text="是否 $# 个删除文件"
[ $? -eq 0 ] && echo "删除。。。" && for i in "$@"; do j=${i#file://}; echo $j>>~/tmp; rm "$j"; done
#[ $? -eq 0 ] && echo "删除。。。" && rm "$@"
