#!/bin/bash

startDate="20231121"

let DIFF=$(( (`date -d "00:00" +%s` - `date -d $startDate +%s`) / (24*3600) ))

x=0
while read p; do
	x=$((x+1))
	if [ $x = $DIFF ];then		
		p=${p//[$'\t\r\n']}
		d1=$(date -d "00:00" -u +"%Y-%m-%dT%H:%M:%SZ")		
		#d1=$(date -d "$startDate +$x days" +"%Y-%m-%dT%H:%M:%SZ")		
		d2=$(date -d "00:00" -u +"%Y-%m-%d")
		#d2=$(date -d "$startDate +$x days" +"%Y-%m-%d")
		fname=$(echo "$d2-joke.md")
		echo "---" > ./_posts/$fname
		echo "layout: post" >> ./_posts/$fname
		echo "title:  Daily Dad Joke 4U" >> ./_posts/$fname
		echo "date:   $d1" >> ./_posts/$fname
		echo "---" >> ./_posts/$fname
		echo "$p" >> ./_posts/$fname
		# json=$(jq --arg d "$d" --arg t "$p" '. + {date:$d} + {text:$t}'<<<"{}")
		# echo $json
		# echo $(cat ./docs/jokehistory.js | jq --argjson jk "$json" '.history += [$jk]') > ./docs/jokehistory.js
	fi
	
done < ./general.txt
