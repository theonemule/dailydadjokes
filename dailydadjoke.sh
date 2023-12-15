#!/bin/bash

echo "https://func-dadjokesaieastus2.azurewebsites.net/api/DadJokesAI_Functions?code=$DADJOKECODE"

response=$(curl -s "https://func-dadjokesaieastus2.azurewebsites.net/api/DadJokesAI_Functions?code=$DADJOKECODE")

echo $response

# p=${p//[$'\t\r\n']}

d1=$(date -d "00:00" -u +"%Y-%m-%dT%H:%M:%SZ")		
d2=$(date -d "00:00" -u +"%Y-%m-%d")
fname=$(echo "$d2-joke.md")
echo "---" > ./_posts/$fname
echo "layout: post" >> ./_posts/$fname
echo "title:  Daily Dad Joke 4U" >> ./_posts/$fname
echo "date:   $d1" >> ./_posts/$fname
echo "---" >> ./_posts/$fname
echo "$response" >> ./_posts/$fname

cat ./_posts/$fname
