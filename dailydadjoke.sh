#!/bin/bash

startDate="20210707"



let DIFF=$(( (`date -d "00:00" +%s` - `date -d $startDate +%s`) / (24*3600) ))

x=0
while read p; do
	x=$((x+1))
	if [ $x = $DIFF ];then		
		p=${p//[$'\t\r\n']}
		d=$(date -d "00:00" -u +"%Y-%m-%dT%H:%M:%SZ")
		json=$(jq --arg d "$d" --arg t "$p" '. + {date:$d} + {text:$t}'<<<"{}")
		echo $json
		echo $(cat ./docs/jokehistory.js | jq --argjson jk "$json" '.history += [$jk]') > ./docs/jokehistory.js
	fi
	
done < general.txt
