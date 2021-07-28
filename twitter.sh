#!/bin/bash

#CONSUMER_KEY='your consumer key here'
#CONSUMER_SECRET='your consumer secret here'
#ACCESS_TOKEN='your access token here'
#ACCESS_TOKEN_SECRET='your token secret here'

# urlencode() by https://gist.github.com/cdown/1163649
urlencode() {
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

startDate="20210707"



let DIFF=$(( (`date -d "00:00" +%s` - `date -d $startDate +%s`) / (24*3600) ))

x=0
status=""
while read p; do
	x=$((x+1))
	if [ $x = $DIFF ];then		
		p=${p//[$'\t\r\n']}
		status=$p
	fi
	
done < general.txt


URL_POST='https://api.twitter.com/1.1/statuses/update.json'

# Gather the data that will be needed to sign and send the request
declare -A params
params=(
    ["oauth_consumer_key"]="$(urlencode "$CONSUMER_KEY")"
    ["oauth_nonce"]="$(urlencode "$(head -c32 /dev/urandom | base64)")"
    ["oauth_signature_method"]="$(urlencode 'HMAC-SHA1')"
    ["oauth_timestamp"]="$(date +%s)"
    ["oauth_token"]="$(urlencode "$ACCESS_TOKEN")"
    ["oauth_version"]="$(urlencode '1.0')"
    ["status"]="$(urlencode "$status 
	
http://www.dailydadjokes.net

#humor #dadjoke #dailydadjoke")")

# Another array to iterate the parameters in alphabetial order
declare -a params_order
params_order=("oauth_consumer_key" "oauth_nonce" "oauth_signature_method" "oauth_timestamp" "oauth_token" "oauth_version" "status")

# Generate the string that will be signed
params_string=""

for param in "${params_order[@]}"; do
    if ! [ -z "$params_string" ]; then
        params_string+='&'
    fi

    params_string+="$param=${params[$param]}"
done

signature_string="POST&"
signature_string+="$(urlencode "$URL_POST")&"
signature_string+="$(urlencode "$params_string")"

# Generate the signing key
sign_key="$(urlencode "$CONSUMER_SECRET")&$(urlencode "$ACCESS_TOKEN_SECRET")"

# Get the signature
signature="$(echo -n "$signature_string" | openssl dgst -binary -sha1 -hmac "$sign_key" | base64)"

# Generate the OAuth Authorization header
oauth_header=""

for param in "${params_order[@]}"; do
    if [ "$param" != "status" ]; then
        if ! [ -z "$oauth_header" ]; then
            oauth_header+=', '
        fi

        oauth_header+="$param=\"${params[$param]}\""
    fi
done

oauth_header="OAuth $oauth_header, oauth_signature=\"$(urlencode "$signature")\""

curl_output=$(curl -X POST -w '\n%{http_code}' -d "status=${params["status"]}" "$URL_POST" --header "Content-Type: application/x-www-form-urlencoded" --header "Authorization: $oauth_header" 2>/dev/null)

resp_data=()
while read -r line; do
    resp_data+=("$line")
done <<< "$curl_output"

if [ "${resp_data[1]}" -ne 200 ]; then
    die "POST to Twitter API failed (HTTP code ${resp_data[1]}):\n${resp_data[0]}"
fi