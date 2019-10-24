#!/bin/bash
dcll () {
if [[ -f base/ok ]] && [[ $(ls data/$yr-$sc-*.dat|wc -l) != 0 ]]
then clear && echo 1st\|2nd\|3rd\|$yr Year \& $sc Section && echo day\|day\|day\|Roll.No
for fl in `ls data/$yr-$sc-*`;do ddat=$(cat $fl) && nbr=$(ls $fl|awk -F'[-|.]' '{print $3}') && for ni in {1..6};do dary[$ni]=-;done
for ((dar=0;dar<=$(echo $ddat|wc -L)-1;dar++));do dary[${ddat:$dar:1}]=${ddat:$dar:1};done
echo $(echo ${dary[*]}|sed 's/[1-6]/A/g'|sed 's/\ /\|/2'|sed 's/\ /\|/3')\|$nbr $(cat base/$yr-$sc.dat|grep ,$nbr,|awk -F',' '{print $4}');done
else clear && echo PLEASE WAIT UNTIL THE ENTRY HAS BEEN COMPLETED!;fi && echo "-----------"
}
adapndcl () {
echo $ip1|while read f1 f2;do f2a1=$(echo $f2|sed 's/[0 7-9A-Z]//g') && if [[ $(echo $f2a1|wc -L) == [1-6] ]]
then for zo in {1..6};do ary[$zo]=0;done && for ((ar=0;ar<=$(echo $f2a1|wc -L)-1;ar++));do ary[${f2a1:$ar:1}]=${f2a1:$ar:1};done
if [[ -f "data/$yr-$sc-$f1.dat" ]];then dat=$(cat data/$yr-$sc-$f1.dat) && for ((ar=0;ar<=$(echo $dat|wc -L)-1;ar++));do ary[${dat:$ar:1}]=${dat:$ar:1};done;else :;fi && echo ${ary[*]} |sed 's/[ 0]//g' > data/$yr-$sc-$f1.dat
else if [[ $(echo $f2a1|wc -L) == 0 ]];then :;else er=1;fi;fi ;done 
}
delapndcl () {
echo $ip1|while read f1 f2;do f1d=$(echo $f1|sed 's/E//g') && f2d1=$(echo $f2|sed 's/[0 7-9A-Z]//g') && if [[ $(echo $f2d1|wc -L) == [1-6] ]]
then for zo in {1..6};do ary[$zo]=0;done && for ((ar=0;ar<=$(echo $f2d1|wc -L)-1;ar++));do ary[${f2d1:$ar:1}]=${f2d1:$ar:1};done
echo ${ary[*]} |sed 's/[ 0]//g' > data/$yr-$sc-$f1d.dat
else if [[ $(echo $f2d1|wc -L) == 0 ]];then rm -f data/$yr-$sc-$f1d.dat;else er=1;fi;fi ;done 
}
md=0 && while :;do
if [[ $md == 1 ]];then echo "Input Mode; year=$yr; sec=$sc";else echo "Type \"exit\" or Enter Year Sec." && echo "E.g. 3c [yr=3;sec=c]";fi
read ip
ip1=${ip^^} #&& echo $ip1 
if [[ ${ip1:0:1} == [2-4] ]] && [[ ${ip1:1:1} == [A-D] ]] ;then md=0 && er=0 && yr=${ip1:0:1} && sc=${ip1:1:1} && dcll;else er=1;fi 
if [[ ${ip1:0:1} == [2-4] ]] && [[ ${ip1:1:1} == "Y" ]] && [[ ${ip1:2:1} == [A-D] ]] ;then md=1 && er=0 && yr=${ip1:0:1} && sc=${ip1:2:1};else :;fi
if [[ $md == 1 ]] && [[ ${ip1:0:1} == "E" ]] && [[ ${ip1:1:1} == [1-9] ]] && [[ ${ip1:2:1} == [0-9] ]] && [[ $(echo $ip1|awk '{print $1}'|wc -L) == 3 ]];then delapndcl && er=0 && jb=1;else :;fi
if [[ $md == 1 ]] && [[ ${ip1:0:1} == "E" ]] && [[ ${ip1:1:1} == [1-9] ]] && [[ $(echo $ip1|awk '{print $1}'|wc -L) == 2 ]] && [[ $jb != 1 ]];then delapndcl && er=0 && jb=1;else :;fi
if [[ $md == 1 ]] && [[ ${ip1:0:1} == [1-9] ]] && [[ ${ip1:1:1} == [0-9] ]] && [[ $(echo $ip1|awk '{print $1}'|wc -L) == 2 ]] && [[ $jb != 1 ]];then adapndcl && er=0 && jb=1;else :;fi
if [[ $md == 1 ]] && [[ ${ip1:0:1} == [1-9] ]] && [[ $(echo $ip1|awk '{print $1}'|wc -L) == 1 ]] && [[ $jb != 1 ]] ;then adapndcl && er=0 && jb=1;else :;fi
if [[ $ip1 == OK ]] && [[ $md == 1 ]];then touch base/ok && er=0; else if [[ $ip1 == KO ]] && [[ $md == 1 ]];then rm -f base/ok && er=0;else :;fi;fi
if [[ $ip1 == SW ]] && [[ $md == 1 ]] && [[ $(echo $ip1|awk '{print $2}'|wc -L) == 0 ]];then dcll && er=0; else :;fi

if [[ ${ip^^} != "EXIT" ]];then :;else break;fi
if [[ $er == 1 ]];then clear && echo Input pattern \(or\) Mode is wrong\!;else :;fi && jb=0;done
