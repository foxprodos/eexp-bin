#!/usr/bin/perl
use Getopt::Long;

# 参数：单行输出选择。屏幕提示输出选择。
GetOptions('1' => \$oneline, 'n'=>\$notify);

my $out,$in;
# 无参数时，使用剪贴板内容。
$in=$ARGV[0]; if(!$in){$in=`xsel -o`;} if(!$in){exit;}
open(SDCV,"sdcv -n $in|");
my $r;
while($l=<SDCV>){
if($l!~/^$/){$r=$l;chomp($r);$r=~s/-->//;}
else{$out="$r --> ";last;}
}
while($l=<SDCV>){
if($l=~/相关|^$/){
close(SDCV);
if($notify){`notify-send -u critical -i '/home/exp/媒体/128软件png/pidgin.png' 'sdcv翻译' "$out"`;}
else{print $out;}
exit;
}
chomp($l) if($oneline);
$out.=" ► $l";
}


