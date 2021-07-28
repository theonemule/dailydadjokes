#!/bin/bash

startDate="20210714"



let DIFF=$(( (`date -d "00:00" +%s` - `date -d $startDate +%s`) / (24*3600) ))
#echo $DIFF

x=0
while read p; do
	x=$((x+1))
	if [ $x = $DIFF ];then
		echo "$p"
		p=${p//[$'\t\r\n']}
		echo $(cat jokehistory.js | jq --arg jk "$p" '.history += [$jk]') > jokehistory.js
	fi
	
done < general.txt