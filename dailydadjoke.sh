#!/bin/bash

response=$(curl -s "https://func-dadjokesaieastus2.azurewebsites.net/api/DadJokesAI_Functions?code=$DADJOKECODE")

p=${p//[$'\t\r\n']}
d1=$(date -d "00:00" -u +"%Y-%m-%dT%H:%M:%SZ")		
d2=$(date -d "00:00" -u +"%Y-%m-%d")
fname=$(echo "$d2-joke.md")
echo "---" > ./_posts/$fname
echo "layout: post" >> ./_posts/$fname
echo "title:  Daily Dad Joke 4U" >> ./_posts/$fname
echo "date:   $d1" >> ./_posts/$fname
echo "---" >> ./_posts/$fname
echo "$p" >> ./_posts/$fname
